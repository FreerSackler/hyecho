//
//  EwerGameScene.swift
//  Hyechos Journey
//
//  Created by Eric Yeh on 2017/7/7.
//  Copyright © 2017年 hyecho. All rights reserved.
//

import SpriteKit
import UIKit

var cupfill : SKSpriteNode!
var winefull : [SKTexture]!

class EwerGameScene : SKScene {
    
    weak var playAgainButton : SKSpriteNode! = SKSpriteNode()
    weak var cup1 : Cupitem! = Cupitem()
    weak var cup2 : Cupitem! = Cupitem()
    weak var cup3 : Cupitem! = Cupitem()
    weak var cup4 : Cupitem! = Cupitem()
    var arrowfirstime = true
    
    var startpickingcup = false
    
    var ewermode : Bool = true
    
    var paulse = false
    
    var touchOK = true
    
    var notmovetocup = true
    
    var playlock = true
    
    weak var particles: SKEmitterNode!
    
    
    weak var viewController : EwerViewController!
    
    var cups : [Cupitem] = []
    
    var backlock = true;
    var firstime = true;
    
    weak var multitext : SKLabelNode!
    weak var multitext2 : SKLabelNode!
    weak var multitext3 : SKLabelNode!
    weak var multitext4 : SKLabelNode!
    
    weak var glowanimate1 : SKSpriteNode!
    weak var glowanimate2 : SKSpriteNode!
    weak var glowanimate3 : SKSpriteNode!
    weak var glowanimate4 : SKSpriteNode!
    


    var description2 : SKMultilineLabel!
    var opentext : SKMultilineLabel!
    var ewerdescription : SKMultilineLabel!
    var cuptext : SKMultilineLabel!
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        isUserInteractionEnabled = true
        
        let ewergraybox = childNode(withName: "grayboxewer") as! SKSpriteNode
        let cupgraybox = childNode(withName: "grayboxcup") as! SKSpriteNode
        let botgraybox = childNode(withName: "grayboxbot") as! SKSpriteNode
        let botgraybox2 = childNode(withName: "grayboxbot2") as! SKSpriteNode
        let botgraybox3 = childNode(withName: "grayboxbot3") as! SKSpriteNode
        let botgraybox4 = childNode(withName: "grayboxbot4") as! SKSpriteNode
        playAgainButton = self.childNode(withName: "playagain") as! SKSpriteNode!
        
        botgraybox.isHidden = true
        ewergraybox.isHidden = true
        cupgraybox.isHidden = true
        playAgainButton.isHidden = true
        botgraybox2.isHidden = true
        botgraybox3.isHidden = true
        botgraybox4.isHidden = true
        

        multitext = childNode(withName: "cupdescription") as! SKLabelNode
        description2 = SKMultilineLabel(text: "", labelWidth: 600,pos: multitext.position,fontSize: 30, alignment:.left)
        description2.name = multitext.name
        description2.zPosition = multitext.zPosition
        //multitext.text = ""
        multitext.removeFromParent()
        addChild(description2)
        
        multitext2 = childNode(withName: "text1") as! SKLabelNode
        opentext = SKMultilineLabel(text: "", labelWidth: 500,pos: multitext2.position,fontSize: 30, alignment:.left)
        opentext.name = multitext2.name
        opentext.zPosition = multitext2.zPosition
        //multitext.text = ""
        multitext2.removeFromParent()
        addChild(opentext)
        
        opentext.text = "Welcome! You have arrived at the annual celebration honoring Anahita, one of the major Sasanian female deities. It is tradition to first pour a drink in her honor before starting the festivities."
        
        multitext3 = childNode(withName: "ewertext") as! SKLabelNode
        ewerdescription = SKMultilineLabel(text: "", labelWidth: 600,pos: multitext3.position,fontSize: 30, alignment:.left)
        ewerdescription.name = multitext3.name
        ewerdescription.zPosition = multitext3.zPosition
        //multitext.text = ""
        multitext3.removeFromParent()
        addChild(ewerdescription)
        ewerdescription.isHidden = true
        ewerdescription.text = " Pick up the ewer. Then tap the cup that belongs to Anahita. To put the ewer down, tap on the saucer."
        
        multitext4 = childNode(withName: "cuptext") as! SKLabelNode
        cuptext = SKMultilineLabel(text: "", labelWidth: 400,pos: multitext4.position,fontSize: 30, alignment:.left)
        cuptext.name = multitext4.name
        cuptext.zPosition = multitext4.zPosition
        //multitext.text = ""
        multitext4.removeFromParent()
        addChild(cuptext)
        cuptext.isHidden = true
        cuptext.text = "Tap each cup to read a description of the deity."
        
        

        if let cup1 = childNode(withName: "cup1") as? Cupitem{
            cup1.originalPos = cup1.position
            cup1.explain = "She is the divinity of water and was associated with wisdom, healing, and fertility. Because she was the source of life, warriors prayed to her for survival and victory. She is shown wearing a high crown and often carries a water-pot. The dove and peacock are sacred to her. Under Sasanian rule, she appeared in scenes of the enthronement of the king, protecting his sovereignty."
            cup1.choicetext = "Congratulations! You’ve chosen Anahita’s cup. The festivities may now begin."
            cup1.correctcup = true
            cup1.cupnumber = 1

            cups.append(cup1)
            cups.shuffle()

        }
        else
        {
            print("oop")
        }

      // cup1 = childNode(withName: "cup1") as? Cupitem{

        if let cup2 = childNode(withName: "//cup2") as? Cupitem{
            cup2.originalPos = cup2.position
            cup2.explain = "She is the personification of health and perfection. She is a spirit who, together with Ameretat, was created by Ahura Mazda, the “wise lord,” or creator. Both Haurvatat and Ameretat countered the demons of thirst and hunger.  In the realm of the material world, Haurvatat is the guardian spirit of water."
            cup2.choicetext = "Sorry, this is not Anahita’s cup. It belongs to Haurvatat. Try again."
            cup2.cupnumber = 2
            cups.append(cup2)
            cups.shuffle()
        }

        if let cup3 = childNode(withName: "//cup3") as? Cupitem{
            cup3.originalPos = cup3.position
            cup3.explain = "His name means “most powerful demon.” He is a khrafstra, a demonic spirit allied with Angra Mainyu, the “angry spirit,” to destroy the faithful. He is depicted as a three-headed demon."
            cup3.choicetext = " Sorry, this is not Anahita’s cup. It belongs to Azi. Try again."
            cup3.cupnumber = 3
            
            cups.append(cup3)
            cups.shuffle()
        }

        if let cup4 = childNode(withName: "//cup4") as? Cupitem{
            cup4.originalPos = cup4.position
            cup4.explain = "She is an Iranian water goddess, called upon to gain prosperity and growth, as well as for other blessings. Libations were made in her honor. She is known to preside especially over rain and standing waters. "
            cup4.choicetext = "Sorry, this is not Anahita’s cup. It belongs to Ahurani. Try again."
            cup4.cupnumber = 4
            cups.append(cup4)
            cups.shuffle()
        }

        
       // cups = [cup1, cup2, cup3, cup4]
        
        particles = SKEmitterNode(fileNamed: "Pouring.sks")
        particles.isHidden = true
        addChild(particles)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0)])
        ))
        
        //animation
        let cupanimatealt = SKTextureAtlas(named: "cupimageanimate")
        var fillframe = [SKTexture]()
        
        //let numImages = cupanimatealt.textureNames.count
        for i in 1...4
        {
            let cuptexturename = "cupanimate\(i)"
            fillframe.append(cupanimatealt.textureNamed(cuptexturename))
        }
        
        
        winefull = fillframe
        
        let firstFrame = winefull[0]
        cupfill = SKSpriteNode(texture: firstFrame)
        //cupfill.position = cups[0].position
        cupfill.zPosition = 5
        cupfill.size.width = 80
        cupfill.size.height = 96
        //cupfill.position= 10
        cupfill.isHidden = true
        addChild(cupfill)
        
        // glow
        
        glowanimate1 = childNode(withName: "glow1") as! SKSpriteNode!
        glowanimate1.alpha = 0
        glowanimate1.isHidden = true
        shining(glownum: glowanimate1)

        
    }
    
    func fillthecup(place : CGPoint )
    {
        //This is our general runAction method to make our bear walk.
        cupfill.isHidden = false
        cupfill.position = place
        let fillcupaction = SKAction.repeat(
            SKAction.animate(with: winefull,
                             timePerFrame: 0.25,
                             resize: false,
                             restore: false),count : 1)
        
        cupfill.run(fillcupaction,completion:{
            self.particles.isHidden = true
            self.backlock = false
            cupfill.isHidden = true
        })

        
        //particles.isHidden = true
    }
    
    func shining(glownum : SKSpriteNode )
    {
        let fadeOut = SKAction.fadeIn(withDuration: 0.5)
        let fadeIn = SKAction.fadeOut(withDuration: 0.5)
        let pulse = SKAction.sequence([fadeOut, fadeIn])
        let pulseForever = SKAction.repeatForever(pulse)
        
        glownum.run(pulseForever)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch:UITouch = touches.first! as UITouch
        let location = touch.location(in: self)
        let ewer = childNode(withName: "ewer") as! SKSpriteNode
        let back = childNode(withName: "back") as! SKSpriteNode
        let next = childNode(withName: "nextarrow") as! SKSpriteNode
        let graytextbox = childNode(withName: "graybox1") as! SKSpriteNode
        
        let ewergraybox = childNode(withName: "grayboxewer") as! SKSpriteNode
        let cupgraybox = childNode(withName: "grayboxcup") as! SKSpriteNode
        let botgraybox = childNode(withName: "grayboxbot") as! SKSpriteNode
        let botgraybox2 = childNode(withName: "grayboxbot2") as! SKSpriteNode
        let botgraybox3 = childNode(withName: "grayboxbot3") as! SKSpriteNode
        let botgraybox4 = childNode(withName: "grayboxbot4") as! SKSpriteNode

        //botgraybox.isHidden = true
        
        
        if playAgainButton.contains(location) && !playlock
        {
            arrowfirstime = true
            startpickingcup = false
            ewermode = true
            paulse = false
            touchOK = true
            notmovetocup = true
            playlock = true
            backlock = true
            firstime = true
            
            botgraybox.isHidden = true
            ewergraybox.isHidden = true
            cupgraybox.isHidden = true
            playAgainButton.isHidden = true
            botgraybox2.isHidden = true
            botgraybox3.isHidden = true
            botgraybox4.isHidden = true
            opentext.isHidden = false
            graytextbox.isHidden = false
            next.isHidden = false
            
            opentext.text = "Welcome! You have arrived at the annual celebration honoring Anahita, one of the major Sasanian female deities. It is tradition to first pour a drink in her honor before starting the festivities."
            
            let moveEwerDown = SKAction.moveBy(x: -(ewer.position.x - back.position.x) + 110,
                                               y: -150,
                                               duration: 0.8)
            let rotationewer = SKAction.rotate(byAngle: 1, duration: 0.8)
            
            
            ewer.run(moveEwerDown)
            ewer.run(rotationewer,completion:{})
            
            description2.text = ""
            
            for cup in cups
            {
                cup.texture = SKTexture(imageNamed: "cup")
            }
            
            
            
        }
        
        if !paulse
        {
            
            if next.contains(location)
            {
                if arrowfirstime
                {
                    opentext.text = "Your job is to identify which cup belongs to Anahita. Read the description associated with each cup and pick the cup that matches her best!"
                    arrowfirstime = false
                }
                else
                {
                    opentext.isHidden = true
                    graytextbox.isHidden = true
                    next.isHidden = true
                    
                    ewergraybox.isHidden = false
                    cupgraybox.isHidden = false
                    ewerdescription.isHidden = false
                    cuptext.isHidden = false
                    
                    startpickingcup = true
                    
                    
                }
                
            }
            
            if startpickingcup
            {
                if ewermode {
                    print ("Touch was registered.")
                    
                    
                    //let cupdescription = childNode(withName: "cupdescription") as! SKLabelNode
                    for cup  in cups {
                        
                        print(cup.explain)
                        if cup.contains(location){
                            
                            if cup.cupnumber == 1
                            {
                                botgraybox3.isHidden = true
                                botgraybox.isHidden = false
                                botgraybox4.isHidden = true
                                
                            }
                            else if cup.cupnumber == 2
                            {
                                botgraybox3.isHidden = true
                                botgraybox.isHidden = true
                                botgraybox4.isHidden = false
                            }
                            else
                            {
                                botgraybox3.isHidden = false
                                botgraybox.isHidden = true
                                botgraybox4.isHidden = true
                            }

                            botgraybox2.isHidden = true

                            description2.text = cup.explain

                            cupgraybox.isHidden = true
                            cuptext.isHidden = true
                            glowanimate1.position = cup.position
                            glowanimate1.position.y = glowanimate1.position.y + 35
                            glowanimate1.isHidden = false

                        }
                    }
                    
                    
                    if ewer.contains(location){
                        
                        botgraybox2.isHidden =  false
                        botgraybox.isHidden = true
                        botgraybox3.isHidden = true
                        botgraybox4.isHidden = true
                        let moveEwerUp = SKAction.moveBy(x: 0.0,
                                                         y: 100,
                                                         duration: 0.8)
                        let rotationewer = SKAction.rotate(byAngle: -0.5, duration: 0.8)
                        
                        ewer.run(moveEwerUp)
                        ewer.run(rotationewer)
                        ewermode = false
                        backlock = false
                        
                        //description2.isHidden = true
                        description2.text = "Tap the cup that you believe belongs to Anahita."
                        ewergraybox.isHidden = true
                        glowanimate1.isHidden = true
                        ewerdescription.isHidden =  true
                        cupgraybox.isHidden = true
                        cuptext.isHidden = true
                        
                    }
                }
                else
                {
                    //var water = false
                    botgraybox2.isHidden =  false
                    
                    var cupx : CGFloat = 0.0
                    var cupy : CGFloat = 0.0
                    var ewerx : CGFloat = 0.0
                    //var ewery : CGFloat = 0.0
                    
                    //let cupdescription = childNode(withName: "cupdescription") as! SKLabelNode
                    
                    for cup  in cups {
                        if cup.contains(location){
                            
                            
                            
                            let moveEwerUp = SKAction.moveBy(x: cup.position.x - ewer.position.x - 50,
                                                             y: 50,
                                                             duration: 0.8)
                            let rotationewer = SKAction.rotate(byAngle: -0.5, duration: 0.8)
                            
                            
                            
                            cupx = cup.position.x
                            cupy = cup.position.y
                            
                            ewerx = cup.position.x - ewer.position.x - 50
                            //ewery = 50
                            if firstime
                            {
                                self.paulse = true
                                self.backlock = true
                                ewer.run(moveEwerUp)
                                ewer.run(rotationewer,completion:{
                                    self.particles.position.x = cupx - 70
                                    self.particles.position.y = cupy + 440
                                    self.particles.isHidden = false
                                    
                                    self.description2.text = cup.choicetext
                                    
                                    self.fillthecup(place : cup.position)
                                    cup.texture = SKTexture(imageNamed: "full")
                                    self.paulse = false
                                    
                                    if cup.correctcup
                                    {
                                        self.playAgainButton.isHidden = false
                                        self.playlock = false
                                        self.paulse = true
                                        
                                    }
                                })
                                firstime = false
                            }
                            else
                            {
                                self.particles.isHidden = true
                                self.paulse = true
                                self.backlock = true
                                let moveEwerside = SKAction.moveBy(x: cup.position.x - ewer.position.x - 50,
                                                                   y: 0,
                                                                   duration: 0.8)
                                ewer.run(moveEwerside,completion:{
                                    self.particles.position.x = cupx - 70
                                    self.particles.position.y = cupy + 440
                                    self.particles.isHidden = false
                                    self.description2.text = cup.choicetext
                                    self.fillthecup(place : cup.position)
                                    cup.texture = SKTexture(imageNamed: "full")
                                    self.paulse = false

                                    
                                     if cup.correctcup
                                     {
                                        self.playAgainButton.isHidden = false
                                        self.playlock = false
                                        self.paulse = true
                                        
                                     }
                                    
                                })
                            }
                            
                            notmovetocup = false
                            
                            //backlock = true
                            //water = true
                            
                            
                        }
                    }
                    
                    
                    if !backlock && back.contains(location)
                    {
                        
                        if notmovetocup
                        {
                            let moveEwerDown = SKAction.moveBy(x: -ewerx,
                                                               y: -100,
                                                               duration: 0.8)
                            let rotationewer = SKAction.rotate(byAngle: 0.5, duration: 0.8)
                            
                            
                            ewer.run(moveEwerDown)
                            ewer.run(rotationewer,completion:{})
                            
                            
                            notmovetocup = false
                        }
                        else
                        {
                            let moveEwerDown = SKAction.moveBy(x: -(ewer.position.x - back.position.x) + 110,
                                                               y: -150,
                                                               duration: 0.8)
                            let rotationewer = SKAction.rotate(byAngle: 1, duration: 0.8)
                            
                            
                            ewer.run(moveEwerDown)
                            ewer.run(rotationewer,completion:{})
                        }

                        ewermode = true
                        backlock = true
                        firstime = true
                        notmovetocup = true
                        
                        // SKAction
                    }
                    
                    
                }
            }
            

        }
        
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let cupdescription = childNode(withName: "cupdescription") as! SKLabelNode
        
        //cupdescription.text = ""

    }


}

class Cupitem : SKSpriteNode {
    var originalPos : CGPoint!
    
    var correctcup : Bool = false
    var explain : String = "I'm a cup"
    var choicetext : String = "I'm the cup"
    var shiningname : String = "I'm shining"
    var cupnumber : Int = 0
}



