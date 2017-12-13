//
//  Preferences.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 3/28/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit
import AVFoundation

class Preferences {
    static var shared: Preferences = Preferences()
    
    private static var hasDisplayedHeadphonesPopupKey = "hasDisplayedHeadphonesPopup"
    private static var hasLaunchedBeforeKey = "hasLaunchedBefore"
    private static var discoveredItemsKey = "discoveredItems"
    
    var chapterViewControllerModel = Array<[ChapterViewController.CellModel]?>(repeating: nil, count: 8)
    
    /**
     True if the headphones popup has been displayed before.
    */
    var hasDisplayedHeadphonesPopup:Bool = false
    
    /**
     True if this is not the first time the user has opened the app
    */
    var hasLaunchedBefore = false
    
    /**
     The images which have been favorited by the user.
    */
    var discoveredItems:[String] = []
    
    var hasHeadphones: Bool {
        return AVAudioSession.sharedInstance().currentRoute.outputs.contains(where:{$0.portType == AVAudioSessionPortHeadphones})
    }

    init() {
        load()
    }
    
    /**
     Sets preferences according to the values saved on disk
    */
    func load() {
        hasDisplayedHeadphonesPopup = UserDefaults.standard.bool(
            forKey: Preferences.hasDisplayedHeadphonesPopupKey
        )
        
        hasLaunchedBefore = UserDefaults.standard.bool(forKey: Preferences.hasLaunchedBeforeKey)
        
        discoveredItems = (UserDefaults.standard.array(forKey: Preferences.discoveredItemsKey) as? [String]) ?? []
    }
    
    /**
     Saves preferences to disk
    */
    func save() {
        UserDefaults.standard.set(hasDisplayedHeadphonesPopup, forKey: Preferences.hasDisplayedHeadphonesPopupKey)
        
        UserDefaults.standard.set(hasLaunchedBefore, forKey: Preferences.hasLaunchedBeforeKey)
        
        UserDefaults.standard.set(discoveredItems, forKey: Preferences.discoveredItemsKey)
        
        //Tells system to write the UserDefaults.standard to disk
        UserDefaults.standard.synchronize()
    }
}
