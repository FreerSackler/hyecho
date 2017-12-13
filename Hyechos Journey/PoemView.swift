//
//  PoemView.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 8/16/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PoemView: UIView {
    
    private static let play = #imageLiteral(resourceName: "RightArrowBlack")
    private static let pause = #imageLiteral(resourceName: "PauseButton")
    
    @IBOutlet weak var textLabel: UITextView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider! {
        didSet {
            progressSlider.setThumbImage(#imageLiteral(resourceName: "ThumbSmall"), for: .normal)
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var startedPlaying : Bool = false
    var expanded: Bool = false
    var audioPath: String? {
        didSet {
            createAudioPlayer()
        }
    }
    var time: Double {
        get {
            return audioPlayer?.currentTime ?? 0
        }
        set {
            if audioPlayer == nil {
                createAudioPlayer()
            }
            audioPlayer!.currentTime = newValue
            timeLabel.text = "-" + (audioPlayer!.duration - newValue).timeString
            progressSlider.value = Float(audioPlayer!.currentTime / audioPlayer!.duration)
        }
    }
    
    private var paused = true
    private var audioPlayer: AVAudioPlayer?
    private var progressUpdateTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(forName: Notification.Name("PauseAllAudio"), object: nil, queue: nil) {
            notification in
            if !self.paused {
                self.didPressPlayPause(UIButton())
            }
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if audioPlayer != nil {
            endProgressTimer()
            audioPlayer?.setVolume(0, fadeDuration: 0.25)
            DispatchQueue.main.asyncAfter(deadline:  DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 250 * NSEC_PER_MSEC)) {
                self.audioPlayer?.pause()
            }
        }
    }
    
    func updateProgress() {
        if audioPlayer == nil {
            endProgressTimer()
            return
        }
        let totalTime = audioPlayer!.duration
        let progress = audioPlayer!.currentTime / totalTime
        if (startedPlaying && audioPlayer!.currentTime == 0.0) {
            didPressPlayPause(UIButton())
        }
        if (!startedPlaying && audioPlayer!.currentTime != 0.0){
            startedPlaying = true
        }
        progressSlider.value = Float(progress)
        // print(Float(progress))
        
        timeLabel.text = "-" + (audioPlayer!.duration - audioPlayer!.currentTime).timeString
        
    }
    
    private func startProgressTimer() {
        endProgressTimer()
        progressUpdateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ExpandingTextCell.updateProgress), userInfo: nil, repeats: true)
    }
    
    private func endProgressTimer() {
        guard let timer = progressUpdateTimer else {
            return
        }
        timer.invalidate()
    }
    
    private func createAudioPlayer() {
        guard let path = audioPath else {
            print(#file, #function, #line, "MISSING AUDIO PATH")
            return
        }
        guard let asset = NSDataAsset(name: path) else {
            print(#file, #function, #line, "MISSING ASSET: \(path)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: asset.data)
        } catch {
            print(#file, #function, #line, "ERROR OPENING AUDIO: ", error)
            return
        }
        audioPlayer!.volume = 1
        audioPlayer!.currentTime = time
        time = audioPlayer!.currentTime
    }
    
    @IBAction func didPressPlayPause(_ sender: UIButton) {
        startedPlaying = false
        if paused {
            //Pause all other audio players
            NotificationCenter.default.post(name: Notification.Name("PauseAllAudio"), object: nil)
        }
        
        paused = !paused
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Could not set AVAudioSession category. Will not play sound when phone is muted.")
        }
        if paused {
            UIView.transition(with: playPauseButton, duration: 0.25, options: .transitionFlipFromLeft, animations: {
                self.playPauseButton.setImage(PoemView.play, for: .normal)
            }, completion: nil)
        } else {
            UIView.transition(with: playPauseButton, duration: 0.25, options: .transitionFlipFromRight, animations: {
                self.playPauseButton.setImage(PoemView.pause, for: .normal)
            }, completion: nil)
        }
        if audioPlayer == nil {
            createAudioPlayer()
        }
        //Can assume it is not nil now
        let player = audioPlayer!
        player.volume = 1
        if paused {
            player.pause()
            endProgressTimer()
        } else {
            player.play()
            startProgressTimer()
        }
    }
    /*
     @IBAction func didPressReload(_ sender: UIButton) {
     guard let player = audioPlayer else {
     //Can't reload non existent player
     return
     }
     player.currentTime = 0
     if paused {
     didPressPlayPause(sender)
     }
     UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
     self.reloadButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
     }, completion: nil)
     UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
     self.reloadButton.transform = CGAffineTransform(rotationAngle: 0)
     }, completion: nil)
     }*/
    
    @IBAction func didStartMovingSlider(_ sender: UISlider) {
        sender.setThumbImage(#imageLiteral(resourceName: "ThumbLarge"), for: .normal)
        if audioPlayer == nil {
            createAudioPlayer()
        }
        if !paused {
            endProgressTimer()
            audioPlayer!.pause()
        }
    }
    
    @IBAction func didEndMovingSlider(_ sender: UISlider) {
        sender.setThumbImage(#imageLiteral(resourceName: "ThumbSmall"), for: .normal)
        time = Double(sender.value) * audioPlayer!.duration
        if !paused {
            audioPlayer!.play()
            startProgressTimer()
        }
    }
    
    @IBAction func didCancelMovingSlider(_ sender: UISlider) {
        sender.setThumbImage(#imageLiteral(resourceName: "ThumbSmall"), for: .normal)
        if !paused {
            audioPlayer!.play()
            startProgressTimer()
        }
    }
    
    @IBAction func didMoveSlider(_ sender: UISlider) {
        timeLabel.text = "-" + (audioPlayer!.duration - Double(sender.value) * audioPlayer!.duration).timeString
    }
    
}
