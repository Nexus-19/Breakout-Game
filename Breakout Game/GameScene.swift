//
//  GameScene.swift
//  Breakout Game
//
//  Created by Soumyattam Dey on 04/01/22.
//

import SpriteKit

class GameScene:SKScene,SKPhysicsContactDelegate,ObservableObject{
    
    @Published var score=0
    @Published var isGameOver=false
    @Published var level=1
    
    //Sprites
    let ball=SKShapeNode(circleOfRadius: CGFloat(12))
    let paddle=SKSpriteNode(color: SKColor(.white), size: CGSize(width: 120, height: 16))
    let floor=SKSpriteNode(color: SKColor(.clear), size: CGSize(width: UIScreen.main.bounds.width, height: 20))
    
    override func didMove(to view: SKView) {
        self.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        scene?.scaleMode = .fill
        backgroundColor = .black
        
        let border=SKPhysicsBody(edgeLoopFrom: frame)
        border.friction=0
        physicsBody=border
        
        physicsWorld.gravity=CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate=self
        
        makeBall()
        makePaddle()
        makeBricks()
        makeFloor()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return  }
        let location=touch.location(in: self)
        paddle.position=CGPoint(x: location.x, y: 40)
    }
    
    func makeBall(){
        ball.name="ball"
        ball.fillColor = .white
        ball.position=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
        ball.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 24))
        ball.physicsBody!.allowsRotation=false
        ball.physicsBody!.friction=0
        ball.physicsBody!.restitution=1
        ball.physicsBody!.linearDamping=0
        ball.physicsBody!.contactTestBitMask=ball.physicsBody!.collisionBitMask
        addChild(ball)
        
        ball.physicsBody!.applyImpulse(CGVector(dx: 8, dy: -8))
        
    }
    
    func makePaddle(){
        paddle.name="paddle"
        paddle.position=CGPoint(x: UIScreen.main.bounds.width/2, y: 40)
        paddle.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 24))
        paddle.physicsBody!.allowsRotation=false
        paddle.physicsBody!.friction=0
        paddle.physicsBody!.restitution=1
        paddle.physicsBody!.isDynamic=false
        paddle.physicsBody!.contactTestBitMask=paddle.physicsBody!.collisionBitMask
        addChild(paddle)
    }
    
    func makeBricks(){
        let rows=[
            Rows(color: .red, positionY: UIScreen.main.bounds.height/1.14),
            Rows(color: .red, positionY: UIScreen.main.bounds.height/1.17),
            Rows(color: .orange, positionY: UIScreen.main.bounds.height/1.202),
            Rows(color: .orange, positionY: UIScreen.main.bounds.height/1.235),
            Rows(color: .green, positionY: UIScreen.main.bounds.height/1.272),
            Rows(color: .green, positionY: UIScreen.main.bounds.height/1.310),
            Rows(color: .yellow, positionY: UIScreen.main.bounds.height/1.350),
            Rows(color: .yellow, positionY: UIScreen.main.bounds.height/1.392)
        ]
        
        rows.forEach{
            makeRows(color: $0.color, positionY: $0.positionY)
        }
    }
    
    func makeRows(color:UIColor,positionY:CGFloat){
        let numberOfBricks=10
        let brickWidth:CGFloat=40
        let brickHeight:CGFloat=16
        let totalBrickWidth=brickWidth * CGFloat(numberOfBricks)
        let xoffSet=(frame.width-totalBrickWidth)/2
        
        for index in 0..<numberOfBricks{
            let brick=SKSpriteNode(color: color, size: CGSize(width: 36, height: brickHeight))
            brick.name="brick"
            brick.position=CGPoint(x: xoffSet+CGFloat(CGFloat(index)+0.5)*brickWidth, y: positionY)
            brick.physicsBody=SKPhysicsBody(rectangleOf: brick.frame.size)
            brick.physicsBody!.allowsRotation=false
            brick.physicsBody!.friction=0
            brick.physicsBody!.isDynamic=false
            addChild(brick)
        }
    }
    
    func makeFloor(){
        floor.name="floor"
        floor.position=CGPoint(x: UIScreen.main.bounds.width/2, y: 12)
        floor.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width, height: 24))
        floor.physicsBody!.allowsRotation=false
        floor.physicsBody!.isDynamic=false
        floor.physicsBody!.contactTestBitMask=floor.physicsBody!.collisionBitMask
        addChild(floor)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name=="ball" && contact.bodyB.node?.name=="brick"{
            remodeBrickFromParent(contact.bodyB.node!)
            updateScore(1)
            
            if children.count<=3{
                ball.removeFromParent()
                level+=1
                
                makeBall()
                makeBricks()
            }
        }
        
        if contact.bodyA.node?.name=="ball" && contact.bodyB.node?.name=="floor"{
            ball.removeFromParent()
            isGameOver.toggle()
        }
    }
    
    func remodeBrickFromParent(_ node:SKNode){
        node.removeFromParent()
    }
    
    func updateScore(_ newScore:Int){
        score+=newScore
    }
}

struct Rows{
    let color:UIColor
    let positionY:CGFloat
}
