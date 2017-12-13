//
//  File.swift
//  Hyechos Journey
//
//  Created by Eric Yeh on 2017/6/6.
//  Copyright © 2017年 hyecho. All rights reserved.
//

import Foundation
import UIKit

struct Ques{
    var question = ""
    var answerA = ""
    var answerB = ""
    var answerC = ""
    var correctAnswer = ""
}

var questionarray = [
    
    Ques(question: "who is Heycho",
         answerA: "I'm answer", answerB: "hi", answerC: "maybe...",
         correctAnswer: "A"),
    Ques(question: "who is Heycho",
         answerA: "I don't know", answerB: "I'm answer", answerC: "maybe...",
         correctAnswer: "B"),
    Ques(question: "who is Heycho",
         answerA: "I don't know", answerB: "hi", answerC: "pick me",
         correctAnswer: "C"),
    Ques(question: "Test the wron answer",
         answerA: "dont't pick me", answerB: "hi", answerC: "maybe...",
         correctAnswer: "A")
]

var knowledgetest = false
var sravaka = false
var pratyekataddha = false
var bodhisattiva = false
var firstrun = true

var locktap = false


var sakyamunibuddhatext = [
    "O Prabhutaratna. How wonderful it is to sit by your side. Let us teach the dharma to those who may listen. Can you tell us about the three vehicles to enlightenment?",
    "Very good. Now, you may choose to test your knowledge or learn more about another vehicle."," According to the Lotus Sutra, there is only one true vehicle to enlightenment, leading to buddhahood. Which vehicle is it? ",
    "Very good. You learned about all the vehicles. Test your knowledge now."
]
var prabhutaratnatext = [
    "Yes. Which vehicle would you like me to speak about? ",
    "A shravaka, or \"listener\", is one who has listened to the teachings of the Buddha and has become an arhat, or \"worthy one\". ",
    "A pratyekabuddha is one who attains enlightenment on their own, but does not teach others and save them from suffering.",
    "A bodhisattva is one who vows to become a fully-enlightened Buddha in order to teach others and save them from suffering.",
    "Which vehicle would you like me to speak about? "
]

var saktext2 = ["O Prabhutaratna. I have preached the Lotus Sutra to countless beings to tell them that the Buddha’s lifespan is in fact immeasurable. Can you speak about some of the parables?", ""]
var prahutext2 = ["Yes. Which parable would you like to speak about?",
                  "In this parable, the Buddha tells beings that the bodhisattva vehicle is supreme among the three vehicles which save beings from the cycle of suffering or the \"burning house.\"",
                  "In this parable, the Buddha tells beings that he would die so that they would be inspired to practice, when in fact his lifespan is immeasurable.",
                  "In this parable, the Buddha tells beings that he guided them to become Arhats so that they would not be discouraged as the path to Buddhahood is long and difficult.",
                  "Very good. Now you may choose to test your knowledge or learn more about another parable.",
                  "Very good. You learned about all the parables. Test your knowledge"
]

class ConversationViewController: UIViewController {


    @IBOutlet weak var leftbuda: UIImageView!
    @IBOutlet weak var rightbuda: UIImageView!
    @IBOutlet weak var midbuble: UIImageView!
    @IBOutlet weak var leftbox: UIImageView!
    @IBOutlet weak var rightbox: UIImageView!
    @IBOutlet weak var textA: UITextView!
    @IBOutlet weak var textB: UITextView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var feedbackbutton1: UIButton!
    @IBOutlet weak var feedbackbutton2: UIButton!
    
    @IBOutlet weak var playagain: UIButton!
    
    @objc func toNextChapter(sneder: UIButton) {
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
    
    @IBAction func end(_ sender: Any)
    {
        /*var storyboard = UIStoryboard()
        storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        let interaction = storyboard.instantiateInitialViewController()!
        navigationController?.pushViewController(interaction, animated: true)
         */
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.rightbuda.alpha = 1
            self.leftbox.isHidden = false
            self.midbuble.isHidden = true
            self.leftbuda.center.x -= 100
        }, completion:{
            finished in
            
            
        })
        self.viewDidLoad()

        
        
    }
    
    @IBAction func click1(_ sender: Any) {
        
        if knowledgetest{
            self.textA.text = "Not quite. A shravaka becomes an arhat by listening to the teachings of the Buddha."
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations:{
                    self.textB.text = prabhutaratnatext[1]
                }, completion:{
                    finished in
                    /*self.button1.isHidden = true
                    self.button2.isHidden = true
                    self.button3.isHidden = true
                    if sravaka && pratyekataddha && bodhisattiva
                    {
                        self.textA.text = sakyamunibuddhatext[3]
                        self.feedbackbutton2.isHidden = false
                    }
                    else
                    {
                        self.textA.text = sakyamunibuddhatext[1]
                        self.feedbackbutton1.isHidden = false
                        self.feedbackbutton2.isHidden = false
                    }*/

                })
                
                sravaka = true
                self.button1.isHidden = true
                self.button2.isHidden = true
                self.button3.isHidden = true
            
                locktap = false
            

        }

    }
    
    @IBAction func click2(_ sender: Any) {
        if knowledgetest{
            self.textA.text = " Not quite. A pratyekabuddha is a self-enlightened being, but is not a fully-enlightened buddha as he does not teach others."
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                self.textB.text = prabhutaratnatext[2]
            }, completion:{
                finished in
                /*self.button1.isHidden = true
                self.button2.isHidden = true
                self.button3.isHidden = true
                if sravaka && pratyekataddha && bodhisattiva
                {
                    self.textA.text = sakyamunibuddhatext[3]
                    self.feedbackbutton2.isHidden = false
                }
                else
                {
                    self.textA.text = sakyamunibuddhatext[1]
                    self.feedbackbutton1.isHidden = false
                    self.feedbackbutton2.isHidden = false
                }*/
            })
            pratyekataddha = true
            self.button1.isHidden = true
            self.button2.isHidden = true
            self.button3.isHidden = true
            locktap = false
        }

    }
    
    @IBAction func click3(_ sender: Any) {
        if knowledgetest{
            self.textA.text = "Correct. A bodhisattva has made a vow to become a fully enlightened Buddha to teach the dharma and save all sentient beings from suffering. "
            
            self.playagain.isHidden = false
            self.button1.isHidden = true
            self.button2.isHidden = true
            self.button3.isHidden = true
            
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                self.textB.text = prabhutaratnatext[3]
            }, completion:{
                finished in
                /*self.button1.isHidden = true
                self.button2.isHidden = true
                self.button3.isHidden = true
                if sravaka && pratyekataddha && bodhisattiva
                {
                    self.textA.text = sakyamunibuddhatext[3]
                    self.feedbackbutton2.isHidden = false
                }
                else
                {
                    self.textA.text = sakyamunibuddhatext[1]
                    self.feedbackbutton1.isHidden = false
                    self.feedbackbutton2.isHidden = false
                }*/
            })
            
            bodhisattiva = true
            self.button1.isHidden = true
            self.button2.isHidden = true
            self.button3.isHidden = true
            locktap = false
        }

    }
    
    
    @IBAction func morekowledge(_ sender: Any) {
        
        if !sravaka
        {
            self.button1.isHidden = false
        }
        
        if !pratyekataddha
        {
            self.button2.isHidden = false
        }
        
        if !bodhisattiva
        {
            self.button3.isHidden = false
        }
        

        self.feedbackbutton1.isHidden = true
        self.feedbackbutton2.isHidden = true
        self.textA.isHidden = true
        self.textB.isHidden = false
        self.leftbox.isHidden = true
        self.rightbox.isHidden = false
        self.textB.text = prabhutaratnatext[4]
        locktap = true
    }
    
    @IBAction func test(_ sender: Any) {
        self.textA.text = sakyamunibuddhatext[2]
        
        self.button1.isHidden = false
        self.button2.isHidden = false
        self.button3.isHidden = false
        self.feedbackbutton1.isHidden = true
        self.feedbackbutton2.isHidden = true
        
        knowledgetest = true
        locktap = true
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            self.rightbuda.alpha = 0
            self.leftbox.isHidden = true
            self.midbuble.isHidden = false
            self.leftbuda.center.x += 100
        }, completion:{
            finished in
            
            
        })
        
        
        
    }
    
    func singleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        if !locktap
        {
            if firstrun
            {
                UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
                    self.textB.isHidden = false
                    self.textA.isHidden = true
                    self.leftbox.isHidden = true
                    self.rightbox.isHidden = false
                    self.textB.text = prabhutaratnatext[0]
                    self.button1.isHidden = false
                    self.button2.isHidden = false
                    self.button3.isHidden = false
                    locktap = true
                }, completion:{
                    finished in
                    
                    
                })
            }
            else
            {
                self.button1.isHidden = true
                self.button2.isHidden = true
                self.button3.isHidden = true
                if sravaka && pratyekataddha && bodhisattiva
                {
                    self.textA.text = sakyamunibuddhatext[3]
                    self.feedbackbutton2.isHidden = false
                }
                else
                {
                    self.textA.text = sakyamunibuddhatext[1]
                    self.feedbackbutton1.isHidden = false
                    self.feedbackbutton2.isHidden = false
                }
                self.textA.isHidden = false
                self.textB.isHidden = true
                self.leftbox.isHidden = false
                self.rightbox.isHidden = true
            }
        }
        
        firstrun = false


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sravaka = false
        pratyekataddha = false
        bodhisattiva = false
        locktap = false
        knowledgetest = false
        firstrun = true
        self.leftbox.isHidden = true
        self.rightbox.isHidden = true
        self.midbuble.isHidden = true
        self.textA.text = ""
        self.textB.text = ""
        self.textA.isHidden = true
        self.textB.isHidden = true
        self.button1.isHidden = true
        self.button2.isHidden = true
        self.button3.isHidden = true
        self.feedbackbutton1.isHidden = true
        self.feedbackbutton2.isHidden = true
        self.playagain.isHidden = true
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        let tempButton = UIBarButtonItem(customView: DataController.sharedData.menuView)
        self.navigationItem.leftBarButtonItems = [DataController.sharedData.negativeSpace, tempButton]
        
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
        
        let taptocontinue = UITapGestureRecognizer(
            target:self,
            action:#selector(singleTap))
        
        taptocontinue.numberOfTapsRequired = 1
        taptocontinue.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(taptocontinue)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.textA.isHidden = false
            self.textA.text = sakyamunibuddhatext[0]
            self.leftbox.isHidden = false
        }, completion:{
            finished in
            
        })
        

        
/*
        UIView.animate(withDuration: 0.5, delay: 2.2, options: .curveEaseOut, animations: {
            self.textB.isHidden = false
            self.textB.text = prabhutaratnatext[0]
        }, completion:{
            finished in
                self.button1.isHidden = false
                self.button2.isHidden = false
                self.button3.isHidden = false

        })
        */

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}
