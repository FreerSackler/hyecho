//
//  ChapterViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 3/30/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class ChapterViewController: UIViewController {
    
    enum CellIdentifier: String {
        case chapterText = "ExpandingTextCell"
        case chapterTitle = "ExpandingTitleCell"
        case chapterHeader = "ChapterHeader"
        case chapterPoem = "ExpandingTextCellPoem"
    }
    
    enum CellModel {
        case text(expanded: Bool, text: String, audioPath: String, time: Double)
        case title(expanded: Bool, text: String)
        case header(image: UIImage)
        case chapterPoem(expanded: Bool, text: String, audioPath: String, time: Double)
    }
    
    /**
     Represents all the cells in the collection view.
     Used because the expandable cells need to maintain state when cells are moved offscreen
     */
    fileprivate var model: [CellModel] = []
    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    
    var chapter: Int = 0
    var linearJourney: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var popupView: PoemView!
    
    @IBOutlet weak var poemLabel: UITextView!
    
    
    //Makes the status bar white when navigationbar is hidden
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Update it
        linearJourney = DataController.sharedData.linearJourney
        
        //DropDownMenu and Nav Bar set up
        navigationController?.isNavigationBarHidden = false
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.white]

        poemLabel.setContentOffset(CGPoint.zero, animated: false)

        //Set up toolbar
        let tabBarItems = ToolBarInfo.shared.getBarButtons()
        setToolbarItems(tabBarItems, animated: false)
        
        ToolBarInfo.shared.buttonActions[0] = didPressBackButton
      
        ToolBarInfo.shared.buttonActions[1] = didPressNextButton
        
        
        //Set up swipe gestures to move between screens
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)

        
        setupChapter()
        
        //Update DropDownMenu and Toolbar colors
        DataController.sharedData.menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        navigationController?.toolbar.barTintColor = self.navigationController?.navigationBar.barTintColor
        
        
        
        
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
    
    func didPressNextButton(sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toItemPage", sender: nil)
        }
        //performSegue(withIdentifier: "toItemPage", sender: nil)
    }
    
    func didPressBackButton(sender: Any) {
        
        
        if (linearJourney && chapter != 0) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chapter") as? ChapterViewController
            storyboard?.chapter = self.chapter - 1
            navigationController?.pushViewController(storyboard!, animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didPressPoemClose(_ sender: UIButton) {
        popupView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        if (popupView.startedPlaying) {
            popupView.didPressPlayPause(UIButton())
        }
    }
    
    @IBAction func didPressPoemButton(_ sender: UIButton) {
        popupView.isHidden = false
        poemLabel.widthAnchor.constraint(equalToConstant: popupView.frame.width)
        if(sender.titleLabel?.text == "English") {
            var text = DataController.sharedData.plist[chapter]["Text"] as! [[String:Any]]
            poemLabel.text = text[0]["EnglishPoem"] as? String
            popupView.textLabel.font = UIFont(name: "Avenir Next", size: 14)
            //poemLabel.sizeToFit()
            //poemLabel.layoutIfNeeded()
            //popupView.frame = CGRect(x: popupView.frame.origin.x, y: popupView.frame.origin.y, width: popupView.frame.width, height: poemLabel.frame.height)
            popupView.textLabel.textAlignment = .center
            popupView.textLabel.font = UIFont(name: "Avenir Next", size: 14)
            popupView.audioPath = String(chapter+1) + ".English"
            
        }
        else {
            var text = DataController.sharedData.plist[chapter]["Text"] as! [[String:Any]]
            poemLabel.text = text[0]["ChinesePoem"] as? String
            popupView.textLabel.textAlignment = .center
            popupView.textLabel.font = UIFont(name: "Avenir Next", size: 17)
            poemLabel.sizeToFit()
            popupView.frame = CGRect(x: poemLabel.frame.origin.x, y: poemLabel.frame.origin.y, width: popupView.frame.width, height: poemLabel.frame.height)
            popupView.audioPath = String(chapter+1) + ".Chinese"
        }
        
        
        //popupView.frame.size.height = poemLabel.frame.height + 70
        collectionView.isUserInteractionEnabled = false
    
    }
    
    
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
        didPressNextButton(sender: self)
    }
    
    //moves "backward"
    func swipeRight() {
        didPressBackButton(sender: self)
    }

    func setupChapter() {
        
        let plist = DataController.sharedData.plist
        
        //NavigationBar stuff
        let chapterColor = plist[chapter]["Nav Bar Color"] as! String
        navigationController?.navigationBar.barTintColor = UIColor(hexString: chapterColor)
        title = plist[chapter]["Chapter"] as? String
        
        fadeAwayPage()

        
        //Set up model for collection view
        let objectInfo = plist[chapter]["Object Info"] as! [String:Any]
        let imagePath = objectInfo["ImagePath"] as! String
        
       
        model = [
            .header(image: UIImage(named: imagePath)!),
            .text(expanded: true, text: plist[chapter]["Brief Narrative"] as! String, audioPath: "\(chapter + 1).1", time: 0),
        ]
        let dict = plist[chapter]
        let text = dict["Text"] as! [[String:String]]
        var counter = 0
        var temp = 2
        for pair in text {
            model.append(.title(expanded: false, text: pair["Header Name"]!))
            
            if ((chapter == 4 || chapter == 6) && counter == 0) {
                model.append(.chapterPoem(expanded: false, text: pair["Text"]!, audioPath: "\(chapter + 1).\(temp)", time: 0))
            }
            else {
                model.append(.text(expanded: false, text: pair["Text"]!, audioPath: "\(chapter + 1).\(temp)", time: 0))
            }
            counter += 1
            temp += 1
        }
    
        //Set up collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
        
        //Adds bar under status bar so it doesnt look weird when the navigation bar is hidden
        addStatusBarView(withColor: UIColor(hexString: chapterColor), shadow: true)
    }
    
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var introview: ChapterIntroView?
    }
    
    
    
    private func fadeAwayMap() {
        let storyboard = UIStoryboard(name: "MapScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScrollViewController") as! ScrollViewController
        controller.chapter = chapter
        
        navigationController?.pushViewController(controller, animated: true)

    }
    
    var needfade = true
    
    private func fadeAwayPage() {
        
        
        let plist = DataController.sharedData.plist
        
        let introView = UINib(nibName: "ChapterIntro", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first! as! ChapterIntroView
        let window = UIApplication.shared.keyWindow!
        introView.frame.size = window.bounds.size
        introView.bounds = window.bounds
        introView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let hexColor = plist[chapter]["Intro Screen Color"] as! String
        
        introView.backgroundColor = UIColor(hexString: hexColor)
        introView.titleLabel.text = plist[chapter]["Chapter"] as? String
        introView.subtitleLabel.text = "Chapter " + String(chapter + 1)
        introView.alpha = 0
        
        window.addSubview(introView)

        
        let taptofade = MyTapGestureRecognizer(
            target:self,
            action:#selector(singleTap))
        
        taptofade.numberOfTapsRequired = 1
        taptofade.numberOfTouchesRequired = 1
        taptofade.introview = introView
        
        
        introView.addGestureRecognizer(taptofade)
        

        //Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(fade), userInfo: nil, repeats: false)


        UIView.animate(withDuration: 0.5, delay: 0.1, options:  [.curveEaseOut,.allowUserInteraction], animations: {
            introView.alpha = 1
        }, completion:{
            finished in
        })
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options:  [.curveEaseOut,.allowUserInteraction], animations: {
            introView.alpha = 1
        }, completion:{
            finished in
        })
        
        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            UIView.animate(withDuration: 1, delay: 0.1, options:  [.curveEaseOut,.allowUserInteraction], animations: {
                introView.alpha = 0
            }, completion:{
                finished in
            })
        }
        

        
        
    }
    
    func singleTap(gestureRecognizer: MyTapGestureRecognizer)
    {
        
        if let introview = gestureRecognizer.introview
        {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                introview.alpha = 0
            }, completion: {
                
                finished in
                introview.removeFromSuperview()
                self.needfade = false
            })
            if (linearJourney) {
                //fadeAwayMap()
            }

        }
        
    }
    
    



    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        DataController.sharedData.menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        
        navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
        
        
        //Save the chapter they are on
        if (linearJourney) {
            DataController.sharedData.savedChapterSpot = chapter
        }
        
        let barButton = navigationItem.rightBarButtonItem
        (barButton?.customView as! UIButton).removeTarget(nil, action: nil, for: .allEvents)
        (barButton?.customView as! UIButton).addTarget(self, action: #selector(didPressMap), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        
        //Removes 1px line from navigation bar that looks strange
        /*let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(),for: .default)
        navigationBar.shadowImage = UIImage()*/
        
        if let model = Preferences.shared.chapterViewControllerModel[chapter] {
            self.model = model
        }
        print(navigationController!.viewControllers.count)
        if navigationController!.viewControllers.count == 4 && linearJourney {
            navigationController!.viewControllers.remove(at: 2)
        }
        
        for cell in collectionView.visibleCells {
            if let textCell = cell as? ExpandingTextCell {
                let indexPath = collectionView.indexPath(for: textCell)!
                switch model[indexPath.row] {
                case let .text(_, _, _, time):
                    //Set
                    textCell.time = time
                default:
                    break
                }
            }
            if let titleCell = cell as? ExpandingTitleCell {
                let indexPath = collectionView.indexPath(for: titleCell)!
                switch model[indexPath.row] {
                case let .title(expanded, _):
                    titleCell.expanded = expanded
                default:
                    break
                }
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!, NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = DataController.sharedData.plist[chapter]["Chapter"] as? String
        
        var tabBarItems = ToolBarInfo.shared.getBarButtons()
       
        ToolBarInfo.shared.buttonActions[0] = didPressBackButton
        
        ToolBarInfo.shared.buttonActions[1] = didPressNextButton
        
        
        collectionView.performBatchUpdates(nil, completion: nil)
        setToolbarItems(tabBarItems, animated: false)
        
        navigationController?.isToolbarHidden = false
        DataController.sharedData.menuView.cellSelectionColor = self.navigationController?.navigationBar.barTintColor
        navigationController?.toolbar.backgroundColor = .clear
        navigationController?.toolbar.barTintColor = UIColor(hexString: DataController.sharedData.plist[chapter]["Nav Bar Color"] as! String)
        navigationController?.toolbar.tintColor = .clear
        navigationController?.toolbar.isTranslucent = false
        
        
    
        let barButton = DataController.sharedData.getMapButton()
        barButton.setImage(UIImage(named: "MapIcon"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        
        /*let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(nil,for: .default)
        navigationBar.shadowImage = nil*/
        
        navigationController?.barHideOnTapGestureRecognizer.isEnabled = true
        
       /* for cell in collectionView.visibleCells {
            if let textCell = cell as? ExpandingTextCell {
                let indexPath = collectionView.indexPath(for: textCell)!
                switch model[indexPath.row] {
                case let .text(expanded, text, audioPath, _):
                    //Save the time that the cell was at.
                    model[indexPath.row] = .text(expanded: expanded, text: text, audioPath: audioPath, time: textCell.time)
                default:
                    break
                }
            }
        }
        Preferences.shared.chapterViewControllerModel[chapter] = model*/
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        updateStatusBarViewFrame()
    }
    
    
    
    // MARK:- prepareForSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemViewController {
            destination.chapter = chapter
        }
    }
    
    
    // MARK:- Selected Cell IndexPath
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if collectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
}


// MARK:- UICollectionView DataSource

extension ChapterViewController : UICollectionViewDataSource {
    
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
        
        let plist = DataController.sharedData.plist
        
        switch model[indexPath.row] {
        case let .title(expanded, text):
            model[indexPath.row] = .title(expanded: !expanded, text: text)
            
            switch model[indexPath.row + 1] {
            case let .text(_, longText, audioPath, time):
                model[indexPath.row + 1] = .text(expanded: !expanded, text: longText, audioPath: audioPath, time: time)
            case let .chapterPoem(_, text, audioPath, time):
                model[indexPath.row+1] = .chapterPoem(expanded: !expanded, text: text, audioPath: audioPath, time: time)
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
                                    titleCell.arrowImageView.image = UIImage(named: plist[self.chapter]["Expanded"] as! String)
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
                                    titleCell.arrowImageView.image = UIImage(named: plist[self.chapter]["Not Expanded"] as! String)
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
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plist = DataController.sharedData.plist
        
        switch model[indexPath.row] {
            case let .title(expanded, text):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.chapterTitle.rawValue, for: indexPath) as! ExpandingTitleCell
                cell.expanded = expanded
                cell.titleLabel.text = text
                cell.line.backgroundColor = UIColor(hexString: plist[chapter]["Nav Bar Color"] as! String)
                let expandedKey = expanded ? "Expanded" : "Not Expanded"
                cell.arrowImageView.image = UIImage(named: plist[chapter][expandedKey] as! String)
                return cell
            case let .text(expanded, text, audioPath, time):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.chapterText.rawValue, for: indexPath) as! ExpandingTextCell
                
                cell.textLabel.text = text
                cell.expanded = expanded
                //TODO: Set audio path from plist
                cell.audioPath = audioPath
                cell.time = time
                return cell
            case .header(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.chapterHeader.rawValue, for: indexPath) as! ChapterHeaderCell
                cell.backgroundImageView.image = UIImage(named: plist[chapter]["Background Image"] as! String)
                
                return cell
           case let .chapterPoem(expanded, text, audioPath, time):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.chapterPoem.rawValue, for: indexPath) as! ExpandingTextCellPoem
                cell.textLabel.text = text
                cell.textLabel.sizeToFit()
                cell.expanded = expanded
                //TODO: Set audio path from plist
                cell.audioPath = audioPath
                cell.time = time
                return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch model[indexPath.row] {
        case let .text(expanded, text, audioPath, _):
            //Save the time that the cell was at.
            let textCell = cell as! ExpandingTextCell
            model[indexPath.row] = .text(expanded: expanded, text: text, audioPath: audioPath, time: textCell.time)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: JournalHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! JournalHeaderView
        
        headerView.sectionLabel.text = "Chapters"
        
        return headerView
    }
}


extension ChapterViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let width = UIScreen.main.bounds.width
        var height:CGFloat = indexPath.row % 2 == 0 ? 50 : 200
        
        
        
        switch model[indexPath.row] {
        case let .text(expanded, _, _, _):
            
            if expanded {
                if let cell = collectionView.cellForItem(at: indexPath) as? ExpandingTextCell {
                    height = cell.textLabel.frame.height + 50
                }
            } else {
                height = 1
            }
        case .title:
            height = 49
        case .header:
            height = 160
        case let .chapterPoem(expanded, _,  _, _):
            
            if expanded {
                if let cell = collectionView.cellForItem(at: indexPath) as? ExpandingTextCellPoem {
                    height = cell.textLabel.frame.height + 220
                }
            }
            else {
                height = 1
            }
        }
        
        return CGSize(width: width, height: height)
    }
}



