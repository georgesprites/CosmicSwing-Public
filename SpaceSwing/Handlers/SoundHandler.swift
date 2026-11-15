//
//  SoundHandler.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 5/24/24.
//

import Foundation
import SpriteKit
import AVFoundation


class SoundHandler {
    
    
    private var chargePlayer: AVAudioPlayer?
    private var isChargingSoundPlaying = false

    let chargeLoopFileName = "shipChargingEffect4" // <-- your file (mp3/wav)
    
     var audioPlayer: AVAudioPlayer?  // Declare an optional audio player

     var alreadyPlayingInitialSound = false
    
    let initialSoundFileName = "Galactic Swing (Singularity Mix)-[AudioTrimmer.com]"
    //"Pixel Pumkin - DowntempoHalloween - Royalty Free Music"
    private let defaultVolume: Float = 1.0   // Default volume when audio is ON

    
    func startChargeLoop() {
        guard SharedInfo.SharedInstance.audioEnabled else { return }
        guard !isChargingSoundPlaying else { return }

        guard let url = Bundle.main.url(forResource: chargeLoopFileName, withExtension: "mp3") else {
            print("Unable to locate charge loop file.")
            return
        }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1
            p.enableRate = true          // ✅ required for rate changes
            p.rate = 1.0                 // base speed
            //p.volume = 0.25              // tune
            p.prepareToPlay()
            p.play()

            chargePlayer = p
            isChargingSoundPlaying = true
        } catch {
            print("Error loading charge loop: \(error.localizedDescription)")
        }
    }

    /// Call this repeatedly while charging (e.g. each drag update)
    /// scaledValue: 0..100
    func updateChargeLoop(scaledValue: Int) {
        guard SharedInfo.SharedInstance.audioEnabled else { return }
        guard let p = chargePlayer, isChargingSoundPlaying else { return }

        
        let clamped = max(0, min(scaledValue, 100))
        let t = Float(clamped) / 100.0

        // Smooth ramp so it feels natural (more change near the end)
        let eased = t * t

        // Rate range: 1.0 → 1.8 (tweak to taste; keep < 2.0 usually)
        let minRate: Float = 1.0
        let maxRate: Float = 5.8
        p.rate = minRate + (maxRate - minRate) * eased

        // Optional: tiny volume lift near full charge
        let minVol: Float = 0.22
        let maxVol: Float = 0.35
        //p.volume = minVol + (maxVol - minVol) * eased
    }

    func stopChargeLoop() {
        guard let p = chargePlayer else { return }
        p.stop()
        chargePlayer = nil
        isChargingSoundPlaying = false
    }
    
     func playInitialSound() {
         
         if(SharedInfo.SharedInstance.audioEnabled && alreadyPlayingInitialSound == false) {
         // Ensure the file exists in the bundle
         guard let soundURL = Bundle.main.url(forResource: initialSoundFileName, withExtension: "mp3") else {
             print("Unable to locate the audio file.")
             return
         }
         
         do {
             // Initialize the audio player
             audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
             audioPlayer?.numberOfLoops = -1  // Repeat indefinitely
             audioPlayer?.prepareToPlay() // Prepare to play the audio
             
             if (SharedInfo.SharedInstance.playInitialSong) {
                 
                 audioPlayer?.play()

             }
             
             audioPlayer?.volume = 0.1 // Play the audio
             alreadyPlayingInitialSound = true
         } catch {
             print("Error loading audio file: \(error.localizedDescription)")
         }
             
         }
     }
    
    func playSoundWithName(fileName: String)->SKAction{
        
        
            var soundToPlay = SKAction()
        
        
            if(SharedInfo.SharedInstance.audioEnabled) {
                soundToPlay = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
                }
        
        return soundToPlay
    }
    
    func toggleAudio() {
        
        
        if let player = audioPlayer {} else {
            if(alreadyPlayingInitialSound == false){
                
                guard let soundURL = Bundle.main.url(forResource: initialSoundFileName, withExtension: "mp3") else {
                    print("Unable to locate the audio file.")
                    return
                }
                
                do {
                    // Initialize the audio player
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.numberOfLoops = -1  // Repeat indefinitely
                    audioPlayer?.prepareToPlay() // Prepare to play the audio
                    audioPlayer?.play()
                    audioPlayer?.volume = 0.1// Play the audio
                    alreadyPlayingInitialSound = true
                } catch {
                    print("Error loading audio file: \(error.localizedDescription)")
                } }
        }
        
        if SharedInfo.SharedInstance.audioEnabled {
            
            
            
            audioPlayer!.volume = defaultVolume  // Restore to normal volume
            print("Audio is ON.")
        } else {
            audioPlayer!.volume = 0.0  // Mute the audio
            print("Audio is OFF.")
        }
    }
    
    
}
