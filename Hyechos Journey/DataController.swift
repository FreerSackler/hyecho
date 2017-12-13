//
//  DataController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 5/4/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class DataController{
    static let sharedData = DataController()
    var plist = [[String:Any]]()
    var interactionText = [[String:Any]]()
    var linearJourney : Bool = false
    var menuView: BTNavigationDropdownMenu!
    var savedChapterSpot : Int = -1
    var negativeSpace = UIBarButtonItem()
    var mapButton = UIButton()
    
    //this will be called once to initialize dic in MapViewController.viewDidLoad()
    func readIn(){
        if let path = Bundle.main.path(forResource: "hyechoData", ofType: "plist") {
            if let dic = NSArray(contentsOfFile: path) {
                plist = dic as! [[String : Any]]
            }
        }
        if let path = Bundle.main.path(forResource: "InteractionText", ofType: "plist") {
            if let dic = NSArray(contentsOfFile: path) {
                interactionText = dic as! [[String : Any]]
            }
        }
        
        negativeSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10;
    }
    
    func makeMapButton() {
        mapButton =  UIButton(type: .custom)
        mapButton.setImage(UIImage(named: "MapIcon"), for: .normal)
        mapButton.adjustsImageWhenHighlighted = false
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mapButton.layer.removeAllAnimations()
        
        if #available(iOS 11, *) {
            mapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            mapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    func getMapButton() -> UIButton {
        //return mapButton
        let mapButton =  UIButton(type: .custom)
        mapButton.setImage(UIImage(named: "MapIcon"), for: .normal)
        mapButton.adjustsImageWhenHighlighted = false
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mapButton.layer.removeAllAnimations()
        
        if #available(iOS 11, *) {
            mapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            mapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        return mapButton
    }
    
    func createAlertButton(viewController: UIViewController, onCancel: (()->())? = nil, action: @escaping () -> ()) {
        let popup = UINib(nibName: "ChapterEndPopup", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first! as! EndOfChapterView
        
        for item in viewController.toolbarItems ?? [] {
            item.isEnabled = false
        }
        
        popup.nextChapterAction = action
        popup.stayHereAction = {
            for item in viewController.toolbarItems ?? [] {
                item.isEnabled = true
            }
            onCancel?()
        }
        
        viewController.present(popup: popup,
                     insets: UIEdgeInsets(
                        top: ((viewController.view.frame.height - 200) / 2),
                        left: 20,
                        bottom: ((viewController.view.frame.height - 200) / 2),
                        right: 20),
                     shadow: true
        )
        
        
        /*
        return UIAlertController(title: "Alert", message: "Are you sure you want to leave?", preferredStyle: UIAlertControllerStyle.alert)*/
    }
    
    func createMenuButton() {
         
         menuView.cellHeight = 45
         menuView.shouldChangeTitleText = false
         menuView.shouldKeepSelectedCellColor = false
         menuView.cellTextLabelColor = UIColor.white
         menuView.cellTextLabelFont = UIFont(name: "Georgia", size: 17)
         menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
         menuView.checkMarkImage = nil
         menuView.arrowPadding = -10
         menuView.animationDuration = 0.5
         menuView.maskBackgroundColor = UIColor.black
         menuView.maskBackgroundOpacity = 0.3
         menuView.arrowImage = UIImage(named: "MenuIcon")?.resizedImage(newSize: CGSize(width: 60, height: 60))
    }
    
 
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
