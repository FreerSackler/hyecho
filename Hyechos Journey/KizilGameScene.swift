//
//  MedicineBuddhaGameScene.swift
//  Hyechos Journey
//
//  Created by Bailey Case on 6/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import SpriteKit

class KizilGameScene : SKScene {
    
    weak var monk : KizilItem! = KizilItem()
    weak var lady : KizilItem! = KizilItem()
    weak var homage : KizilItem! = KizilItem()
    weak var diety : KizilItem! = KizilItem()
    weak var blue : KizilItem! = KizilItem()
    weak var woman : KizilItem! = KizilItem()
    
    weak var monkDummy : KizilItem! = KizilItem()
    weak var ladyDummy : KizilItem! = KizilItem()
    weak var homageDummy : KizilItem! = KizilItem()
    weak var dietyDummy : KizilItem! = KizilItem()
    weak var blueDummy : KizilItem! = KizilItem()
    weak var womanDummy : KizilItem! = KizilItem()
    weak var puzzle : SKSpriteNode! = SKSpriteNode()
    
    weak var viewController : KizilViewController!
    var playAgainButton: UIButton!
    var items : [KizilItem]!
    var gamePaused : Bool = false
    
    //called onceat start
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        isUserInteractionEnabled = true
        
        setupPlayAgainButton()
        
        //Set up puzzle pieces
        monk = childNode(withName: "monk") as! KizilItem
        lady = childNode(withName: "lady") as! KizilItem
        homage = childNode(withName: "homage") as! KizilItem
        diety = childNode(withName: "diety") as! KizilItem
        woman = childNode(withName: "woman") as! KizilItem
        blue = childNode(withName: "blue") as! KizilItem
        
        //dummy sprites to get the position
        monkDummy = childNode(withName: "monk_dummy") as! KizilItem
        ladyDummy = childNode(withName: "lady_dummy") as! KizilItem
        homageDummy = childNode(withName: "homage_dummy") as! KizilItem
        dietyDummy = childNode(withName: "diety_dummy") as! KizilItem
        womanDummy = childNode(withName: "woman_dummy") as! KizilItem
        blueDummy = childNode(withName: "blue_dummy") as! KizilItem
        
        puzzle = childNode(withName: "puzzle") as! SKSpriteNode
  
        var posArray = [monk.position, homage.position, lady.position, diety.position, woman.position, blue.position]
        posArray.shuffle()
        monk.position = posArray[0]
        homage.position = posArray[1]
        lady.position = posArray[2]
        diety.position = posArray[3]
        woman.position = posArray[4]
        blue.position = posArray[5]
        
        
        //This modifier is to make the boxes needed to put the puzzle piece in 
        //before it snaps smaller
        let positionModifier = 33.0
        
        //Set position needed for the puzzle pieces
        var position = monkDummy.position
        var size = monkDummy.size
        monk.originalPos = monk.position
        monk.dummy = monkDummy
        monk.piece = "monk"
        monk.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                            tempXMax: Double(position.x + size.width/2) - positionModifier,
                            tempYMin: Double(position.y - size.height/2) + positionModifier,
                            tempYMax: Double(position.y + size.height/2) - positionModifier,
                            tempXPos: Double(position.x), tempYPos: Double(position.y))
        
        position = ladyDummy.position
        size = ladyDummy.size
        lady.originalPos = lady.position
        lady.dummy = ladyDummy
        lady.piece = "lady"
        lady.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                                tempXMax: Double(position.x + size.width/2) - positionModifier,
                                tempYMin: Double(position.y - size.height/2) + positionModifier,
                                tempYMax: Double(position.y + size.height/2) - positionModifier,
                                tempXPos: Double(position.x), tempYPos: Double(position.y))
        
        position = homageDummy.position
        size = homageDummy.size
        homage.originalPos = homage.position
        homage.dummy = homageDummy
        homage.piece = "homage"
        homage.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                         tempXMax: Double(position.x + size.width/2) - positionModifier,
                         tempYMin: Double(position.y - size.height/2) + positionModifier,
                         tempYMax: Double(position.y + size.height/2) - positionModifier,
                         tempXPos: Double(position.x), tempYPos: Double(position.y))

        position = dietyDummy.position
        size = dietyDummy.size
        diety.originalPos = diety.position
        diety.dummy = dietyDummy
        diety.piece = "diety"
        diety.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                         tempXMax: Double(position.x + size.width/2) - positionModifier,
                         tempYMin: Double(position.y - size.height/2) + positionModifier,
                         tempYMax: Double(position.y + size.height/2) - positionModifier,
                         tempXPos: Double(position.x), tempYPos: Double(position.y))
        
        position = womanDummy.position
        size = womanDummy.size
        woman.originalPos = woman.position
        woman.dummy = womanDummy
        woman.piece = "woman"
        woman.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                         tempXMax: Double(position.x + size.width/2) - positionModifier,
                         tempYMin: Double(position.y - size.height/2) + positionModifier,
                         tempYMax: Double(position.y + size.height/2) - positionModifier,
                         tempXPos: Double(position.x), tempYPos: Double(position.y))
        
        position = blueDummy.position
        size = blueDummy.size
        blue.originalPos = blue.position
        blue.dummy = blueDummy
        blue.piece = "blue"
        blue.setNumbers(tempXMin: Double(position.x - size.width/2) + positionModifier,
                         tempXMax: Double(position.x + size.width/2) - positionModifier,
                         tempYMin: Double(position.y - size.height/2) + positionModifier,
                         tempYMax: Double(position.y + size.height/2) - positionModifier,
                         tempXPos: Double(position.x), tempYPos: Double(position.y))
        
        items = [monk, lady, homage, diety, woman, blue]
 
        _ = Timer.scheduledTimer(
            timeInterval: 1.0, target: self, selector: #selector(addPlay),
            userInfo: nil, repeats: true)
    }
    
    var dragging: Bool = false
    var draggedItem : KizilItem!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (self.isPaused) {
            return
        }
        let touch:UITouch = touches.first! as UITouch
        let location = touch.location(in: self)
        for item  in items {
            if item.contains(location) && !item.inPosition{
                draggedItem = item
                draggedItem.zPosition = 2
                dragging = true
            
            }
            else if item.contains(location) && item.inPosition{
                viewController.puzzlePiece = item.piece
                viewController.showPopup()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if dragging{
            let touch:UITouch = touches.first! as UITouch
            let location = touch.location(in: self)
            draggedItem.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (draggedItem == nil) {
            return
        }
        
        let x = draggedItem.position.x
        let y = draggedItem.position.y
        
        //This will let it scale to whatever phone screen
        if (Double(x) > draggedItem.xMin && Double(x) < draggedItem.xMax
            && Double(y) > draggedItem.yMin && Double(y) < draggedItem.yMax) {
            
            let newPosition = CGPoint(x: draggedItem.xPos, y: draggedItem.yPos)
           
            draggedItem.inPosition = true
            draggedItem.position = newPosition
            draggedItem.zPosition = -1
            draggedItem.dummy?.zPosition = 1
            
          
            //Needed so the glow shows then the popup shows
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                print(self.draggedItem)
                print(self.draggedItem.piece)
                self.viewController.puzzlePiece = self.draggedItem.piece
                self.draggedItem = nil
                self.viewController.showPopup()
            })

        
        }
        else {
            if (!draggedItem.inPosition) {
                draggedItem.position = draggedItem.originalPos
            }
        }
        
        dragging = false
        
    }
    func addPlay() {
        
        var allInPosition = true
        for item in items {
            print(item.inPosition)
            if item.inPosition == false {
                allInPosition = false
            }
        }
        
        if allInPosition {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                if self.viewController.popupView.isHidden == true {
                    self.addPlayAgainButton()
                }
            })
        }
    }
    
    fileprivate func setupPlayAgainButton() {
        playAgainButton = UIButton(type: .custom)
        playAgainButton.frame = CGRect(
            x: ((view?.frame.width)! - 286) / 2,
            y: (view?.frame.height)! / 2 - 45,
            width: 286,
            height: 90
        )
        playAgainButton.setBackgroundImage(#imageLiteral(resourceName: "PlayAgain"), for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        
        self.gamePaused = true
    }
    
    func playAgain() {
        removePlayAgainButton()
        self.gamePaused = false
        for item in items {
            item.position = item.originalPos
            item.inPosition = false
            item.dummy?.zPosition = -1
            item.zPosition = 1
        }
        
    }
    
    fileprivate func addPlayAgainButton() {
        if playAgainButton.superview == nil {
            view?.addSubview(playAgainButton)
            view?.bringSubview(toFront: playAgainButton)
        }
    }
    
    fileprivate func removePlayAgainButton() {
        playAgainButton.removeFromSuperview()
    }
    
}

class KizilItem : SKSpriteNode{
    var originalPos : CGPoint!
    var inPosition : Bool = false
    var xMin : Double = 0.0
    var xMax : Double = 0.0
    var yMin : Double = 0.0
    var yMax : Double = 0.0
    var xPos : Double = 0.0
    var yPos : Double = 0.0
    var dummy : KizilItem? = nil
    var piece : String = "empty"
    
    func setNumbers(tempXMin : Double, tempXMax : Double, tempYMin : Double, tempYMax : Double,
                    tempXPos : Double, tempYPos : Double ) {
        
        xMin = tempXMin
        xMax = tempXMax
        yMin = tempYMin
        yMax = tempYMax
        xPos = tempXPos
        yPos = tempYPos
        
    }
}
