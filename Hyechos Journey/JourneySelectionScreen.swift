//
//  ChapterSelectScreen.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 5/18/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation

import UIKit

class JourneySelectScreen: UIViewController {
    
    @IBOutlet weak var linearJourneyButton: UIButton!
    
    
    @IBOutlet weak var resumeButtonWidth: NSLayoutConstraint!
    var adjusted : Bool = false
    
    @IBAction func traceJourney() {
        performSegue(withIdentifier: "toChapter", sender: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toChapter") {
            if let destination = segue.destination as? ChapterViewController {
                destination.chapter = 0
                DataController.sharedData.linearJourney = true
                
                
                if (DataController.sharedData.savedChapterSpot != -1) {
                    destination.chapter = DataController.sharedData.savedChapterSpot
                }
            }
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (DataController.sharedData.savedChapterSpot != -1) {
            linearJourneyButton.setTitle("RESUME", for: .normal)
            if (!adjusted) {
                resumeButtonWidth.constant = resumeButtonWidth.constant + 10
                adjusted = true
            }
        }
        else {
            linearJourneyButton.setTitle("GO!", for: .normal)
            if (adjusted) {
                adjusted = false
                resumeButtonWidth.constant -= 10
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "295486")
        DataController.sharedData.menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        
        if (DataController.sharedData.savedChapterSpot != -1) {
            linearJourneyButton.setTitle("RESUME", for: .normal)
            if (!adjusted) {
                //resumeButtonWidth.constant = resumeButtonWidth.constant + 10
                adjusted = true
            }
        }
        else {
            linearJourneyButton.setTitle("GO!", for: .normal)
            if (adjusted) {
                adjusted = false
                resumeButtonWidth.constant -= 10
            }
        }
        
        DataController.sharedData.linearJourney = false
        
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    

}
