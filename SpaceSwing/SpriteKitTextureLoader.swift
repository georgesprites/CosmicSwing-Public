//
//  SpriteKitTextureLoader.swift
//
//  A robust background texture/atlas preloader for SpriteKit.
//  - Preloads multiple atlases off the main thread
//  - Optional "warm-up" to eliminate first-use hitches
//  - Progress + completion callbacks on the main thread
//  - Thread-safe atlas/texture access with NSCache
//

import SpriteKit
#if canImport(UIKit)
import UIKit
#endif

public final class SpriteKitTextureLoader {
    public static let shared = SpriteKitTextureLoader()

    private let workQueue = DispatchQueue(label: "texloader.queue", qos: .userInitiated)
    private let lock = NSLock()

    // Loaded atlases by name
    private var atlases: [String: SKTextureAtlas] = [:]

    // Optional per-texture cache for fast reuse (tune limits for your content)
    private let textureCache = NSCache<NSString, SKTexture>()

    private init() {
        textureCache.countLimit = 4_000
        textureCache.totalCostLimit = 256 * 1024 * 1024 // ~256MB budget (approx; adjust for target devices)

        #if canImport(UIKit)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
        #endif
    }

    deinit {
        #if canImport(UIKit)
        NotificationCenter.default.removeObserver(self)
        #endif
    }

    // MARK: - Public API

    /// Preload a list of atlas names (without `.atlas`) off the main thread.
    /// - Parameters:
    ///   - names: Atlas folder names in your asset catalog or bundle.
    ///   - warmTextures: If true, preloads every texture in each atlas into GPU memory.
    ///   - progress: Called on the main thread with [0, 1] as each atlas completes.
    ///   - completion: Called on the main thread when all atlases are ready.
    public func preloadAtlases(
        _ names: [String],
        warmTextures: Bool = true,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping () -> Void
    ) {
        guard !names.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }

        workQueue.async { [weak self] in
            guard let self = self else { return }

            let uniqueNames = Array(Set(names))
            var pairs = [(name: String, atlas: SKTextureAtlas)]()
            pairs.reserveCapacity(uniqueNames.count)

            // Build atlas objects (I/O) off the main thread
            for name in uniqueNames {
                let atlas = SKTextureAtlas(named: name)
                self.lock.lock()
                self.atlases[name] = atlas
                self.lock.unlock()
                pairs.append((name, atlas))
            }

            let group = DispatchGroup()
            var completed = 0
            let total = Double(pairs.count)

            for (name, atlas) in pairs {
                group.enter()
                atlas.preload { [weak self] in
                    guard let self = self else { group.leave(); return }

                    if warmTextures {
                        // Warm every texture to avoid first-use GPU hitching
                        let namesList = atlas.textureNames
                        let texPairs: [(String, SKTexture)] = namesList.map { ($0, atlas.textureNamed($0)) }

                        SKTexture.preload(texPairs.map { $0.1 }) { [weak self] in
                            self?.cache(textures: texPairs, atlasName: name)
                            completed += 1
                            DispatchQueue.main.async { progress?(Double(completed) / total) }
                            group.leave()
                        }
                    } else {
                        completed += 1
                        DispatchQueue.main.async { progress?(Double(completed) / total) }
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                completion()
            }
        }
    }
    public func fastPreloadAtlases(
        _ names: [String],
        warmTextures: Bool = true,
        completion: @escaping () -> Void
    ) {
        guard !names.isEmpty else {
            DispatchQueue.main.async(group: nil, qos: .unspecified, flags: [], execute: completion)
            return
        }

        workQueue.async(group: nil, qos: .userInitiated, flags: [], execute: { [weak self] in
            guard let self = self else { return }

            SKTextureAtlas.preloadTextureAtlasesNamed(names, withCompletionHandler: { error,atlases  in
                self.workQueue.async(group: nil, qos: .userInitiated, flags: [], execute: { [weak self] in
                    guard let self = self else { return }

                    if warmTextures {
                        let group = DispatchGroup()

                        for (i, atlas) in atlases.enumerated() {
                            let key = names[i]

                            self.lock.lock()
                            self.atlases[key] = atlas
                            self.lock.unlock()

                            group.enter()
                            let namesList = atlas.textureNames
                            let texPairs: [(String, SKTexture)] = namesList.map { ($0, atlas.textureNamed($0)) }

                            SKTexture.preload(texPairs.map { $0.1 }, withCompletionHandler: { [weak self] in
                                self?.cache(textures: texPairs, atlasName: key)
                                group.leave()
                            })
                        }

                        group.notify(queue: .main) {
                            completion()
                        }
                    } else {
                        for (i, atlas) in atlases.enumerated() {
                            let key = names[i]
                            self.lock.lock()
                            self.atlases[key] = atlas
                            self.lock.unlock()
                        }
                        DispatchQueue.main.async(group: nil, qos: .unspecified, flags: [], execute: completion)
                    }
                })
            })
        })
    }
    /// Thread-safe fetch. Returns a live texture even if not pre-warmed.
    public func texture(named name: String, inAtlas atlasName: String) -> SKTexture {
        let cacheKey = "\(atlasName)::\(name)" as NSString
        if let cached = textureCache.object(forKey: cacheKey) {
            return cached
        }

        // Ensure we have an atlas (create if missing)
        lock.lock()
        let atlas = atlases[atlasName] ?? SKTextureAtlas(named: atlasName)
        atlases[atlasName] = atlas
        lock.unlock()

        let tex = atlas.textureNamed(name)
        textureCache.setObject(tex, forKey: cacheKey, cost: estimatedCost(for: tex))
        return tex
    }

    /// Clear caches. Set `all: true` to drop atlas references as well.
    public func purge(all: Bool = false) {
        textureCache.removeAllObjects()
        if all {
            lock.lock()
            atlases.removeAll()
            lock.unlock()
        }
    }

    // MARK: - Internals

    private func cache(textures: [(String, SKTexture)], atlasName: String) {
        for (name, tex) in textures {
            let key = "\(atlasName)::\(name)" as NSString
            textureCache.setObject(tex, forKey: key, cost: estimatedCost(for: tex))
        }
    }

    private func estimatedCost(for texture: SKTexture) -> Int {
        // Approximate memory footprint: width * height * 4 bytes (RGBA8) in points.
        // (Good enough for NSCache budgeting; GPU memory may differ.)
        let s = texture.size()
        let bytes = Int(max(1, s.width * s.height) * 4.0)
        return bytes
    }

    #if canImport(UIKit)
    @objc private func handleMemoryWarning() {
        // Drop textures first; keep atlas objects for fast re-hydration.
        textureCache.removeAllObjects()
    }
    #endif
    
    
    
    /// Build an ordered array of textures from a zero-padded numeric range.
     /// Example: frames(inAtlas:"ShipAnimation", range:1...9, digits:4) -> 0001..0009
     func frames(
         inAtlas atlasName: String,
         range: ClosedRange<Int>,
         digits: Int,
         prefix: String = "",
         suffix: String = ""
     ) -> [SKTexture] {
         // Ensure the atlas object exists
         lock.lock()
         let atlas = atlases[atlasName] ?? SKTextureAtlas(named: atlasName)
         atlases[atlasName] = atlas
         lock.unlock()

         // Fast existence check against names in the atlas
         let available = Set(atlas.textureNames)

         var result = [SKTexture]()
         result.reserveCapacity(range.count)

         for i in range {
             let num = String(format: "%0*d", digits, i)
             let name = "\(prefix)\(num)\(suffix)"
             if available.contains(name) {
                 let tex = atlas.textureNamed(name)
                 // prime cache (optional; harmless if already cached)
                 let key = "\(atlasName)::\(name)" as NSString
                 textureCache.setObject(tex, forKey: key, cost: estimatedCost(for: tex))
                 result.append(tex)
             } else {
                 // If a frame is missing, stop early to avoid gaps
                 break
             }
         }
         return result
     }

     /// Auto-detect all frames in an atlas that match a pattern:
     ///   prefix + (exactly `digits` digits) + suffix
     /// Sorts numerically and returns textures in order.
     /// Example: autoFrames(inAtlas:"ShipAnimation", digits:4) matches 0001..0048
     func autoFrames(
         inAtlas atlasName: String,
         digits: Int,
         prefix: String = "",
         suffix: String = ""
     ) -> [SKTexture] {
         lock.lock()
         let atlas = atlases[atlasName] ?? SKTextureAtlas(named: atlasName)
         atlases[atlasName] = atlas
         lock.unlock()

         // Build regex like ^prefix(\d{4})suffix$
         let pattern = "^\(NSRegularExpression.escapedPattern(for: prefix))(\\d{\(digits)})\(NSRegularExpression.escapedPattern(for: suffix))$"
         let rx = try? NSRegularExpression(pattern: pattern, options: [])

         // Collect (number, name)
         var numbered: [(Int, String)] = []
         for name in atlas.textureNames {
             guard let rx = rx else { continue }
             let range = NSRange(location: 0, length: (name as NSString).length)
             if let m = rx.firstMatch(in: name, options: [], range: range),
                m.numberOfRanges >= 2,
                let r = Range(m.range(at: 1), in: name),
                let n = Int(name[r]) {
                 numbered.append((n, name))
             }
         }

         // Sort numerically ascending
         numbered.sort { $0.0 < $1.0 }

         // Map to textures (and prime cache)
         var frames: [SKTexture] = []
         frames.reserveCapacity(numbered.count)
         for (_, name) in numbered {
             let tex = atlas.textureNamed(name)
             let key = "\(atlasName)::\(name)" as NSString
             textureCache.setObject(tex, forKey: key, cost: estimatedCost(for: tex))
             frames.append(tex)
         }
         return frames
     }

     /// Convenience: build an SKAction.animate with either a fixed range or auto-detected set.
     /// If `range` is nil, it uses `autoFrames`.
     func animation(
         inAtlas atlasName: String,
         range: ClosedRange<Int>? = nil,
         digits: Int,
         prefix: String = "",
         suffix: String = "",
         timePerFrame: TimeInterval,
         resize: Bool = true,
         restore: Bool = true
     ) -> SKAction {
         let frames: [SKTexture]
         if let r = range {
             frames = self.frames(inAtlas: atlasName, range: r, digits: digits, prefix: prefix, suffix: suffix)
         } else {
             frames = self.autoFrames(inAtlas: atlasName, digits: digits, prefix: prefix, suffix: suffix)
         }
         return SKAction.animate(with: frames, timePerFrame: timePerFrame, resize: resize, restore: restore)
     }
    
}
