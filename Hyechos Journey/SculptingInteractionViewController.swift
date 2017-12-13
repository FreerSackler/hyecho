//
//  SculptingInteractionViewController.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/18/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class SculptingInteractionViewController: UIViewController {
    var topTextView: UITextView!
    var topTextBackgroundView: UIImageView!
    var button: UIButton!
    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    var completionView: SculptingCompletionView!
    var playAgainButton: UIButton!
    var firstTouch: Bool = true
    var sculptIndex: Int = 0
    
    @IBOutlet var drawView: DrawView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var drawContainer: UIView!
    
    let noseCompletionPoints: Set<CGPoint> = {
        var points: Set<CGPoint> = []
        for x in 42...49 {
            for y in 50...65 {
                points.insert(CGPoint(x: x, y: y))
            }
        }
        return points
    }()
    
    let hairCompletionPoints: Set<CGPoint> = {
        var points: Set<CGPoint> = []
        for x in 30...70 {
            for y in 20...36 {
                points.insert(CGPoint(x: x, y: y))
            }
        }
        return points
    }()
    
    var isFreeDraw = false
    
    let topMessages = [
        "Just like the head on display, your sculpture has a large straight nose without a bridge; this shape is typical of Greek, Roman, and Gandharan sculptures.",
        "Excellent!\nNow your sculpture has wavy hair. This feature is also Greco-Roman. Other buddha images from other regions are often depicted with curlier \"beaded\" hair.",
        "Great Job!"
    ]
    
    @objc func toNextChapter(sender: UIButton) {
        DataController.sharedData.createAlertButton(viewController: self) {
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
    
    private func setupTopTextView() {
        topTextView = UITextView()
        topTextView.isUserInteractionEnabled = false
        topTextView.text = "Touch the clay to sculpt it!"
        topTextView.textColor = .black
        topTextView.font = UIFont(name: "AvenirNext-Medium", size: 17)
        topTextView.textAlignment = .center
        topTextView.layer.cornerRadius = 10
        topTextView.sizeToFit()
        topTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //Center the view horizontally after sizing to fit text
        topTextView.frame = CGRect(
            x: (view.frame.width - topTextView.frame.width) / 2,
            y: 20,
            width: topTextView.frame.width,
            height: topTextView.frame.height
        )
        view.addSubview(topTextView)
        topTextView.backgroundColor = nil
        //topTextView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        topTextBackgroundView = UIImageView(frame: topTextView.frame)
        topTextBackgroundView.image = #imageLiteral(resourceName: "TextBackground")
        view.insertSubview(topTextBackgroundView, belowSubview: topTextView)
    }
    
    private func setupButton() {
        button = UIButton(type: .custom)
        //button.setBackgroundColor(UIColor.black.withAlphaComponent(0.25), forControlState: .normal)
        //button.setBackgroundColor(UIColor.black.withAlphaComponent(0.3), forControlState: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.frame = CGRect(
            x: 20,//sceneKitView.frame.midX - button.frame.width / 2,
            y: view.frame.height - navigationController!.toolbar.frame.height - navigationController!.navigationBar.frame.height - 78,//completionView.frame.minY - 58,//button.frame.height - 8,
            width: self.view.frame.width - 40,//sceneKitView.frame.width - 98,//button.frame.width,
            height: 50//button.frame.height
        )
        button.setBackgroundImage(#imageLiteral(resourceName: "TextBackground"), for: .normal)
        //button.addTarget(self, action: #selector(S.transitionToHair), for: .touchUpInside)
        print(button.frame)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    fileprivate func setButtonAction(to newAction: Selector) {
        let oldActions = button.actions(forTarget: self, forControlEvent: .touchUpInside)
        for action in oldActions ?? [] {
            button.removeTarget(self, action: Selector(action), for: .touchUpInside)
        }
        button.addTarget(self, action: newAction, for: .touchUpInside)
    }
    
    fileprivate func setupPlayAgainButton() {
        playAgainButton = UIButton(type: .custom)
        playAgainButton.frame = CGRect(
            x: (view.frame.width - 286) / 2,
            y: view.frame.height / 2 - 45,
            width: 286,
            height: 90
        )
        playAgainButton.setBackgroundImage(#imageLiteral(resourceName: "PlayAgain"), for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
    }
    
    func playAgain() {
        removePlayAgainButton()
        
        sculptIndex = 0
        drawView.completedPoints = []
        drawView.image = #imageLiteral(resourceName: "Clay1")
        drawView.alpha = 1
        
        topTextView.font = topTextView.font!.withSize(17)
        
        topTextBackgroundView.image = #imageLiteral(resourceName: "TextBackground")
        
        drawView.completionCutoffPercentage = 0.7
        
        transitionToTutorial()
    }
    
    fileprivate func addPlayAgainButton() {
        if playAgainButton.superview == nil {
            view.addSubview(playAgainButton)
            view.bringSubview(toFront: playAgainButton)
        }
    }
    
    fileprivate func removePlayAgainButton() {
        playAgainButton.removeFromSuperview()
    }
    
    fileprivate func addButton(withTitle title: String) {
        button.setTitle(title, for: .normal)
        if button.superview == nil {
            view.addSubview(button)
            view.bringSubview(toFront: button)
        }
    }
    
    private func removeButton() {
        button.removeFromSuperview()
    }
    
    private func setupZoomInButton() {
        zoomInButton = UIButton()
        zoomInButton.frame = CGRect(
            x: 20,
            y: zoomOutButton.frame.minY - 58,
            width: 50,
            height: 50
        )
        zoomInButton.setImage(#imageLiteral(resourceName: "ZoomIn"), for: .normal)
        zoomInButton.addTarget(self, action: #selector(SculptingInteractionViewController.didPressZoomIn(sender:)), for: .touchUpInside)
        zoomInButton.layer.cornerRadius = 5
        zoomInButton.clipsToBounds = true
        view.addSubview(zoomInButton)
    }
    
    func didPressZoomIn(sender: UIButton) {
        scrollView.setZoomScale(scrollView.zoomScale * 2, animated: true)
    }
    
    private func setupZoomOutButton() {
        zoomOutButton = UIButton()
        zoomOutButton.frame = CGRect(
            x: 20,
            y: button.frame.minY - 58,
            width: 50,
            height: 50
        )
        zoomOutButton.setImage(#imageLiteral(resourceName: "ZoomOut"), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(SculptingInteractionViewController.didPressZoomOut(sender:)), for: .touchUpInside)
        zoomOutButton.layer.cornerRadius = 5
        zoomOutButton.clipsToBounds = true
        view.addSubview(zoomOutButton)
    }
    
    func didPressZoomOut(sender: UIButton) {
        scrollView.setZoomScale(scrollView.zoomScale / 2, animated: true)
    }
    
    fileprivate func setTopText(text: String) {
        self.topTextView.text = text
        UIView.animate(withDuration: 0.25, animations: {
            self.topTextView.text = text
            self.topTextView.frame = CGRect(
                x: self.topTextView.frame.minX,
                y: self.topTextView.frame.minY,
                width: self.view.frame.width - 20,
                height: self.topTextView.frame.height
            )
            self.topTextView.sizeToFit()
            self.topTextView.frame = CGRect(
                x: (self.view.frame.width - self.topTextView.frame.width) / 2,
                y: self.topTextView.frame.minY,
                width: self.topTextView.frame.width,
                height: self.topTextView.frame.height
            )
            self.topTextView.textColor = UIColor.black.withAlphaComponent(0)
            self.topTextBackgroundView.frame = self.topTextView.frame
        }, completion: {
            finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                self.topTextView.textColor = UIColor.black.withAlphaComponent(1)
            }, completion: nil)
        })/*
         UIView.animate(withDuration: 0.25, delay: 0.25, options: .transitionFlipFromBottom, animations: {
         self.topTextView.text = text
         }, completion: nil)*/
    }
    
    private func setupCompletionView() {
        completionView = SculptingCompletionView(
            frame: CGRect(
                x: 20,
                y: view.frame.height - navigationController!.toolbar.frame.height - navigationController!.navigationBar.frame.height - 78,
                width: view.frame.width - 40,
                height: 50
            )
        )
        completionView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        completionView.layer.cornerRadius = 10
        completionView.completion = 0
        completionView.setNeedsLayout()
        //view.addSubview(completionView)
    }
    
    func transitionToTutorial() {
        completionView.isHidden = true
        
        setTopText(text: "These buttons zoom in and out of the interaction.")
        addButton(withTitle: "Ok, Got it!")
        setButtonAction(to: #selector(SculptingInteractionViewController.transitionToNose))
        scrollView.isUserInteractionEnabled = false
        
        let flashAnimation = CABasicAnimation(keyPath: "opacity")
        flashAnimation.autoreverses = true
        flashAnimation.duration = 0.3
        flashAnimation.fromValue = 1
        flashAnimation.toValue = 0.2
        flashAnimation.repeatCount = .greatestFiniteMagnitude
        zoomInButton.layer.add(flashAnimation, forKey: "opacity")
        zoomOutButton.layer.add(flashAnimation, forKey: "opacity")
    }
    
    func transitionToNose() {
        removeButton()
        zoomInButton.layer.removeAllAnimations()
        zoomOutButton.layer.removeAllAnimations()
        setTopText(text: "Now try sculpting with your fingers!")
        scrollView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 1, animations: {
            self.completionView.isHidden = false
        })
    }
    
    func transitionToHair() {
        setTopText(text: "Now let’s sculpt the Buddha’s hair.")
        removeButton()
        completionView.isHidden = false
    }
    
    func transitionToFinish() {
        removeButton()
        setTopText(text: "Now you can keep sculpting on your own before heading to the next object!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        drawView.delegate = self
        setupTopTextView()
        setupButton()
        setupSculpting()
        setupZoomOutButton()
        setupZoomInButton()
        setupCompletionView()
        setupPlayAgainButton()
        
        transitionToTutorial()
        
        //TOOLBAR
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
        navigationController?.setToolbarHidden(false, animated: true)
        let tabBarItems = ToolBarInfo.shared.getBarButtons()
        
        ToolBarInfo.shared.buttonActions[1] = toNextChapter
        if (!DataController.sharedData.linearJourney) {
            ToolBarInfo.shared.buttonActions[1] = toChapterMenu
        }
        
        if (DataController.sharedData.linearJourney) {
            let button = tabBarItems[tabBarItems.count - 2].customView as! UIButton
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).setImage(UIImage(named: "NextChapterButton"), for: .normal)
            (tabBarItems[tabBarItems.count - 2].customView as! UIButton).frame = CGRect(x: 0, y: 0, width: 170, height: 25)
            if #available(iOS 11, *) {
                button.removeConstraints(button.constraints)
                button.widthAnchor.constraint(equalToConstant: 170).isActive = true
                button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            }
        } else {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSculpting() {
        
        drawView.image = #imageLiteral(resourceName: "Clay1")
        drawView.contentMode = .scaleAspectFit
        drawView.blendMode = .clear
        drawView.backgroundColor = .clear
        drawView.lineWidth = 20
        drawView.fillColor = .clear
        drawView.colorPicker = false
        
        drawView.completionCutoffPercentage = 0.7
        
        backgroundImageView.image = #imageLiteral(resourceName: "Clay2")
        backgroundImageView.contentMode = .scaleAspectFill
        
        setTopText(text: topMessages.first!)
    }
    
    @IBAction func didPressFreeDraw(_ sender: UIButton) {
        isFreeDraw = !isFreeDraw
        if isFreeDraw {
            drawView.blendMode = .normal
            drawView.lineColor = .black
            drawView.alpha = 1
            drawView.lineWidth = 10
            drawView.fillColor = .black
            drawView.colorPickerView.colors = [.red, .yellow, .green, .blue, .black]
            //Over 100% so it never pops
            drawView.completionCutoffPercentage = 1.1
            
            UIView.animate(withDuration: 0.25, animations: {
                self.setTopText(text: "Draw your version of the Buddha head in the space below.")
                self.backgroundImageView.image = nil
                self.drawView.image = #imageLiteral(resourceName: "BlankCanvas")
                self.drawView.backgroundColor = .white
                self.view.layoutIfNeeded()
                self.drawView.colorPicker = false
            }, completion: {
                finished in
                UIView.animate(withDuration: 0.25) {
                    self.drawView.colorPicker = true
                    self.drawView.colorPickerView.backgroundColor = .groupTableViewBackground
                }
            })
        } else {
            var image = backgroundImageView.image
            backgroundImageView.image = nil
            UIView.animate(withDuration: 0.25, animations: {
                self.setupSculpting()
                image = self.backgroundImageView.image
                self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.backgroundImageView.image = image
                self.drawView.updateColorPickerViewFrame()
                self.drawView.colorPickerView.setNeedsDisplay()
            })
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
    
}

extension SculptingInteractionViewController: DrawViewDelegate {
    func shouldErase(point: CGPoint) -> Bool {
        switch sculptIndex {
        case 0:
            return noseCompletionPoints.contains(where: {
                p in
                print(p.x - point.x, p.y - point.y)
                return (abs(p.x - point.x) < 4) && (abs(p.y - point.y) < 4)
            })
            
        case 1:
            return hairCompletionPoints.contains(where: {
                p in
                return (abs(p.x - point.x) < 4) && (abs(p.y - point.y) < 4)
            })
        case 2:
            return true
        default:
            return true
        }/*
        return noseCompletionPoints.contains(where: {
            p in
            print(p.x - point.x, p.y - point.y)
            return (abs(p.x - point.x) < 4) && (abs(p.y - point.y) < 4)
        })*/
    }
    
    func drawView(_ drawView: DrawView, didCompleteDrawingWithPercentage percentage: Double) {
    }
    
    func checkNoseCompletion(points: Set<CGPoint>) -> Bool {
        //print(noseCompletionPoints.subtracting(points))
        print(noseCompletionPoints.subtracting(points).count)
        return noseCompletionPoints.subtracting(points).count < 85
    }
    
    func checkHairCompletion(points: Set<CGPoint>) -> Bool {
        print(hairCompletionPoints.subtracting(points).count)
        return hairCompletionPoints.subtracting(points).count < 320
    }
    
    func didBeginDrawing(atPercentage: Double) {
        if firstTouch {
            setTopText(text: "Great job! Keep going until the nose is completely uncovered!")
            firstTouch = false
        }
    }
    
    func didEndDrawing(atPercentage: Double) {
        
        completionView.set(completion: CGFloat(atPercentage))
        let completedPoints = drawView.completedPoints
        switch sculptIndex {
        case 0:
            if checkNoseCompletion(points: completedPoints) {
                setTopText(text: topMessages[0])
                addButton(withTitle: "Continue")
                setButtonAction(to: #selector(SculptingInteractionViewController.transitionToHair))
                completionView.isHidden = true
                sculptIndex += 1
            }
        case 1:
            if checkHairCompletion(points: completedPoints) {
                setTopText(text: topMessages[1])
                setButtonAction(to: #selector(SculptingInteractionViewController.transitionToFinish))
                addButton(withTitle: "Continue")
                completionView.isHidden = true
                sculptIndex += 1
            }
        case 2:
            if drawView.calculatePercentComplete() > 0.65 {
                topTextView.font = topTextView.font!.withSize(26)
                topTextBackgroundView.image = nil
                setTopText(text: topMessages[2])
                addPlayAgainButton()
                UIView.animate(withDuration: 1) {
                    self.drawView.alpha = 0
                }
            }
        default:
            break
        }
    }
}

extension SculptingInteractionViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return drawContainer
    }
}
