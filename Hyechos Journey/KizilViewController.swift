//
//  MedicineBuddhaViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 6/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import SpriteKit
import UIKit

class KizilViewController : UIViewController {
    
    @IBOutlet weak var PopUpViewHeight: NSLayoutConstraint!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var popupImage: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var introText: UILabel!
    
    @IBOutlet weak var dismissViewButton: UIButton!
    var puzzlePiece : String = ""
    
    
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        
        //introView.isHidden = true
        popupView.isHidden = true
        scene.gamePaused = false
        scene.isPaused = false
        gameView.isPaused = false
        
        dismissViewButton.isHidden = true
        dismissViewButton.isEnabled = false
        
    }
    
    var text = DataController.sharedData.interactionText
    
    var scene = KizilGameScene()
    
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
    func toChapterMenu(sender: UIButton) {
       
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ChapterSelectScreen {
                self.navigationController!.popToViewController(aViewController, animated: true)
                return
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        popupView.isHidden = true
        
        //introView.layer.borderWidth = 1
       // introView.layer.borderColor = UIColor.black.cgColor

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            print("!!1")
        }
        
        let scene = SKScene(fileNamed: "KizilGameScene") as! KizilGameScene
        
        gameView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)
        scene.backgroundColor = UIColor(hexString: "F2F0F0")
        scene.viewController = self
        
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
        self.setToolbarItems(tabBarItems, animated: false)
        ToolBarInfo.shared.buttonActions[1] = toNextChapter
        if (!DataController.sharedData.linearJourney) {
            ToolBarInfo.shared.buttonActions[1] = toChapterMenu
        }
        
       // introView.isHidden = false
        popupView.isHidden = false
        popupText.text = "Welcome to the Kizil Caves puzzle! Place the puzzle pieces into the appropriate location on the painting. Once you correctly match a puzzle piece, you will uncover new information relating to the painting."
        //introText.text = "Welcome to the Kizil Caves puzzle! Place the puzzle pieces into the appropriate location on the painting. Once you correctly match a puzzle piece, you will uncover new information relating to the painting."
        
        popupText.sizeToFit()
       // introText.sizeToFit()
        //introView.frame.size.height = introText.frame.height + 50
        popupView.frame.size.height = popupText.frame.height + 40
        popupImage.image = #imageLiteral(resourceName: "Fragment_From_The_Kizil_Caves_thumbnail")
        scene.gamePaused = true
        scene.isPaused = true
        gameView.isPaused = true
        dismissViewButton.isHidden = false
        dismissViewButton.isEnabled = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        //popupView.frame.size.height = 200
    }
    
    func showPopup() {
        
        //Chapter 5 text
        popupText.text = text[4][puzzlePiece] as? String
        
        popupImage.image = UIImage(named: text[4][puzzlePiece + "-picture"] as! String)
        popupView.isHidden = false
        scene.gamePaused = true
        scene.isPaused = true
        gameView.isPaused = true
        dismissViewButton.isHidden = false
        dismissViewButton.isEnabled = true
        popupText.sizeToFit()
        popupView.frame.size.height = popupText.frame.height + 150
    }
    
    
}

