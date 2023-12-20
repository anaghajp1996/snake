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

let width = 20


@Observable class Snake {
    var width: CGFloat = 20;
    var height: CGFloat  = 20;
    var position = CGPoint(x: 20, y: 20)
    var direction: Direction = .down
    var showGameOverAlert = false
    private let maxHeight = UIScreen.main.bounds.height
    private let maxWidth = UIScreen.main.bounds.width
    private var timer: Timer?
    
    
    func startSnake(inDirection: Direction) {
        let duration = ((inDirection == .down) || (inDirection == .up)) ? maxHeight / 60 : maxWidth / 60
        self.direction = inDirection
        timer = Timer.scheduledTimer(withTimeInterval: duration / 100, repeats: true) { _ in
            print("Snake first x value: \(self.position.x)")
            print("Snake first y value: \(self.position.y)")
            self.move(inDirection: self.direction)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func gameOver() {
        timer?.invalidate()
        self.position = CGPoint(x: width, y: width)
        self.showGameOverAlert = true
    }
    
    func move(inDirection: Direction) {
        if self.position.x >= maxWidth || self.position.y >= maxHeight || self.position.x <= 0 || self.position.y <= 0 {
            gameOver()
        } else {
            switch inDirection {
                case .right:
                    self.direction = .right
                self.position.x += width
                    break
                case .left:
                    self.direction = .left
                    self.position.x -= width
                    break
                case .up:
                    self.direction = .up
                    self.position.y -= width
                    break
                case .down:
                    self.direction = .down
                    self.position.y += width
                    break
                }
        }
    }
}

@Observable class Food {
    var width: CGFloat = 20
    var height: CGFloat  = 20
    var position = CGPoint()
    let color = Color.white
    private let maxHeight = UIScreen.main.bounds.height
    private let maxWidth = UIScreen.main.bounds.width
    
    func setFoodPosition() {
        self.position.x = Array(stride(from: 0, to: maxWidth, by: self.height)).randomElement() ?? 0
        self.position.y = Array(stride(from: 0, to: maxHeight, by: self.height)).randomElement() ?? 0
    }
}

struct ContentView: View {
    
    private let maxHeight = UIScreen.main.bounds.height

    @State var snake = Snake()
    @State var direction: Direction = .down
    
    @State var food = Food()
    
    let backgroundColor = Color.init(red: 159/255, green: 189/255, blue: 141/255)
    
    let snakeColor = Color.init(red: 60/255, green: 58/255, blue: 42/255)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(food.color)
                .frame(width: food.width, height: food.height).position(food.position)
            Rectangle()
                .fill(snakeColor)
                .frame(width: snake.width, height: snake.height).position(snake.position)
        }
        .background(backgroundColor)
        .onAppear {
            resetValues()
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
                resetValues()
            }
            
        }
    }
    
    private func resetValues() {
        snake.startSnake(inDirection: .down, food: food)
        food.setFoodPosition()
    }
}

#Preview {
    ContentView()
}
