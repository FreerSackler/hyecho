//
//  MaraGameScene.swift
//  Hyechos Journey
//
//  Created by Bailey Case on 5/25/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import SpriteKit
import UIKit


let path1 : [CGPoint] = [CGPoint(x:-260,y:250), CGPoint(x:100,y:250), CGPoint(x:115,y:-134)]
let path2 : [CGPoint] = [CGPoint(x:-260,y:201), CGPoint(x:40,y:201), CGPoint(x:-100,y:-40), CGPoint(x:80,y:-170)]
let path3 : [CGPoint] = [CGPoint(x:-260,y:20), CGPoint(x:45,y:230), CGPoint(x:115,y:-134)]
let path4 : [CGPoint] = [CGPoint(x:-260,y:0), CGPoint(x:-125,y:125), CGPoint(x:-85,y:-250), CGPoint(x:30,y:-250)]
let path5 : [CGPoint] = [CGPoint(x:-260,y:-215), CGPoint(x:60,y:-215)]

let paths : [[CGPoint]] = [path1,path2,path3,path4,path5]

class MaraGameScene: SKScene {
    
    //parent for all enemies. Main use is so that we can pause/clear at level transitions
    var maraArmy: SKNode!
    var gameManager: GameManager!
    var particles: SKEmitterNode!
    var isAnimating: Bool = false
    var lifeNodes : [SKEmitterNode]!

    //called once?
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        
        gameManager = GameManager(parent:self)
        maraArmy = SKNode()
        lifeNodes = []
        particles = SKEmitterNode(fileNamed: "LeafParticle.sks")
        
        addChild(particles)
        addChild(gameManager)
        addChild(maraArmy)
        
        SetLifeNodes()
        
        particles.position = CGPoint(x:1000, y:1000)
        
        isUserInteractionEnabled = true
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(Update),
                SKAction.wait(forDuration: 1.0)])
        ))
    }
    
    func SetLifeNodes(){
        let temp : SKNode = childNode(withName: "LifeNodeParent")!
        for node in temp.children {
            if let tempEmitter = SKEmitterNode(fileNamed: "GlowingGold.sks") {
                tempEmitter.position = node.position
                temp.addChild(tempEmitter)
                lifeNodes.append(tempEmitter)
            }
        }
    }
    
    func ChangeLifeNodes(health: Int){
        var temp = health
        for node in lifeNodes {
            node.isHidden = true
            if temp > 0 {
                node.isHidden = false
            }
            temp = temp-1
        }
    }
    
    func Update(){
        if gameManager.cutscenePlaying{
            return
        }
        switch gameManager.level {
        case 0:
            Level0()
            break
        case 1:
            Level1()
            break
        case 2:
            Level2()
            break
        case 3:
            Level3()
            break
        //these represent "cutscenes" for each level
        case 6:
            LevelDead()
        case 10:
            Level1Cutscene()
            break
        case 20:
            Level2Cutscene()
            break
        case 30:
            Level3Cutscene()
            break
        case 40:
            GameComplete()
            break
        case 66:
            LevelDead()
        default:
            print("ERROR! level is not one of its restricted values")
        }
    }
    
    func Level0(){
        gameManager.startreset.isHidden = false
        gameManager.startresetText.text = "You protected the Buddha! You stopped 100 of Mara's minions."
        gameManager.startresetButton.texture = SKTexture(imageNamed: "PlayAgain.png")
        gameManager.startresetB = true
    }
    
    func Level1(){
        addMonster()
    }
    
    func Level2(){
        addMonster()
        addMonster()
    }
    
    func Level3(){
        addMonster()
        addMonster()
        addMonster()
    }
    
    func Level1Cutscene(){
        gameManager.health = 5
        isAnimating = false
        RemoveAllArmy()
        gameManager.level = 1
        gameManager.cutscene(text: "The prince has sat under the Bodhi tree determined to become the Buddha. This cannot happen. My servants, attack him at once!")
    }
    
    func Level2Cutscene(){
        gameManager.health = 5
        isAnimating = false
        RemoveAllArmy()
        gameManager.level = 2
        gameManager.cutscene(text: "He seems unaffected by our attacks… Do not relent!")
    }
    
    func Level3Cutscene(){
        gameManager.health = 5
        isAnimating = false
        RemoveAllArmy()
        gameManager.level = 3
        gameManager.cutscene(text: "We must not allow him to succeed! I can no longer tempt beings with desire if he becomes the Buddha. Keep attacking!")
    }
    
    func GameComplete(){
        isAnimating = false
        RemoveAllArmy()
        gameManager.enemiesStopped = 0
        gameManager.level = 40
        gameManager.cutscene(text: "Nooo, he has repelled my attacks… I am defeated")
    }
    
    func LevelDead(){
        gameManager.startreset.isHidden = false
        gameManager.enemiesStopped = 0
        gameManager.startresetText.text = "You have been overwhelmed by Mara and his minions, forcing the prince get up and leave."
        gameManager.startresetButton.texture = SKTexture(imageNamed: "TryAgain.png")
        gameManager.startresetB = true
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //utility function to empty the screen
    func RemoveAllArmy(){
        for toDie in maraArmy.children{
            toDie.removeFromParent()
        }
    }
    
    
    func addMonster() {
        
        // Create sprite
        let monster = MaraArmy(sender: self)
        monster.isUserInteractionEnabled = true
        
        let randomPath : Int = Int(random(min: 0, max: 500)) % 5
        
        monster.position = paths[randomPath][0]
        monster.xScale = 0.4
        monster.yScale = 0.4
        monster.zPosition = 3
        // Add the monster to the scene
        maraArmy.addChild(monster)
        
        //make a series of actions for the movemnet
        var pathAction : [SKAction] = []
        for point in paths[randomPath]{
            if point == paths[randomPath].first {
                //do nothing
            } else {
                pathAction.append(SKAction.move(to: point, duration: TimeInterval(8 / paths[randomPath].count )))
            }
        }
        
        //need an action for hitting the buddha!
        let buddhaHit = SKAction.run {self.TakeDamage()}
        
        //delete this character
        let actionMoveDone = SKAction.removeFromParent()
        
        //run all previous actions
        monster.run(SKAction.sequence([
            SKAction.sequence(pathAction),
            buddhaHit,
            actionMoveDone]))
        
    }
    
    //increments score and plays animation
    func EnemyClicked(location:CGPoint){
        isAnimating = true
        gameManager.enemiesStopped = gameManager.enemiesStopped+1
        particles.position = location
        particles.resetSimulation()
    }
    
    func TakeDamage(){
        gameManager.health = gameManager.health-1
        if gameManager.health <= 0 {
            LevelDead()
        }
    }
}

//interacting with view 
class GameManager : SKNode {
    
    var maraLabel : SKMultilineLabel
    var dumbyMaraLabel : SKLabelNode
    var maraLabelBackground : SKSpriteNode
    var maraImage : SKSpriteNode
    var nextButton : SKSpriteNode
    var startreset : SKNode
    var dumbystartresetText : SKLabelNode
    var startresetText : SKMultilineLabel
    var startresetButton : SKSpriteNode

    var myParent : MaraGameScene
    
    //controls cutscenes mode
    var cutscenePlaying = false
    
    //controls being in start or reset screen
    var startresetB : Bool = true

    var level = 0

    //when this is set to specific level end amounts, que next cutscene
    var enemiesStopped: Int = 0{
        didSet {
            if (enemiesStopped == 20){
                level = 20
            } else if (enemiesStopped == 50){
                level = 30
            } else if (enemiesStopped == 100){
                level = 40
            }
        }
    }
    
    var health = 5 {
        didSet{
            myParent.ChangeLifeNodes(health: health)
        }
    }
    
    init(parent: SKScene){
        dumbyMaraLabel = parent.childNode(withName: "MaraLabel") as! SKLabelNode
        maraLabelBackground = parent.childNode(withName: "MaraLabelBackground") as! SKSpriteNode
        maraImage = parent.childNode(withName:"MaraImage") as! SKSpriteNode
        nextButton = parent.childNode(withName: "NextButton") as! SKSpriteNode
        maraLabel = SKMultilineLabel(text: "", labelWidth: 240, pos: dumbyMaraLabel.position, fontName: dumbyMaraLabel.fontName!, fontSize: dumbyMaraLabel.fontSize, fontColor: dumbyMaraLabel.fontColor!, leading: nil, alignment: .left, shouldShowBorder: false)
        maraLabel.zPosition = 5
        startreset = parent.childNode(withName: "startreset")!
        dumbystartresetText = startreset.childNode(withName: "startresetText") as! SKLabelNode
        startresetText = SKMultilineLabel(text: "Mara has sent his army to stop Prince Siddhartha from attaining enlightenment and becoming the Buddha! Tap the attackers to turn them into flowers before they reach the prince!", labelWidth: 270, pos: dumbystartresetText.position, fontName: dumbystartresetText.fontName!, fontSize: dumbystartresetText.fontSize, fontColor: dumbystartresetText.fontColor!, leading: nil, alignment: .center, shouldShowBorder: false)
        startresetText.zPosition = 5
        startreset.addChild(startresetText)
        startresetButton = startreset.childNode(withName: "startresetButton") as! SKSpriteNode
        
        myParent = parent as! MaraGameScene
        super.init()
        
        dumbystartresetText.removeFromParent()
        dumbyMaraLabel.removeFromParent()

        maraLabel.removeFromParent()
        self.addChild(maraLabel)
        maraLabelBackground.removeFromParent()
        self.addChild(maraLabelBackground)
        maraImage.removeFromParent()
        self.addChild(maraImage)
        nextButton.removeFromParent()
        self.addChild(nextButton)
        startreset.removeFromParent()
        self.addChild(startreset)
        
        //fixes problems down the road
        maraImage.xScale = maraImage.xScale
        maraImage.yScale = maraImage.yScale
        maraImage.isHidden = true
        
        nextButton.isHidden = true
        maraLabel.isHidden = true
        maraLabelBackground.isHidden = true
        cutscenePlaying = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cutscene(text:String){
        cutscenePlaying = true
        nextButton.isHidden = false
        maraLabel.isHidden = false
        maraLabelBackground.isHidden = false
        if level == 40 {
            maraImage.texture = SKTexture(imageNamed:"mara3")
        } else if level == 66{
            maraImage.texture = SKTexture(imageNamed:"mara1")
        } else {
            maraImage.texture = SKTexture(imageNamed:"mara\(level)")
        }
        maraImage.isHidden = false
        maraLabel.text = text
    }
    
    func resetLevel(){

    }
    
    //override so we can tell if next button has been pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positioxnInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positioxnInScene)
        
        if startresetB && (touchedNode.name == startresetButton.name) {
            level = 10
            startreset.isHidden = true
            cutscenePlaying = false
            health = 5
        }
        
        if touchedNode.name == nextButton.name{
            cutscenePlaying = false
            nextButton.isHidden = true
            maraLabel.isHidden = true
            maraLabelBackground.isHidden = true
            maraImage.isHidden = true
            if level == 40 {
                level = 0
            } else if level == 66 {
                level = 6
            }
        }
    }
}

//represents the army attacking
class MaraArmy: SKSpriteNode {

    
    //get a reference to game scene
    var gameScene : MaraGameScene
    init(sender: MaraGameScene){
        gameScene = sender
        let imageNum = (Int(arc4random()) % 16) + 1
        let texture = SKTexture(imageNamed: "maraarmy\(imageNum)")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        //adjust to make smaller or bigger
        self.xScale = 1
        self.yScale = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //override so we can delete on touch, also increments enemiesStopped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        gameScene.EnemyClicked(location: touch.location(in: gameScene))
        self.removeFromParent()
    }
}
