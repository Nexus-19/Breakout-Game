//
//  ContentView.swift
//  Breakout Game
//
//  Created by Soumyattam Dey on 04/01/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @AppStorage("bestScore") var bestScore=0
    @StateObject private var gameScene=GameScene()
    
    var body: some View {
        ZStack{
            SpriteView(scene: gameScene)
            
            VStack(alignment:.leading){
                Text("Level : \(gameScene.level)")
                    .font(.system(size: 12,weight:.heavy,design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.top,42)
                
                Text("Score: \(gameScene.score)")
                    .font(.system(size: 24,weight:.heavy,design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
                
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            
            if gameScene.isGameOver{
                VStack{
                    Text("Game Over")
                        .font(.system(size: 42,weight:.heavy,design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    if gameScene.score>bestScore{
                        Text("New Best Score!!!")
                            .font(.system(size: 42,weight:.heavy,design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading)
                        Text("\(gameScene.score)")
                            .font(.system(size: 42,weight:.heavy,design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading)
                    }
                    
                    Text("Play Again")
                        .font(.system(size: 24,weight:.heavy,design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding()
                        .onTapGesture {
                            if gameScene.score>bestScore{
                                bestScore=gameScene.score
                            }
                            gameScene.isGameOver.toggle()
                            gameScene.makeBall()
                            gameScene.makeBricks()
                            gameScene.score=0
                        }
                    
                }
                
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
