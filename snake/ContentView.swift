//
//  ContentView.swift
//  snake
//
//  Created by Anagha K J on 22/11/23.
//

import SwiftUI

enum Direction {
    case right, left, up, down
}

@Observable class Snake {
    var width: CGFloat = 20;
    var height: CGFloat  = 20;
    var position = CGPoint(x: 10, y: 10)
    var direction: Direction = .down
    var showGameOverAlert = false
    private let maxHeight = UIScreen.main.bounds.height
    private let maxWidth = UIScreen.main.bounds.width
    private var timer: Timer?
    
    
    func startSnake(inDirection: Direction) {
        let duration = ((inDirection == .down) || (inDirection == .up)) ? maxHeight / 60 : maxWidth / 60
        print(duration)
        self.direction = inDirection
        timer = Timer.scheduledTimer(withTimeInterval: duration / 1000, repeats: true) { _ in
            self.move(inDirection: self.direction)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func gameOver() {
        print("GAME OVERRRRR!!!!!!!!!!!")
        timer?.invalidate()
        self.showGameOverAlert = true
    }
    
    func move(inDirection: Direction) {
        if self.position.x == maxWidth || self.position.y == maxHeight || self.position.x == 0 || self.position.y == 0 {
            gameOver()
        } else {
            switch inDirection {
                case .right:
                    self.direction = .right
                    self.position.x += 1
                    break
                case .left:
                    self.direction = .left
                    self.position.x -= 1
                    break
                case .up:
                    self.direction = .up
                    self.position.y -= 1
                    break
                case .down:
                    self.direction = .down
                    self.position.y += 1
                    break
                }
        }
    }
}

struct ContentView: View {
    
    private let maxHeight = UIScreen.main.bounds.height

    @State var snake = Snake()
    @State var direction: Direction = .down
    
    let backgroundColor = Color.init(red: 128/255, green: 171/255, blue: 100/255)
    
    let snakeColor = Color.init(red: 60/255, green: 58/255, blue: 42/255)
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(snakeColor)
                .frame(width: snake.width, height: snake.height).position(snake.position)
        }
        .background(backgroundColor)
        .onAppear {
            snake.startSnake(inDirection: .down)
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onEnded { value in
                let start = value.startLocation
                let end = value.location
                            
                let horizontalDistance = end.x - start.x
                let verticalDistance = end.y - start.y
                
                if abs(horizontalDistance) > abs(verticalDistance) {
                    // Horizontal swipe
                    if horizontalDistance > 0 {
                        snake.move(inDirection: .right)
                    } else {
                        snake.move(inDirection: .left)
                    }
                } else {
                    // Vertical swipe
                    if verticalDistance > 0  {
                        snake.move(inDirection: .down)
                    } else  {
                        snake.move(inDirection: .up)
                    }
                }
            })
        .alert(Text("Game Over! Oopssss...sss..ss"), isPresented: $snake.showGameOverAlert) {
            Button("Start Over", role: .cancel) {
                snake.showGameOverAlert = false
                snake.position = CGPoint(x: 10, y: 10)
                snake.startSnake(inDirection: .down)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
