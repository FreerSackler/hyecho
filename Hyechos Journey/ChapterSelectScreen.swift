//
//  ChapterSelectScreen.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 5/18/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class ChapterSelectScreen: UIViewController {
    
    @IBOutlet weak var chapterOne: UIButton!
    @IBOutlet weak var chapterTwo: UIButton!
    @IBOutlet weak var chapterThree: UIButton!
    @IBOutlet weak var chapterFour: UIButton!
    @IBOutlet weak var chapterFive: UIButton!
    @IBOutlet weak var chapterSix: UIButton!
    @IBOutlet weak var chapterSeven: UIButton!
    @IBOutlet weak var chapterEight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "295486")
        
        
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        DataController.sharedData.menuView.cellBackgroundColor = UIColor(hexString: "295486")
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        
        
        let items = ToolBarInfo.shared.getBarButtons()
       
        self.navigationController?.isToolbarHidden = true
        self.setToolbarItems(items, animated: true)
        ToolBarInfo.shared.buttonActions[1] = didPressChapterSelectionButton
        
        var plist = DataController.sharedData.plist
        
        chapterOne.setTitle((plist[0]["Chapter"] as? String)!, for: .normal)
        chapterTwo.setTitle((plist[1]["Chapter"] as? String)!, for: .normal)
        chapterThree.setTitle((plist[2]["Chapter"] as? String)!, for: .normal)
        chapterFour.setTitle((plist[3]["Chapter"] as? String)!, for: .normal)
        chapterFive.setTitle((plist[4]["Chapter"] as? String)!, for: .normal)
        chapterSix.setTitle((plist[5]["Chapter"] as? String)!, for: .normal)
        chapterSeven.setTitle((plist[6]["Chapter"] as? String)!, for: .normal)
        chapterEight.setTitle((plist[7]["Chapter"] as? String)!, for: .normal)
    }
    
    @IBAction func didPressChapterOne(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 0)
    }
    
    @IBAction func didPressChapterTwo(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 1)
    }
    
    @IBAction func didPressChapterThree(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 2)
    }
    
    @IBAction func didPressChapterFour(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 3)
    }
    
    @IBAction func didPressChapterFive(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 4)
    }
    
    @IBAction func didPressChapterSix(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 5)
    }
    
    @IBAction func didPressChapterSeven(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 6)
    }
    
    @IBAction func didPressChapterEight(_ sender: UIButton) {
        performSegue(withIdentifier: "toChapterInfo", sender: 7)
    }
    
    func didPressChapterSelectionButton(sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ChapterSelectScreen {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "295486")
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        DataController.sharedData.menuView.cellBackgroundColor = UIColor(hexString: "295486")
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        
        self.navigationController?.isToolbarHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
                if let destination = segue.destination as? ChapterViewController {
            destination.chapter = sender as! Int
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
}
