//
//  MedicineBuddhaGameScene.swift
//  Hyechos Journey
//
//  Created by Bailey Case on 6/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import SpriteKit

class MedicineBuddhaGameScene : SKScene {
    
    weak var itemTab : SKNode! = SKNode()
    weak var itemsPage : SKNode! = SKNode()
    weak var buddhaText : SKNode! = SKNode()
    //weak var PatientTextBox : SKNode! = SKNode()
    weak var ginsing : SKNode! = SKNode()
    weak var radishes : SKNode! = SKNode()
    weak var bananas : SKNode! = SKNode()
    weak var lime : SKNode! = SKNode()
    weak var blacksesameseed : SKNode! = SKNode()
    weak var patient : SKSpriteNode! = SKSpriteNode()
    weak var reminder : SKNode! = SKNode()
    weak var reminderText : SKLabelNode! = SKLabelNode()
    weak var playAgainButton : SKSpriteNode! = SKSpriteNode()
    weak var plate : SKSpriteNode! = SKSpriteNode()
    var items : [SKNode] = []
    
    
    weak var menuCancel : SKSpriteNode! = SKSpriteNode()
    
    var plateLoc = CGPoint(x: 0.00, y: 0.00)
    var patientOrigin = CGPoint(x: 0.00, y: 0.00)
    var patientImages = ["sick1","sick2","sick3"]
    
    //control bools
    var appStart = false
    var inMenu = false
    var inIntro = false
    var inVictory = false
    var inWrong = false
    var WIN = false
    
    var patientcount = 0;
    
    //problem variables
    //aligns with prompts array
    var solution : [String] = ["Radishes",
                               "Ginsing",
                               "BlackSesameSeed",
                               "Lime",
                               "Bananas"]
    //prompts for each object
    //aligns with solution array
    var prompts : [String] = ["His heart is not well. He needs food that is bitter.",
                              "His lungs are not well. He needs food that is spicy.",
                              "His kidneys are not well. He needs food that is salty.",
                              "His liver is not well. He needs food that is sour.",
                              "His spleen is not well. He needs food that is sweet."]
    
    var promptWins : [String] = ["The patient has been cured! In traditional Asian medicine, bitter foods that are red were used to treat the heart.",
                                 "The patient has been cured! In traditional Asian medicine, spicy foods that are white were used to treat the lungs.",
                                 "The patient has been cured! In traditional Asian medicine, salty foods that are black were used to treat the kidneys.",
                                 "The patient has been cured! In traditional Asian medicine, sour foods that are green were used to treat the liver.",
                                 "The patient has been cured! In traditional Asian medicine, sweet foods that are yellow were used to treat the spleen."]
    
    
    var patientWords : [String] = ["Ah, I’m in pain…",
                                   "Ah, it hurts…",
                                   "Ah, I’m not feeling well…"]
    
    var startText : [String] = ["Many sick people have come to me for healing. With your help, I can bring them back to health.",
                                "Each person is affected in a different part of their body. Choose the food with the taste that helps cure their illness."]
    
    var winText : String = "Congratulations! All the patients have been cured."
    var loseText : String = "This food has no effect on the patient. The illness worsened and the patient has died."
    
    //this controls which item users need to get and what is said
    var problem = 0
    
    //tracks which have already been used, also used to see how many players have beaten
    var prevProblems : [Int] = []
    
    //Amount of problems users need to complete to win
    let winningAmount = 3
    
    //called onceat start
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = true
        
        itemTab = self.childNode(withName: "Menu") as SKNode!
        itemsPage = self.childNode(withName: "Items") as SKNode!
        buddhaText = self.childNode(withName: "BuddhaText") as SKNode!
        menuCancel = itemsPage.childNode(withName: "Cancel") as! SKSpriteNode!
        
        ginsing = itemsPage.childNode(withName: "Ginsing") as SKNode!
        radishes = itemsPage.childNode(withName: "Radishes") as SKNode!
        bananas = itemsPage.childNode(withName: "Bananas") as SKNode!
        lime = itemsPage.childNode(withName: "Lime") as SKNode!
        blacksesameseed = itemsPage.childNode(withName: "BlackSesameSeed") as SKNode!
        reminder = self.childNode(withName: "Reminder") as SKNode!

        reminderText = reminder.childNode(withName: "textBottom") as! SKLabelNode!
        
        patient = self.childNode(withName: "patient") as! SKSpriteNode!
        patientOrigin = patient.position
        
        plate = patient.childNode(withName: "plate") as! SKSpriteNode!
        
        items = [ginsing,radishes,bananas,lime,blacksesameseed]
        
        playAgainButton = self.childNode(withName: "PlayAgainButton") as! SKSpriteNode!
        
        //set up multiline Label for buddha's text
        let placeholder = buddhaText.childNode(withName: "TextPlaceholder") as! SKLabelNode
        let paragraph = SKMultilineLabel(text: "This is temporary text that has no place here. If you see it please dial 911.", labelWidth: 170,pos: placeholder.position,fontSize: 17)
        paragraph.name = placeholder.name
        paragraph.zPosition = placeholder.zPosition
        placeholder.removeFromParent()
        buddhaText.addChild(paragraph)
        
        //PatientTextBox = self.childNode(withName: "PatientText") as SKNode!
        //set up multiline Label for patient text
        //let placehold = PatientTextBox.childNode(withName: "Text") as! SKLabelNode
        //let paragrap = SKMultilineLabel(text: "This is temporary text that has no place here. If you see it please dial 911.", labelWidth: 120,pos: placehold.position,fontSize: 17)
       // paragrap.name = placehold.name
        //paragrap.zPosition = placehold.zPosition
        //placehold.removeFromParent()
        //PatientTextBox.addChild(paragrap)
        //PatientTextBox.isHidden = true
        
        //set ishidden values
        playAgainButton.isHidden = true
        itemsPage.isHidden = true
        buddhaText.isHidden = true
        itemTab.isHidden = true
        reminder.isHidden = true
        
        AppStart()
    }
    
    
    func HandleMenuClose(touch : UITouch){
        let loc = touch.location(in: itemsPage)
        if menuCancel.contains(loc){
            inMenu = false
            itemsPage.isHidden = true
        }
    }
    
    func HandleItemChoice(touch: UITouch){
        for child in itemsPage.children{
            let loc = touch.location(in: child)
            for check in child.children{
                if check.contains(loc){
                    CheckAnswer(answer: child.name!)
                }
            }
        }
    }
    
    func HandleMenuOpen(touch : UITouch){
        for child in itemTab.children{
            let loc = touch.location(in: child.self)
            if child.contains(loc){
                itemsPage.isHidden = false
                inMenu = true
            }
        }
    }
    
    func AppStart(){
        appStart = true
        buddhaText.isHidden = false
        for case let child as SKMultilineLabel in buddhaText.children{
            child.text = startText[0]
        }
    }
    
    func ContinueAppStart(){
        for case let child as SKMultilineLabel in buddhaText.children{
            if child.text == startText[1]{
                appStart = false
                StartIntro()
                return
            }
            child.text = startText[1]
        }
    }
    
    func StartIntro(){
        inIntro = true
        buddhaText.isHidden = false
        
        problem = Int(random(min: 0.0, max: CGFloat(solution.count)))
        while prevProblems.contains(problem){
            if (prevProblems.count > 5){
                prevProblems = []
            }
            problem = (problem + 1) % prevProblems.count
        }
        
        //for case let child as SKMultilineLabel in PatientTextBox.children{
            //child.text = patientWords[prevProblems.count]
            //PatientTextBox.isHidden = false
            //buddhaText.isHidden = true
            reminder.isHidden = true
        //}
        for case let child as SKMultilineLabel in buddhaText.children{
            child.text = prompts[problem]
            buddhaText.isHidden = false
        }
        prevProblems.append(problem)
    }
    
    func ContinueIntro(touch: UITouch){
        for case let child as SKMultilineLabel in buddhaText.children{
            //if !PatientTextBox.isHidden{
               // PatientTextBox.isHidden = true
           // } else {
                inIntro = false
                buddhaText.isHidden = true
                reminder.isHidden = false
                reminderText.text = ("Remember he needs something \(child.text.components(separatedBy: " ").last!)")
                itemTab.isHidden = false
            //}
        }
    }
    
    func StartWrongAnswer(answer:String){
        inWrong = true
        for case let child as SKMultilineLabel in buddhaText.children{
            child.text = "We can't give him that, It will not help him!"
        }
        reminder.isHidden = true
        buddhaText.isHidden = false
    }
    
    func ContinueWrongAnswer(){
        inWrong = false
        buddhaText.isHidden = true
        reminder.isHidden = false
    }
    
    func StartVictory(answer:String){
        reminder.isHidden = true
        if prevProblems.count == winningAmount {
            WIN = true
        } else {
            inVictory = true
        }
        
        for case let child as SKMultilineLabel in buddhaText.children{
            child.text = promptWins[problem]
        }
        
        for item in items {
            if item.name == answer{
                let tempPicture = item.childNode(withName: "image")!.copy() as! SKSpriteNode
                tempPicture.position = item.position
                tempPicture.zPosition = 5
                tempPicture.move(toParent: self.plate)
                self.isUserInteractionEnabled = false
                let actions = SKAction.sequence([
                    SKAction.move(to: CGPoint(x: 0, y: 10), duration: 1.5),
                    SKAction.run({
                        self.buddhaText.isHidden = false
                        self.isUserInteractionEnabled = true
                    })
                    
                ])
                tempPicture.run(actions)
                tempPicture.run(SKAction.scale(by: 0.65, duration: 1.5))
            }
        }
    }
    
    func ContinueVictory(){
        
        isUserInteractionEnabled = false;
        self.buddhaText.isHidden = true;

        let firstMove = SKAction.move(to: CGPoint(x:-404.0,y:patient.position.y + 100), duration: 1.0)
        let thirdMove = SKAction.move(to: patientOrigin, duration: 1.0)
        
        let actions2 = SKAction.sequence([
            firstMove,
            SKAction.run({
                if self.WIN {
                    self.patient.isHidden = false
                } else {
                    switch self.prevProblems.count{
                    case 0:
                        self.patient.texture = SKTexture(imageNamed: "sick1")
                        break
                    case 1:
                        self.patient.texture = SKTexture(imageNamed: "sick2")
                        break
                    case 2:
                        self.patient.texture = SKTexture(imageNamed: "sick3")
                        break
                    default:
                        break
                    }
                }
                self.plate.removeAllChildren()
                self.patient.position.x = 404.0}),
            thirdMove,
            SKAction.run({
                self.isUserInteractionEnabled = true;
                self.StartIntro()
                self.inVictory = false
            }),
            ])
        patient.run(actions2)
    }
    
    func WinGame(touch: UITouch){
        let loc = touch.location(in: self)
        if (!playAgainButton.isHidden){
            if (playAgainButton.contains(loc)){
                plate.removeAllChildren()
                playAgainButton.isHidden = true
                self.patient.texture = SKTexture(imageNamed: "sick1")
                Reset()
                WIN = false
                return
            }
        }
        for case let child as SKMultilineLabel in buddhaText.children{
            child.text = winText
            playAgainButton.isHidden = false
            patient.isHidden = false
        }
    }
    
    func CheckAnswer(answer: String){
        itemsPage.isHidden = true
        inMenu = false
        if answer == solution[problem]{
            StartVictory(answer:answer)
        } else {
            StartWrongAnswer(answer:answer)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        if appStart{
            ContinueAppStart()
        }else if inIntro {
            ContinueIntro(touch: touch)
        }else if inVictory{
            ContinueVictory()
        }else if inWrong{
            ContinueWrongAnswer()
        }else if inMenu {
            HandleMenuClose(touch: touch)
            HandleItemChoice(touch: touch)
        }else if WIN {
            WinGame(touch: touch)
        }else {
            HandleMenuOpen(touch: touch)
        }
    }
    
    
    //to be used when player beats a level
    func Reset(){
        prevProblems.removeAll()
        patient.isHidden = false
        AppStart()
    }
    
    //utility random function
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}








    //MIGHT REVISIT THIS TO RANDO INTERACTION

//    //randomly assigns a problem
//    func setProblem(){
//        curProblem = (curProblem%4) + 1
//
//        let multitext = problemPage.childNode(withName: "description") as! SKMultilineLabel
//        switch curProblem{
//        case 1:
//            multitext.text = problemDescription1
//            var count = 0
//            for case let symptom as SKLabelNode in problemPage.children{
//                if (symptom.name?.contains("symptom"))! && count < problemSymptons1.count{
//                    symptom.text = problemSymptons1[count]
//                    count = count+1
//                }
//            }
//            clayplate.setTargetRecipe(inName: recipeName1, inIngreds: recipeIngredients1)
//            break
//        case 2:
//            multitext.text = problemDescription2
//            var count = 0
//            for case let symptom as SKLabelNode in problemPage.children{
//                if (symptom.name?.contains("symptom"))! && count < problemSymptons2.count{
//                    symptom.text = problemSymptons2[count]
//                    count = count+1
//                }
//            }
//            clayplate.setTargetRecipe(inName: recipeName2, inIngreds: recipeIngredients2)
//            break
//        case 3:
//            multitext.text = problemDescription3
//            var count = 0
//            for case let symptom as SKLabelNode in problemPage.children{
//                if (symptom.name?.contains("symptom"))! && count < problemSymptons3.count{
//                    symptom.text = problemSymptons3[count]
//                    count = count+1
//                }
//            }
//            clayplate.setTargetRecipe(inName: recipeName3, inIngreds: recipeIngredients3)
//            break
//        case 4:
//            multitext.text = problemDescription4
//            var count = 0
//            for case let symptom as SKLabelNode in problemPage.children{
//                if (symptom.name?.contains("symptom"))! && count < problemSymptons4.count{
//                    symptom.text = problemSymptons4[count]
//                    count = count+1
//                }
//            }
//            clayplate.setTargetRecipe(inName: recipeName4, inIngreds: recipeIngredients4)
//            break
//        default:
//            break
//        }
//    }

