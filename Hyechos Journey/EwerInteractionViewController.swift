//
//  EwerInteractionViewController.swift
//  Hyechos Journey
//
//  Created by Eric Yeh on 2017/7/7.
//  Copyright © 2017年 hyecho. All rights reserved.
//

import SpriteKit
import UIKit

class EwerViewController : UIViewController {
    
    
    @IBOutlet weak var gameView: SKView!
    
    var scene = EwerGameScene()
    
    @objc func toNextChapter(sender: UIButton) {
        gameView.isPaused = true
        DataController.sharedData.createAlertButton(
            viewController: self,
            onCancel: {
                self.gameView.isPaused = false
            },
            action: {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is ChapterViewController {
                        let chapterController = aViewController as! ChapterViewController
                        if (chapterController.chapter != 7) {
                            chapterController.chapter += 1
                        }
                        chapterController.setupChapter()
                        
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
        //let scene = SKScene(fileNamed: "MedicineBuddhaGameScene") as! MedicineBuddhaGameScene
        
        let scene = SKScene(fileNamed: "EwerGameScene") as! EwerGameScene
        
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)
        
        let tabBarItems = ToolBarInfo.shared.getBarButtons()
        if (DataController.sharedData.linearJourney) {
            let button = tabBarItems[tabBarItems.count - 2].customView as! UIButton
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).setImage(UIImage(named: "NextChapterButton"), for: .normal)
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).frame = CGRect(x: 0, y: 0, width: 170, height: 25)
            if #available(iOS 11, *) {
                button.removeConstraints(button.constraints)
                button.widthAnchor.constraint(equalToConstant: 170).isActive = true
                button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            }
        }
        else {
            let button = tabBarItems[tabBarItems.count - 2].customView as! UIButton
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).setImage(UIImage(named: "DoneButton"), for: .normal)
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).frame = CGRect(x: 0, y: 0, width: 80, height: 25)
            if #available(iOS 11, *) {
                button.removeConstraints(button.constraints)
                button.widthAnchor.constraint(equalToConstant: 80).isActive = true
                button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            }
        }
        setToolbarItems(tabBarItems, animated: false)
        ToolBarInfo.shared.buttonActions[1] = toNextChapter
        if (!DataController.sharedData.linearJourney) {
            ToolBarInfo.shared.buttonActions[1] = toChapterMenu
        }
    }
    
    func toChapterMenu(sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ChapterSelectScreen {
                self.navigationController!.popToViewController(aViewController, animated: true)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
