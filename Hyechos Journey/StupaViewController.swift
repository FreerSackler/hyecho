//
//  ViewController.swift
//  CircleSlider
//
//  Created by shushutochako on 11/17/2015.
//  Copyright (c) 2015 shushutochako. All rights reserved.
//

import UIKit

class StupaViewController: UIViewController {
    @IBOutlet weak var sliderArea: UIView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var PlayAgain: UIButton!
    
    @IBOutlet weak var dismissViewButton: UIButton!
    
    @IBAction func didPressPlayAgain(_ sender: Any) {
        circleSlider.value = 5
        PlayAgain.isHidden = true
        popupView.isHidden = true
        dismissViewButton.isHidden = true
        dismissViewButton.isEnabled = false
        circleSlider.isUserInteractionEnabled = true
    }
    
    @IBAction func didPressCancelButton(_ sender: Any) {
        if firstClick{
            firstClick = false
        }
        if !PlayAgain.isHidden{
            
        } else {
            popupView.isHidden = true
            dismissViewButton.isHidden = true
            dismissViewButton.isEnabled = false
            circleSlider.isUserInteractionEnabled = true
        }
    }
    
    private var circleSlider: CircleSlider! {
        didSet {
            self.circleSlider.tag = 0
        }
    }
    private var circleProgress: CircleSlider! {
        didSet {
            self.circleProgress.tag = 1
        }
    }
    private var valueLabel: UILabel!
    private var progressLabel: UILabel!
    private var sliderOptions: [CircleSliderOption] {
        return [
            CircleSliderOption.barColor(UIColor(hexString: "D8D8D8")),
            CircleSliderOption.thumbColor(UIColor(hexString: "CF7089")),
            CircleSliderOption.trackingColor(UIColor(hexString: DataController.sharedData.plist[7]["Intro Screen Color"] as! String)),
            CircleSliderOption.barWidth(20),
            CircleSliderOption.thumbWidth(30),
            CircleSliderOption.startAngle(45),
            CircleSliderOption.maxValue(110),
            CircleSliderOption.minValue(0),
        ]
    }
    
    @IBOutlet var viewAnimate: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    var text = DataController.sharedData.interactionText
    var textCount = 100
    var prevValue = 0
    var control = false
    var firstClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////////////////////////////////////////////////
        //TODO: REMOVE THIS TO STOP SKIPPING INTERACTION
        //Also fix `toEndScreen` method to show alert.
        ///////////////////////////////////////////////
        /*
        if(!DataController.sharedData.linearJourney) {
            self.toChapterMenu(sender: UIButton())
        } else {
            self.toEndScreen(sender: self)
        }
        */
        
        //TODO: UNCOMMENT THIS
        
        self.buildCircleSlider()
        self.didPressCancelButton(sender: self)
        self.navigationController?.isToolbarHidden = false
        
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
        if (!DataController.sharedData.linearJourney) {
            ToolBarInfo.shared.buttonActions[1] = toChapterMenu
        }
        else {
            ToolBarInfo.shared.buttonActions[1] = toEndScreen
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
                
        circleSlider.value = 0
        valueChange(sender: circleSlider)
 
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /////////////////////
        //TODO: UNCOMMENT THIS
        /////////////////////
        PlayAgain.isHidden = true
        self.circleSlider.frame = self.sliderArea.bounds
        self.valueLabel.center = CGPoint(x: self.circleSlider.bounds.width * 0.5, y: self.circleSlider.bounds.height * 0.5)
 
    }
    
    private func buildCircleSlider() {
        self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
        self.circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        self.sliderArea.addSubview(self.circleSlider!)
        self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.valueLabel.textAlignment = .center
        self.circleSlider.addSubview(self.valueLabel)
    }
  
    
    func valueChange(sender: CircleSlider) {
        let inValue : Int = Int(sender.value)
        
        if control {
            control = false
            return
        } else if !(popupView.isHidden){
            control = true
            sender.value = Float(prevValue)
            return
        }
        
        prevValue = inValue;
        
        switch (inValue){
        case 0,1,2,3,4,5,6,7,8,9,10:
            //this just showed
            if textCount == 0{
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:0.0, y:-75.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 0
            showPopup()
            break
        case 11,12,13,14,15,16,17,18,19,20:
            print(imageView.transform)
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = .identity
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 100
            break
        case 21,22,23,24,25,26,27,28,29:
            if textCount == 1 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:150.0, y:-75.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 1
            showPopup()
            break
        case 30,31,32,33,34,35,36,37,38,39:
            if textCount == 2 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = .identity
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 100
            break
        case 40,41,42,43,44,45,46,47,48,49:
            if textCount == 2 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:150.0, y:100.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 2
            showPopup()
            break
        case 50,51,52,53,54,55,56,57,58,59:
            if textCount == 3 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = .identity
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 100
            break
        case 60,61,62,63,64,65,66,67,68,68,69:
            if textCount == 3 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:-150.0, y:100.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 3
            showPopup()
            break
        case 70,71,72,73,74,75,76,77,78,79:
            if textCount == 4 {
                return
            }
            print(imageView.transform)
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = .identity
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 100
            break
        case 80,81,82,83,84,85,86,87,88,89,90:
            if textCount == 4 {
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:-150.0, y:-75.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 4
            showPopup()
            break
        case 91,92,93,94,95,96,97,98,99:
            print(imageView.transform)
            if textCount == 5{
                return
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = .identity
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 100
            break
        case 100,101,102,103,104,105,106,107,108,109:
            circleSlider.value = 110
            if textCount == 5 || textCount == 0{
                return
            }else if textCount == 0{
                circleSlider.value = 5
            }
            UIView.animate(withDuration: 1, animations: {
                self.imageView.transform = CGAffineTransform.identity.translatedBy(x:0.0, y:-75.0).scaledBy(x:2, y:2)
            }) { (true) in
                print(self.imageView.transform)
            }
            textCount = 5
            PlayAgain.isHidden = false
            showPopup()
            break
        default:
            break
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
    
    func toEndScreen(sender: Any) {
        
        //TODO: REMOVE THIS AND REPLACE WITH ALERT
        let storyboard = UIStoryboard(name: "EndScreen", bundle: nil)
        let interaction = storyboard.instantiateViewController(withIdentifier: "EndScreen")
        self.navigationController?.pushViewController(interaction, animated: true)
        /*
        DataController.sharedData.createAlertButton(viewController: self) {
            let storyboard = UIStoryboard(name: "EndScreen", bundle: nil)
            let interaction = storyboard.instantiateViewController(withIdentifier: "EndScreen")
            self.navigationController?.pushViewController(interaction, animated: true)
        }*/
    }
    
    func showPopup() {
        circleSlider.isUserInteractionEnabled = false
        popupText.text = text[7][String(textCount)] as? String
        popupView.isHidden = false
        dismissViewButton.isHidden = false
        dismissViewButton.isEnabled = true
        
    }
}



