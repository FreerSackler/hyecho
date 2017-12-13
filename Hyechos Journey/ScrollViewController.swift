//
//  ScrollViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 6/6/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var floorView: UIView!
    @IBOutlet weak var legendView: UIView!
    @IBOutlet weak var legendImage: UIImageView!
    
    let directionsDropDown = DropDown()
    let floorDropDown = DropDown()
    
    var chapter: Int = 0
    let plist = DataController.sharedData.plist
    var mapButtonPress: Bool = false
    
    @IBOutlet weak var backgroundView: UIView!
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print("1234")
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        print("123123")
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
        if UIDevice.current.orientation.isLandscape {
            navigationController?.navigationBar.topItem?.title = ""
        }
        else {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    func image(image:UIImage,imageSize:CGSize)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 3, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage!;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Georgia", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        navigationController?.navigationItem.hidesBackButton = true
        
        
        if (!DataController.sharedData.linearJourney) {
            
            var dic = plist[chapter]["Maps"] as! [String:Any]
        
            if (chapter != 6 && chapter != 7) {
                
                _ = image(image: UIImage(named: dic["Map Sackler CYO"] as! String)!, imageSize: CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
                
                image.image = UIImage(named: dic["Map Sackler CYO"] as! String)
                navigationItem.title = "Sackler Gallery, B1"
               // legendImage.image = UIImage(named: "CYO 1st Floor")
            }
            else {
                image.image = UIImage(named: dic["Map Freer CYO"] as! String)
                navigationItem.title = "Freer Gallery, Level 1"
                //legendImage.image = UIImage(named: "CYO 3rd Floor")
            }
            
        }
        else {
            var dic = plist[chapter]["Maps"] as! [String:Any]
            if (chapter != 7) {
                image.image = UIImage(named: dic["Map Linear"] as! String)
                navigationItem.title = "Sackler Gallery, B1"
                //legendImage.image = UIImage(named: "Linear 1st Floor")
            }
            else {
                image.image = UIImage(named: dic["Map Linear"] as! String)
                navigationItem.title = "Freer Gallery, Level 1"
                //legendImage.image = UIImage(named: "Linear 3rd Floor")
            }
            
            
        }
        //Stops nav and toolbar from covering view
        self.edgesForExtendedLayout = []
        
        scrollView.backgroundColor = UIColor(hexString: "F2F0F0")
        backgroundView.backgroundColor = UIColor(hexString: "F2F0F0")
        //scrollView.contentSize = image.bounds.size
        scrollView.delegate = self
        
        
        
        legendView.isHidden = true
        legendView.backgroundColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
        navigationController?.toolbar.backgroundColor = .clear
        navigationController?.toolbar.barTintColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
        navigationController?.toolbar.tintColor = .clear
        navigationController?.toolbar.isTranslucent = false
        
        setZoomScale()
        setupGestureRecognizer()
        directionsButtonSetUp()
        floorLevelButtonSetUp()
        
        let xOffset = 400
        scrollView.contentOffset = CGPoint(x: Int(xOffset), y: 0)
        
        
        //Add Map Button
        let barButton = DataController.sharedData.getMapButton()
        barButton.removeTarget(nil, action: nil, for: .allEvents)
        barButton.addTarget(self, action: #selector(didPressMapButton), for: .touchUpInside)
        barButton.setImage(UIImage(named: "Cancel"), for: .normal)
        barButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        if #available(iOS 11, *) {
            barButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            barButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        navigationItem.setHidesBackButton(true, animated: false)
        let tabBarItems = ToolBarInfo.shared.getMapBarButtons(chapter: chapter)
        
        self.setToolbarItems(tabBarItems, animated: false)
        ToolBarInfo.shared.buttonActions[0] = didPressDirections
        ToolBarInfo.shared.buttonActions[1] = didPressLegend
        
        
        
        if(!DataController.sharedData.linearJourney || chapter == 6) {
            let levelsButton =  UIButton(type: .custom)
            levelsButton.setImage(UIImage(named: "LevelsButton"), for: .normal)
            levelsButton.adjustsImageWhenHighlighted = false
            levelsButton.frame = CGRect(x: 0, y: 0, width: 80, height: 12)
            if #available(iOS 11, *) {
                levelsButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
                levelsButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
            }
            levelsButton.addTarget(self, action: #selector(didPressFloor), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: levelsButton)
        }
        
        
    }
    
   /* override func viewDidDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
 */
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscape)
        
        //Set orientation
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    func floorLevelButtonSetUp(){
        
        var dic = plist[chapter]["Maps"] as! [String:Any]
        
        floorDropDown.backgroundColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
        
        floorDropDown.dataSource = ["Freer Gallery, Level 1", "Freer Gallery, Level G", "Sackler Gallery, B1"]
        floorDropDown.textFont = UIFont(name: "Georgia", size: 15)!
        floorDropDown.anchorView = floorView!
        floorDropDown.dismissMode = .onTap
        floorDropDown.direction = .bottom
        floorDropDown.textColor = UIColor.white
        floorDropDown.selectionAction = { [unowned self] (index, item) in
            self.scrollView.zoomScale = 1.0
            if (!DataController.sharedData.linearJourney) {
                
                switch item {
                case "Freer Gallery, Level 1":
                    self.image.image = UIImage(named: dic["Map Freer CYO"] as! String)
                    self.navigationItem.title = "Freer Gallery, Level 1"
                    //self.legendImage.image = UIImage(named: "CYO 1st Floor")
                    
                case "Freer Gallery, Level G":
                    self.image.image = UIImage(named: dic["Map Ground CYO"] as! String)
                    self.navigationItem.title = "Freer Gallery, Level G"
                    //self.legendImage.image = UIImage(named: "CYO 2nd Floor")
                    
                case "Sackler Gallery, B1":
                    self.image.image = UIImage(named: dic["Map Sackler CYO"] as! String)
                    self.navigationItem.title = "Sackler Gallery, B1"
                    //self.legendImage.image = UIImage(named: "CYO 3rd Floor")
                    
                default:
                    break
                }
            }
            else {
                switch item {
                case "Freer Gallery, Level 1":
                    self.image.image = UIImage(named: dic["Map Linear Freer"] as! String)
                    self.navigationItem.title = "Freer Gallery, Level 1"
                    if (self.chapter == 6) {
                        self.directionsDropDown.dataSource = dic["Directions To Object"] as! [String]
                    }
                    
                    //self.legendImage.image = UIImage(named: "Linear 1st Floor")
                    
                case "Freer Gallery, Level G":
                    self.image.image = UIImage(named: dic["Map Linear Ground"] as! String)
                    self.navigationItem.title = "Freer Gallery, Level G"
                    if (self.chapter == 6) {
                        self.directionsDropDown.dataSource = dic["Directions To Freer"] as! [String]
                    }
                    
                   // self.legendImage.image = UIImage(named: "Linear 1st Floor")
                    
                case "Sackler Gallery, B1":
                    self.image.image = UIImage(named: dic["Map Linear"] as! String)
                    self.navigationItem.title = "Sackler Gallery, B1"
                    if (self.chapter == 6) {
                        self.directionsDropDown.dataSource = dic["Directions To Ground"] as! [String]
                    }
                    
                    //self.legendImage.image = UIImage(named: "Linear 3rd Floor")
                    
                default:
                    break
                }
            }
        }
        
    }
    
    var floorDelay: Bool = false
    
    func didPressFloor() {
        if !floorDelay {
            floorDropDown.show()
            floorDelay = true
            //0.5 is the delay until users can press the delay button again
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.floorDelay = false
            }
        }
    }
    
    func directionsButtonSetUp(){
    
        let dic = plist[chapter]["Maps"] as! [String:Any]
        
        if(chapter == 6) {
            directionsDropDown.dataSource = dic["Directions To Ground"] as! [String]
        }
        else {
            directionsDropDown.dataSource = dic["Directions"] as! [String]
        }
        directionsDropDown.textFont = UIFont(name: "Georgia", size: 15)!
        directionsDropDown.anchorView = directionsView!
        directionsDropDown.textColor = UIColor.white
        directionsDropDown.backgroundColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
        directionsDropDown.dismissMode = .onTap
        directionsDropDown.direction = .top
    }
    
    //delays directionButton from being pressed to fast
    var directionDelay = false
    
    //on click function for Directions button
    func didPressDirections(sender: Any){
        if !directionDelay {
            directionsDropDown.show()
            directionDelay = true
            //0.5 is the delay until users can press the delay button again
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.directionDelay = false
            }
        }
    }
    
    func didPressLegend(sender: Any) {
        //present legend
        print("???")
        legendView.isHidden = !legendView.isHidden
    }
    
    func didPressMapButton() {
        let value = UIInterfaceOrientation.portrait.rawValue
        AppUtility.lockOrientation(.portrait)
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    override func viewWillLayoutSubviews() {
        //setZoomScale()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        image = nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = image.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        
        scrollView.minimumZoomScale = 0.8
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = 1.0
        
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ScrollViewController.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
}
