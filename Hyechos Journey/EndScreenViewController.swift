//
//  EndScreenViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 7/25/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class EndScreenViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add stuff
        self.navigationController?.isNavigationBarHidden = false
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
        DataController.sharedData.savedChapterSpot = -1
    }
    @IBAction func toJourneySelect(_ sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is JourneySelectScreen {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func toResources(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LearnMore", bundle: nil)
        let interaction = storyboard.instantiateViewController(withIdentifier: "LearnMore")
        self.navigationController?.pushViewController(interaction, animated: true)
    }
    
}
