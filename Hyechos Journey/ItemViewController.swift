//
//  ItemViewController.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/5/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit
import AVFoundation

class ItemViewController: UIViewController {
   
    enum CellIdentifier: String {
        case image = "ItemImage"
        case information = "ItemInformation"
        case title = "ItemTitleCell"
        case text = "ItemTextCell"
    }
    
    enum CellModel {
        case image(image: UIImage)
        case information(name: String, location: String, date: String)
        case title(expanded: Bool, text: String)
        case text(expanded: Bool, text: String)
    }
    
    /**
     Represents the cells of the collectionView.
    */
    fileprivate var model:[CellModel] = []
    
    var objectPercentages = [0.76, 0.68, 0.77, 0.74, 0.65, 0.77, 0.5, 0.5]
    var chapter: Int = 0
    var linearJourney: Bool = DataController.sharedData.linearJourney
    
    fileprivate var plist = DataController.sharedData.plist
    fileprivate var objectInfo: [String:Any]!
    fileprivate var image: UIImage!
    
    fileprivate var rightSwipeRecognizer: UISwipeGestureRecognizer!
    fileprivate var leftSwipeRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet var collectionView: UICollectionView!
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    fileprivate var statusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Dropdown Menu
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
        
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = true
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        //Set up collectionView model
        objectInfo = plist[chapter]["Object Info"] as! [String:Any]
        let additionalInfo = objectInfo["Additional Info"] as! [String: String]
        let bundlePath = Bundle.main.path(forResource: objectInfo["ImagePath"] as? String, ofType: "png")
        
        model = [
            .image(image: UIImage(contentsOfFile: bundlePath!)!),
            .information(name: objectInfo["Name"] as! String,
                         location: objectInfo["Location"] as! String,
                         date: objectInfo["Period"] as! String),
            .text(expanded: true, text: objectInfo["Brief Intro"] as! String),
            .title(expanded: false, text: additionalInfo["Header Name"]!),
            .text(expanded: false, text: additionalInfo["Text"]!)
        ]
        
        addStatusBarView(withColor: navigationController!.navigationBar.barTintColor!, shadow: true)
        
        //Set toolbar
        let tabBarItems = ToolBarInfo.shared.getBarButtons()
        
        self.setToolbarItems(tabBarItems, animated: false)
        ToolBarInfo.shared.buttonActions[0] = didPressBackButton
        ToolBarInfo.shared.buttonActions[1] = didPressNextButton
        
        //Set up swipe gestures
        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipeRecognizer)

        
    }
    func didPressMap() {
        let storyboard = UIStoryboard(name: "MapScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScrollViewController") as! ScrollViewController
        if (linearJourney) {
            controller.mapButtonPress = false
        } else {
            controller.mapButtonPress = true
        }
        
        controller.chapter = chapter
        
        navigationController?.pushViewController(controller, animated: true)

        
    }



    func didPressNextButton(sender: UIButton) {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad || UIDevice.current.model.lowercased().range(of: "ipad") != nil
                               || (chapter == 7 && UIDevice.current.modelName == "iPhone 5")
                               || (chapter == 7 && DeviceType.IS_IPHONE_5)
        {
            if (!DataController.sharedData.linearJourney) {
                toChapterMenu(sender: UIButton())
            }
            else {
                toNextChapter(sender: UIButton())
            }
        }
        else{
            didPressInteraction(UIButton())
        }
        
    }
    
    func didPressBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.hidesBarsOnSwipe = false
        
        //Removes 1px line from navigation bar that looks strange
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(),for: .default)
        navigationBar.shadowImage = UIImage()
        
        //Set up nav bar
        navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
        //Set nav bar title
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.white]
        //navigationItem.title = DataController.sharedData.plist[chapter]["Chapter"] as? String
        
        //Set toolbar up and give it functions
        let tabBarItems = ToolBarInfo.shared.getBarButtons()
        let interaction = tabBarItems[tabBarItems.count - 2].customView as! UIButton
        interaction.setImage(UIImage(named: "InteractionButton"), for: .normal)
        if #available(iOS 11, *) {
            interaction.removeConstraints(interaction.constraints)
            interaction.widthAnchor.constraint(equalToConstant: 80).isActive = true
            interaction.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        (tabBarItems[tabBarItems.count - 2].customView as! UIButton).frame = CGRect(x: 0, y: 0, width: 80, height: 25)
        
        print(UIDevice.current.modelName)
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad || UIDevice.current.model.lowercased().range(of: "ipad") != nil
                               || (chapter == 7 && UIDevice.current.modelName == "iPhone 5")
                               || (chapter == 7 && DeviceType.IS_IPHONE_5){
            
            if (DataController.sharedData.linearJourney) {
                let button = tabBarItems[tabBarItems.count - 2].customView as! UIButton
                (tabBarItems[tabBarItems.count - 2].customView as! UIButton).setImage(UIImage(named: "NextChapterButton"), for: .normal)
                (tabBarItems[tabBarItems.count - 2].customView as! UIButton).frame = CGRect(x: 0, y: 0, width: 170, height: 10)
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
        }
        
        self.setToolbarItems(tabBarItems, animated: false)
        ToolBarInfo.shared.buttonActions[1] = didPressNextButton
        ToolBarInfo.shared.buttonActions[0] = didPressBackButton
        
        let barButton = DataController.sharedData.getMapButton()
        //barButton.setImage(UIImage(named: "MapIcon"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        
        navigationController?.barHideOnTapGestureRecognizer.isEnabled = true
        
        /*let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(nil,for: .default)
        navigationBar.shadowImage = nil*/
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.performBatchUpdates(nil, completion: nil)
        
        //Add Map Button
        let barButton = navigationItem.rightBarButtonItem
        (barButton?.customView as! UIButton).removeTarget(nil, action: nil, for: .allEvents)
        (barButton?.customView as! UIButton).addTarget(self, action: #selector(didPressMap), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        updateStatusBarViewFrame()
    }
    
   
    @IBAction func didPressInteraction(_ sender: Any) {
        var storyboard = UIStoryboard()
        
        if (chapter == 0) {
            storyboard = UIStoryboard(name: "HyechoInteraction", bundle: nil)
        } else if (chapter == 1){
            storyboard = UIStoryboard(name: "MedicineBuddhaInteraction", bundle: nil)
        } else if (chapter == 2){
            storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        } else if (chapter == 3){
            storyboard = UIStoryboard(name: "SculptingInteraction", bundle: nil)
        } else if (chapter == 4){
            storyboard = UIStoryboard(name: "PuzzleInteraction", bundle: nil)
        } else if (chapter == 5){
            storyboard = UIStoryboard(name: "EwerInteraction", bundle: nil)

        }else if (chapter == 6) {
            storyboard = UIStoryboard(name: "MaraInteraction", bundle: nil)
        } else if (chapter == 7) {
            storyboard = UIStoryboard(name: "StupaInteraction", bundle: nil)
        }
        else{
            storyboard = UIStoryboard(name: "MaraInteraction", bundle: nil)
        }
        let interaction = storyboard.instantiateInitialViewController()!
        navigationController?.pushViewController(interaction, animated: true)
    }
    
    @objc func toNextChapter(sender: UIButton) {
        DataController.sharedData.createAlertButton(
            viewController: self,
            onCancel: {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func swiped(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                swipeRight()
            case UISwipeGestureRecognizerDirection.left:
                swipeLeft()
            default:
                break
            }
        }
    }
    
    //Moves "forward"
    func swipeLeft() {
        didPressInteraction(sender:self)
    }
    
    //moves "backward"
    func swipeRight() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UICollectionView DataSource

extension ItemViewController : UICollectionViewDataSource {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        //When the top bar is tapped, unhide the bar
        navigationController?.setNavigationBarHidden(false, animated: true)
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch model[indexPath.row] {
            case let .title(expanded, text):
                model[indexPath.row] = .title(expanded: !expanded, text: text)
                
                switch model[indexPath.row + 1] {
                case let .text(_, longText):
                    model[indexPath.row + 1] = .text(expanded: !expanded, text: longText)
                default:
                    break
                }
                
                let titleCell = collectionView.cellForItem(at: indexPath) as! ExpandingTitleCell
                titleCell.expanded = !expanded
                if (titleCell.expanded) {
                    UIView.transition(with: titleCell.arrowImageView,
                                      duration: 0.15,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        titleCell.arrowImageView.image = UIImage(named: self.plist[self.chapter]["Expanded"] as! String)
                    },
                                      completion: nil)
                    titleCell.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                        titleCell.arrowImageView.transform = .identity
                    }, completion: {
                        success in
                        titleCell.arrowImageView.transform = .identity
                        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                    })
                }
                else {
                    UIView.transition(with: titleCell.arrowImageView,
                                      duration: 0.15,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        titleCell.arrowImageView.image = UIImage(named: self.plist[self.chapter]["Not Expanded"] as! String)
                    },
                                      completion: nil)
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                        titleCell.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    }, completion: {
                        success in
                        titleCell.arrowImageView.transform = .identity
                    })
                }
                
                let textIndexPath = IndexPath(item: indexPath.row + 1, section: indexPath.section)
                if let textCell = collectionView.cellForItem(at: textIndexPath) as? ExpandingTextCell {
                    textCell.expanded = !expanded
                }
                
                collectionView.performBatchUpdates(nil, completion: nil)
            
       //This allows image to be clicked on and made fullscreen
       case let .image(image):
            //let hexColor = plist[chapter]["Intro Screen Color"] as! String
            let popup = UINib(nibName: "DetailImageView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first! as! DetailImagePopupView
            popup.imageView.backgroundColor = UIColor.black//UIColor(hexString: hexColor)
            popup.imageView.image = image
            popup.scrollView.maximumZoomScale = 12
            popup.scrollView.delegate = popup
            popup.scrollView.pinchGestureRecognizer!.isEnabled = true
            let wasNavigationBarHidden = self.navigationController!.isNavigationBarHidden
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
            navigationController?.barHideOnSwipeGestureRecognizer.isEnabled = false
            navigationController?.setToolbarHidden(true, animated: true)
            tabBarController?.tabBar.isHidden = true
            statusBarHidden = true
            setNeedsStatusBarAppearanceUpdate()
            rightSwipeRecognizer.isEnabled = false
            leftSwipeRecognizer.isEnabled = false
            
            popup.onCancel {
                self.rightSwipeRecognizer.isEnabled = true
                self.leftSwipeRecognizer.isEnabled = true
            }
            
            present(
                popup: popup,
                insets: UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0
                ),
                cornerRadius: 0,
                duration: 0.5,
                completion: {
                    //Stuff after the popup is cancelled
                    self.navigationController?.setNavigationBarHidden(wasNavigationBarHidden, animated: true)
                    self.navigationController?.setToolbarHidden(false, animated: true)
                    self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = true
                    self.navigationController?.barHideOnSwipeGestureRecognizer.isEnabled = true
                    self.statusBarHidden = false
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            )
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch model[indexPath.row] {
        case let .image(image):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.image.rawValue, for: indexPath) as! ItemImageCell
            cell.imageView.image = image
            
            return cell
        case let .information(name, location, date):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.information.rawValue, for: indexPath) as! ItemInformationCell
            cell.nameLabel.text = name
            cell.locationLabel.text = location
            cell.dateLabel.text = date
            cell.backgroundColor = UIColor(hexString: plist[chapter]["Intro Screen Color"] as! String)
            return cell
        case let .title(expanded, text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.title.rawValue, for: indexPath) as! ExpandingTitleCell
            cell.titleLabel.text = text
            cell.expanded = expanded
            cell.line.backgroundColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
            let expandedKey = expanded ? "Expanded" : "Not Expanded"
            cell.arrowImageView.image = UIImage(named: plist[chapter][expandedKey] as! String)
            
            return cell
        case let .text(expanded, text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.text.rawValue, for: indexPath) as! ExpandingTextCell
            cell.textLabel.text = text
            cell.textLabel.sizeToFit()
            cell.expanded = expanded
            //TODO: Set audio path from plist
            
            cell.audioPath = String(chapter+1) + "." + String((indexPath.row/2) + 3)
            return cell
        }
    }
}


extension ItemViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let width = UIScreen.main.bounds.width
        var height:CGFloat = indexPath.row % 2 == 0 ? 50 : 200
        
        
        switch model[indexPath.row] {
        case let .image(image):
            //let size = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(x: 0, y: 0, width: view.frame.width, height: CGFloat.infinity))
            var screenHeight = UIScreen.main.bounds.height
            var objPerc:CGFloat = CGFloat(objectPercentages[chapter])
            height = screenHeight * objPerc
        case let .information(name, _, _):
            height = NSString(string: name).boundingRect(with: CGSize(width: width - 46, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont(name: "AvenirNext-Medium", size: 24)!], context: nil).height + 60//70
            //height = max(height, 107)
        case .title:
            height = 49
        case let .text(expanded, text):
            if expanded {
                let temp = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 64, height: 0))
                temp.text = text
                temp.numberOfLines = 20
                temp.sizeToFit()
                
                height = temp.frame.height + 56
            } else {
                height = 1
            }
        }
        
        return CGSize(width: width, height: height)
    }
}

