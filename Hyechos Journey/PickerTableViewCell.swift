//
//  PickerTableViewCell.swift
//  Hyechos Journey
//
//  Created by Bailey Case on 2/9/2017
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit
import AVFoundation

class PickerTableViewCell : UITableViewCell {
    var isObserving = false;
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var audioPlayerStackView: UIStackView!
    @IBOutlet weak var audioControlStackView: UIStackView!
    
    var progressUpdateTimer = Timer()
    var assetName = "Moonlight"
    
    private var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.rate = currentPlaybackRate
            audioPlayer?.enableRate = true
            //Pre buffer audio
            audioPlayer?.prepareToPlay()
            
            progressBar.minimumValue = 0
            progressBar.maximumValue = Float(audioPlayer!.duration)
            
            currentTimeLabel.text = (0.0).timeString
            remainingTimeLabel.text = audioPlayer?.duration.timeString
        }
    }
    var currentPlaybackRate:Float = 1.0 {
        didSet {
            audioPlayer?.rate = currentPlaybackRate
        }
    }
    
    //these need to be made variable based on how much text there is in the header
    class var expandedHeight: CGFloat { get { return 750 } }
    class var defaultHeight: CGFloat  { get { return 50  } }
    
    
    
    func checkHeight() {
        contentLabel.isHidden = (frame.size.height < PickerTableViewCell.expandedHeight)
        audioPlayerStackView.isHidden = (frame.size.height < PickerTableViewCell.expandedHeight)
        audioControlStackView.isHidden = (frame.size.height < PickerTableViewCell.expandedHeight)
        if frame.size.height == PickerTableViewCell.expandedHeight {
            let moonlight = NSDataAsset(name: assetName)!
            audioPlayer = try! AVAudioPlayer(data: moonlight.data)
        }
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    @IBAction func progressBarDidChange(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateProgressBar()
    }
    
    @IBAction func didPressPlay(_ sender: UIButton) {
        audioPlayer?.play()
        startTimer()
    }
    
    @IBAction func didPressPause(_ sender: UIButton) {
        audioPlayer?.pause()
        stopTimer()
    }
    
    /**
     Updates the position of the progress bar and time labels.
     */
    func updateProgressBar() {
        progressBar.value = Float(audioPlayer?.currentTime ?? 0)
        
        currentTimeLabel.text = audioPlayer?.currentTime.timeString ?? (0.0).timeString
        remainingTimeLabel.text = ((audioPlayer?.duration ?? 0.0) - (audioPlayer?.currentTime ?? 0.0)).timeString
    }
    
    /**
     Starts timer which calls updateProgressBar every 0.25 seconds
     */
    func startTimer() {
        if !progressUpdateTimer.isValid {
            progressUpdateTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateProgressBar) , userInfo: nil, repeats: true)
        }
    }
    
    /**
     Invalidates updateProgressBar timer.
     */
    func stopTimer() {
        if progressUpdateTimer.isValid {
            progressUpdateTimer.invalidate()
        }
    }
}
