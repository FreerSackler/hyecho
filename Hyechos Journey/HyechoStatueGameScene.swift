//
//  HyechoStatueInteraction.swift
//  Hyechos Journey
//
//  Created by Bailey Case on 6/24/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import SpriteKit
import UIKit

class HyechoStatueGameScene : SKScene{
    
    weak var locationBackground : SKSpriteNode! = SKSpriteNode()
    weak var hyechoStatue : SKSpriteNode! = SKSpriteNode()
    weak var staminaBox : SKSpriteNode! = SKSpriteNode()
    weak var options : SKLabelNode! = SKLabelNode()
    weak var option1 : SKNode! = SKNode()
    weak var option2 : SKNode! = SKNode()
    weak var option3 : SKNode! = SKNode()
    weak var menuTab : SKNode! = SKNode()
    weak var playAgain : SKSpriteNode! = SKSpriteNode()
    weak var inventory : SKSpriteNode! = SKSpriteNode()
    weak var religiousTexts : SKSpriteNode! = SKSpriteNode()
    weak var almsBowl : SKSpriteNode! = SKSpriteNode()
    weak var goldcoins : SKSpriteNode! = SKSpriteNode()
    weak var medicine : SKSpriteNode! = SKSpriteNode()
    weak var cancelButton : SKSpriteNode! = SKSpriteNode()
    weak var hyechoTextbox: SKNode! = SKNode()
    weak var bigHyecho : SKNode! = SKNode()
    
    //set of bools that control what is being shown on screen
    //hyechoTalking and makingChoice should only ever get set true outside of these didSet functions
    var hyechoTalking : Bool = false {
        didSet{
            print (hyechoTalking)
            //if this is being set true
            if hyechoTalking{
                print ("WE MADE IT IN")
                makingChoice = false
            
                //here for safety
                intro = false
                outro = false
                
                hyechoTextbox.isHidden = false
            
                options.isHidden = true
                inventory.isHidden = true
            }
        }
    }
    //controls if we are showing chapters intro or outro
    var intro = false
    var outro = false
    
    var reset = false
    
    var makingChoice : Bool = false {
        didSet{
            print ("making choice -\(makingChoice)")
            //if this is being set true
            if makingChoice{
                print ("MakingChoice")
                hyechoTalking = false
                //put here for safety, should be unneeded
                intro = false
                outro = false
                
                var optionNum : Int = 0
                //only will be blank if is the first event or if is incorrectly input
                if (events[location].choices[optionNum] == ""){
                    EventOutro(choice: 100)
                    return
                }
                //set the text of the options based on current location
                for option in [option1,option2,option3] {
                    let temp1 : SKLabelNode = option!.childNode(withName: "Option\(optionNum+1)Top") as! SKLabelNode
                    temp1.text = "\(events[location].choices[optionNum])"
                    let temp2 : SKLabelNode = option!.childNode(withName: "Option\(optionNum+1)Bottom") as! SKLabelNode
                    temp2.text = events[location].choicesContuences[optionNum]
                    optionNum = optionNum+1
                }
                
                options.isHidden = false
                if events[location].choices[2] == "" {
                    option3.isHidden = true
                    option3.position.x = -5000.0
                } else {
                    option3.isHidden = false
                    option3.position.x = option1.position.x
                }
                hyechoTextbox.isHidden = true
            }
        }
    }
    
    var inventoryOpen : Bool = false {
        didSet{
            inventory.isHidden = !inventoryOpen
            goldcoins.isHidden = !goldcoinsAvailable
            religiousTexts.isHidden = !religiousTextsAvailable
            medicine.isHidden = !medicineAvailable
            almsBowl.isHidden = !almsBowlAvailable
        }
    }
    
    //acts as "health"
    var wellness : Int = 100 {
        didSet{
            //scale wellnessbar
            if wellness <= 0 {
                staminaBox.xScale = 0
            } else if wellness == 100 {
                staminaBox.xScale = 1
            } else {
                staminaBox.xScale = CGFloat(wellness)/100.0
            }
        }
    }
    //controls the text to be said
    var location = 0
    //controls multiple texts in location
    var locationIntroTextNum = 0
    var locationOutroTextNum = 0
    
    //holds all events and their info
    var events : [Event] = []
    
    var almsBowlAvailable = true
    var medicineAvailable = true
    var goldcoinsAvailable = true
    var religiousTextsAvailable = true
    
    //called onceat start
    override func didMove(to view: SKView) {
        print("didmove was called")
        isUserInteractionEnabled = true
        
        //lots of initialization
        locationBackground = childNode(withName: "LocationBackground") as! SKSpriteNode
        staminaBox = childNode(withName: "StaminaBox")?.childNode(withName: "Stamina") as! SKSpriteNode
        options = childNode(withName: "Options") as! SKLabelNode
        option1 = options.childNode(withName: "Option1")!
        option2 = options.childNode(withName: "Option2")!
        option3 = options.childNode(withName: "Option3")!
        playAgain = childNode(withName: "PlayAgain") as! SKSpriteNode
        playAgain.isHidden = true
        menuTab = childNode(withName: "MenuTab")!
        inventory = childNode(withName: "Inventory") as! SKSpriteNode
        religiousTexts = inventory.childNode(withName: "ReligiousTexts") as! SKSpriteNode
        almsBowl = inventory.childNode(withName: "AlmsBowl") as! SKSpriteNode
        medicine = inventory.childNode(withName: "Medicine") as! SKSpriteNode
        goldcoins = inventory.childNode(withName:"GoldCoins") as! SKSpriteNode
        cancelButton = inventory.childNode(withName: "Cancel") as! SKSpriteNode
        hyechoTextbox = childNode(withName: "Textbox")!
        bigHyecho = childNode(withName: "Temp")!
        
        //multiline text init
        let temp = hyechoTextbox.childNode(withName: "TextboxPlaceholder") as! SKLabelNode
        let hyechoText = SKMultilineLabel(text: "This text is arbitrary and here for no reason ERROR", labelWidth: 165, pos: temp.position, fontName: temp.fontName!,fontSize: 17, alignment: .left)
        hyechoText.name = "hyechoText"
        hyechoText.zPosition = temp.zPosition
        temp.removeFromParent()
        hyechoTextbox.addChild(hyechoText)
        
        let temp1 = bigHyecho.childNode(withName: "BigHyechoText") as! SKLabelNode
        let bigText = SKMultilineLabel(text: "This text is arbitrary and here for no reason ERROR", labelWidth: 185, pos: temp1.position, fontName: temp.fontName!,fontSize: temp.fontSize)
        bigText.name =  "bigText"
        bigText.zPosition = temp1.zPosition
        temp1.removeFromParent()
        bigHyecho.addChild(bigText)
        
        //events init
        InitializeEvents()
        
        EventIntro()
        print("didmove has ended")
    }
    
    
    
    
    //We just see hyecho talking and need to click to continue
    //when called it shifts the program to the right view
    func EventIntro(){
        print ("event intro called")
        if location == 7 {
            Win()
            return
        }
        if !hyechoTalking{
            //make sure its reset
            locationIntroTextNum = 0
            hyechoTalking = true
            intro = true
            outro = false
            locationBackground.texture = SKTexture(imageNamed: events[location].imageName)
        }
        if locationIntroTextNum < events[location].introText.count &&
            events[location].introText[locationIntroTextNum] != "" {
           
            //set to next text
            if (location == 0) {
                hyechoTextbox.isHidden = true
                for case let temp as SKMultilineLabel in bigHyecho.children {
                    temp.text = events[location].introText[locationIntroTextNum]
                    print ("locationInt: \(locationIntroTextNum)")
                    print ("location: \(location)")
                }
            }
            else {
                for case let temp as SKMultilineLabel in hyechoTextbox.children {
                    temp.text = events[location].introText[locationIntroTextNum]
                }
            }
            locationIntroTextNum = locationIntroTextNum + 1
        } else {
            locationIntroTextNum = 0
            //switch mode
            makingChoice = true
        }
    }
    //we see Hyecho talking
    //will shift the view to the correct things for us on first call
    func EventOutro(choice : Int){
        print ("event outro called")
        if !hyechoTalking{
            hyechoTalking = true
            outro = true
            locationOutroTextNum = 0
        }
        if choice != 100 && events[location].outroText[choice] == "Win" {
            Win()
            
        } else if choice == 100 {
            if location == 0 {
                FlipTempHyecho()
            }
            location = location + 1
            //switch mode
            intro = true
            outro = false
            hyechoTalking = false
            EventIntro()
        } else {
            for case let temp as SKMultilineLabel in hyechoTextbox.children {
                temp.text = events[location].outroText[choice]
            }
        }
    }
    
    //removes the big picture of Hyecho
    func FlipTempHyecho(){
        bigHyecho.isHidden = !bigHyecho.isHidden
    }
    
    //choose from a set of options based on the current conditions
    //leads into outro
    func MadeAChoice(number : Int){
        print ("clicked an option")
        var haveEnough = false
        var wellnessHit = false
        for choice in events[location].choiceLosesItem[number]{
            
            if let temp : Int = Int(choice){
                LoseWellness(number: temp, choice: number)
                wellnessHit = true
            } else if (choice == "POSSIBLEDEATH"){
                ChanceToDie(choice: number)
            }else {
                //see if you have enough items compared to the array of what you will lose - hp loses
                if ((Int(medicineAvailable)+Int(almsBowlAvailable)+Int(goldcoinsAvailable)+Int(religiousTextsAvailable) >= events[location].choiceLosesItem[number].count-Int(wellnessHit)) || haveEnough){
                    haveEnough = true
                    //if objects >= what they want (2)
                    if (!LoseObjects(object: choice, option: number)){
                        return
                    }
                    //return so comes back to this function
                }
                else{
                    AlreadyLostItem(object: "enough items", option : number)
                    return
                }
            }
        }
        //move to outro, not if we need to reset
        if !reset{
            EventOutro(choice: number)
        }
    }
    
    func ChanceToDie(choice: Int){
        if random(min: 0.0, max: 10.0) < 5{
            Lose(choice: choice)
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //reduces wellness and calls gameover if need below 0
    //returns true if player has died
    func LoseWellness(number : Int, choice : Int){
        wellness = wellness - number
        if wellness <= 0 {
            Lose(choice: choice)
            return
        }
        return
    }
    
    //removes item from inventory
    //if the item is already used, returns false
    func LoseObjects(object : String, option : Int)->Bool{
        switch object {
        case medicine.name!:
            if !medicineAvailable{
                AlreadyLostItem(object: object, option: option)
                return false
            }
            medicineAvailable = false
            break
        case almsBowl.name!:
            if !almsBowlAvailable{
                AlreadyLostItem(object: object, option: option)
                return false
            }
            almsBowlAvailable = false
            break
        case goldcoins.name!:
            if !goldcoinsAvailable{
                AlreadyLostItem(object: object, option: option)
                return false
            }
            goldcoinsAvailable = false
            break
        case religiousTexts.name!:
            if !religiousTextsAvailable{
                AlreadyLostItem(object: object, option: option)
                return false
            }
            religiousTextsAvailable = false
            break
        case "ANY":
            //remove two randomly, or a planned 2 idk
            if medicineAvailable{
                medicineAvailable = false
            } else if almsBowlAvailable {
                almsBowlAvailable = false
            } else if religiousTextsAvailable {
                religiousTextsAvailable = false
            } else if goldcoinsAvailable {
                goldcoinsAvailable = false
            }
            break
        default:
            break
        }
        return true
    }
    
    //called when players choose an option but do not have the item for it
    func AlreadyLostItem(object: String, option : Int) {
        let temp = [option1,option2,option3][option].childNode(withName: "Option\(option+1)Top") as! SKLabelNode
        temp.text = "Oops, you don't have "
        let temp2 = [option1,option2,option3][option].childNode(withName: "Option\(option+1)Bottom") as! SKLabelNode
        temp2.text = object.lowercased()
    }
    
    func Win(){
        outro = false
        intro = false
        inventoryOpen = false
        makingChoice = false
        hyechoTalking = false
        reset = true
        playAgain.isHidden = false
    }
    
    func Lose(choice : Int){
        outro = false
        intro = false
        inventoryOpen = false
        makingChoice = false
        hyechoTalking = false
        hyechoTextbox.isHidden = false
        options.isHidden = true
        for case let temp as SKMultilineLabel in hyechoTextbox.children {
            if events[location].deathText[choice] == ""{
                print("location:\(location), choice:\(choice)")
                temp.text = "Despite your best efforts you have died! Game Over."
            } else {
                temp.text = events[location].deathText[choice]
            }
        }
        reset = true
        playAgain.isHidden = false
    }
    
    //when player loses or wants to play again
    func Reset(){
        goldcoinsAvailable = true
        medicineAvailable = true
        religiousTextsAvailable = true
        almsBowlAvailable = true
        hyechoTalking = false
        location = 0
        wellness = 100
        reset = false
        playAgain.isHidden = true
        FlipTempHyecho()
        EventIntro()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print ("touched the screen")
        let touch:UITouch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        if reset {
            if playAgain.contains(touchLocation){
                Reset()
            }
        } else if inventoryOpen {
            print("opening Inventory")
            let tempLoc = touch.location(in: inventory)
            if cancelButton.contains(tempLoc){
                inventoryOpen = false
            }
        } else if (menuTab.contains(touchLocation)){
            print("menuTab pressed")
            inventoryOpen = true
        } else if intro {
            print("intro moved on")
            EventIntro()
        }else if outro {
            EventOutro(choice: 100)
        }else if makingChoice {
            let touchLocationInOptions = touch.location(in: options)
            var place = 0
            for child in options.children {
                if child.contains(touchLocationInOptions){
                    MadeAChoice(number: place)
                    break
                }
                place = place + 1
            }
        }
    }
    
    
    
    //idk best way to do this tbh
    func InitializeEvents(){
        let event1 : Event = Event(
            imageNameIn: "Icon",
            introTextIn: [
                "Hello, I am Hyecho. Like many of my fellow monks, I wish to travel to India in search of the Dharma.",
                "I must remain vigilant. The road ahead is a dangerous one. First, I will find a ship to sail to India.",
                ],
            outroTextIn: [
                "",
                "",
                "",
                ],
            deathTextIn: [
            "",
            "",
            ""
            ],
            choicesIn:[
                "",
                "",
                "",],
            choicesContIn:[
                "",
                "",
                "",],
            losesIn:[
                [""],
                [""],
                [""],
                ])
        let event2 : Event = Event(
            imageNameIn: "port",
            introTextIn: [
            "This one seems suitable. I will talk to the ship captain."
            ],
            outroTextIn: [
            "The captain is pleased and allows you to board the ship. Full sail ahead!",
            "The captain is pleased and allows you to board the ship. Full sail ahead!",
            "The captain is pleased and allows you to board the ship. Full sail ahead!",
            ],
            deathTextIn: [
                "",
                "",
                ""
            ],
            choicesIn:[
                "Offer to work for ",
                "Offer medicine for the",
                "Pay the captain for ",],
            choicesContIn:[
                "passage",
                "sailors",
                "voyage",],
            losesIn:[
                ["25"],
                ["Medicine"],
                ["GoldCoins"],
                ])
        let event3 : Event = Event(
            imageNameIn: "Sailing",
            introTextIn: [
                "Oh no. It looks like a storm is brewing. It is threatening to destroy the ship!",
                ],
            outroTextIn: [
                "The storm has subsided! We are safe for now.",
                "The storm has subsided! We are safe for now.",
                "The storm has subsided! We are safe for now.",
                ],
            deathTextIn: [
                "You have tried to wait out the storm, but the ship has been destroyed! Game Over.",
                "",
                ""
            ],
            choicesIn:[
                "Hide below deck",
                "Help the sailors sail",
                "Recite a mantra to ",],
            choicesContIn:[
                "and wait the storm out",
                "",
                "protect the ship",],
            losesIn:[
                ["POSSIBLEDEATH", "25"],
                ["50"],
                ["ReligiousTexts"],
                ])
        let event4 : Event = Event(
            imageNameIn: "IndiaForest",
            introTextIn: [
                "Finally, we have reached India.",
                "The weather here is very hot, and I am suddenly not feeling well…",
                "",
                ],
            outroTextIn: [
                "I feel better now and must continue my journey.",
                "I feel better now and must continue my journey.",
                "I feel better now and must continue my journey.",
                ],
            deathTextIn: [
                "You become gravely ill and are unable to continue! Game Over.",
                "You become gravely ill and are unable to continue! Game Over.",
                "You become gravely ill and are unable to continue! Game Over."
            ],
            choicesIn:[
                "Take medicine",
                "Forage the area for",
                ""
                ],
            choicesContIn:[
                "",
                "herbs",
                "",],
            losesIn:[
                ["Medicine"],
                ["25"],
                ])
        let event5 : Event = Event(
            imageNameIn: "desertFar",
            introTextIn: [
                "Oh no! It looks like a group of bandits are approaching.",
                ],
            outroTextIn: [
                "You have tried to run away, but the bandits catch you.",
                "You stand and wait for the bandits to approach.",
                "THIS OPTION SHOULD MAKE YOU DEAD."
                ],
            deathTextIn: [
                "",
                "",
                "You have tried to confront the bandits, but they overwhelm you! Game Over."
            ],
            choicesIn:[
                "Run away",
                "Wait for them to",
                "Confront the bandits",],
            choicesContIn:[
                "",
                "approach",
                "",],
            losesIn:[
                ["25"],
                [""],
                ["100"],
                ])
        let event6 : Event = Event(
            imageNameIn: "desertClose",
            introTextIn: [
                "The bandits are demanding that I give them all my possessions."
                ],
            outroTextIn: [
                "The bandits get angry and beat you.",
                "The bandits are unstatisfied and beat you before leaving.",
                "The bandits are pleased and leave you.",
                ],
            deathTextIn: [
                "You have been overwhelmed by the bandits! Game Over.",
                "",
                "",
            ],
            choicesIn:[
                "Attempt to talk your way",
                "Give them 1 item, hiding",
                "Give them everything",],
            choicesContIn:[
                "out of the situation",
                "the rest",
                "you have",],
            losesIn:[
                ["75"],
                ["25" , "ANY"],
                ["ANY", "ANY"],
                ])
        let event7 : Event = Event(
            imageNameIn: "Mahabodhi",
            introTextIn: [
                "I have made it to the Mahabodhi Temple!",
                "It is truly a wondrous sight!",
                "",
            ],
            outroTextIn: [
                "WIN",
                "WIN",
                "WIN",
                ],
            deathTextIn: [
                "",
                "",
                ""
            ],
            choicesIn:[
                "",],
            choicesContIn:[
                "",
                "",
                "",],
            losesIn:[
                [""],
                [""],
                [""],
                ])
        events = [event1,event2,event3,event4,event5,event6,event7]
    }
    
}

//class used to hold information for each event
class Event{
    
    var imageName : String
    
    var introText : [String]
    var outroText : [String]
    var deathText : [String]
    //the top line of text for each choice
    
    //max 26 characters for both choices and choicesContuences at 14 pt font
    var choices : [String]
    //the bottom line of text for each choice
    var choicesContuences : [String]
    //if the first String in the inner array is a number then this is treated as losing wellness by that numbers percent
    //if the first String is Text then we see if there is more to lose too
    //if String is "ANY" then 2 objects will be removed at random(?)
    var choiceLosesItem : [[String]]
    
    init(imageNameIn : String, introTextIn : [String], outroTextIn: [String], deathTextIn: [String], choicesIn : [String], choicesContIn : [String], losesIn : [[String]]){
        imageName = imageNameIn
        introText = introTextIn
        outroText = outroTextIn
        deathText = deathTextIn
        choices = choicesIn
        choicesContuences = choicesContIn
        choiceLosesItem = losesIn
    }
}

extension Int {
    init(_ bool:Bool) {
        self = bool ? 1 : 0
    }
}













