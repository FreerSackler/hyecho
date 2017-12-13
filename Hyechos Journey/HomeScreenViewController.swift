//
//  HomeScreenViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 7/19/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenViewController: UIViewController {
    
    var needfade = true
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapScreen(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let interaction = storyboard.instantiateViewController(withIdentifier: "journeySelect")
        
        let transition: CATransition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        navigationController?.pushViewController(interaction, animated: false)
        //self.present(interaction, animated: true, completion: { _ in })
        needfade = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "295486")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        print(DataController.sharedData.plist)
        DataController.sharedData.readIn()
        DataController.sharedData.makeMapButton()
        
        
        Timer.scheduledTimer(timeInterval: TimeInterval(1.5), target: self, selector: #selector(HomeScreenViewController.callbytimmer), userInfo: nil, repeats: false)
        
        
        let items = ["Journey Select", "Resources on Hyecho", "About the App"]
        DataController.sharedData.menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "", items: items as [AnyObject])
        DataController.sharedData.createMenuButton()
        
        DataController.sharedData.menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            switch indexPath {
            case 0:
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is JourneySelectScreen {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            /*case 1:
                let storyboard = UIStoryboard(name: "Collection", bundle: nil)
                let interaction = storyboard.instantiateViewController(withIdentifier: "Collection")
                self.navigationController?.pushViewController(interaction, animated: true)*/
            case 1:
                let storyboard = UIStoryboard(name: "LearnMore", bundle: nil)
                let interaction = storyboard.instantiateViewController(withIdentifier: "LearnMore")
                self.navigationController?.pushViewController(interaction, animated: true)
            case 2:
                let storyboard = UIStoryboard(name: "AboutUs", bundle: nil)
                let interaction = storyboard.instantiateViewController(withIdentifier: "AboutUs")
                self.navigationController?.pushViewController(interaction, animated: true)
            default:
                break
            }
        }
    }
    
    func callbytimmer()
    {
        if needfade
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let interaction = storyboard.instantiateViewController(withIdentifier: "journeySelect")
            interaction.modalTransitionStyle = .crossDissolve
            //self.present(interaction, animated: true, completion: { _ in })
            
            let transition: CATransition = CATransition()
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController!.view.layer.add(transition, forKey: nil)
            
            navigationController?.pushViewController(interaction, animated: false)
        }

    }

}



