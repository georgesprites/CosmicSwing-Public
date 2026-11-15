import SpriteKit

private var savedDynamicStateKey: UInt8 = 0
private var savedVelocityKey: UInt8 = 1
private var savedAngularVelocityKey: UInt8 = 2

extension SKPhysicsBody {
    // MARK: - Saved States
    private var savedIsDynamic: Bool? {
        get {
            return objc_getAssociatedObject(self, &savedDynamicStateKey) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &savedDynamicStateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var savedVelocity: CGVector? {
        get {
            return objc_getAssociatedObject(self, &savedVelocityKey) as? CGVector
        }
        set {
            objc_setAssociatedObject(self, &savedVelocityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var savedAngularVelocity: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &savedAngularVelocityKey) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &savedAngularVelocityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Save State
    func savePhysicsState() {
        savedIsDynamic = self.isDynamic
        if self.isDynamic {
            savedVelocity = self.velocity
            savedAngularVelocity = self.angularVelocity
        }
    }
    
    // MARK: - Restore State
    func restorePhysicsState() {
        if let savedState = savedIsDynamic {
            self.isDynamic = savedState
            if savedState { // Only restore velocity if body is dynamic
                if let velocity = savedVelocity {
                    self.velocity = velocity
                }
                if let angularVelocity = savedAngularVelocity {
                    self.angularVelocity = angularVelocity
                }
            }
        }
    }
}
