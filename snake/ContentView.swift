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
    var position = CGPoint(x: 0, y: 0)
    var direction: Direction = .down
    private let maxHeight = UIScreen.main.bounds.height
    private let maxWidth = UIScreen.main.bounds.width
    
    func move(inDirection: Direction) {
        let duration = ((inDirection == .down) || (inDirection == .up)) ? maxHeight / 60 : maxWidth / 60
        withAnimation(.linear(duration: duration)) {
            switch inDirection {
                case .right:
                    print("right direction")
                    self.position.x = maxWidth
                    break
                case .left:
                    print("left direction")
                    self.position.x = 0
                    break
                case .up:
                print("up direction")
                    self.position.y = 0
                    break
                case .down:
                print("down direction")
                    self.position.y = maxHeight
                    break
            }
        }
    }
}

struct ContentView: View {
    
    private let maxHeight = UIScreen.main.bounds.height

    @State var snake = Snake()
    @State var direction: Direction = .down
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.indigo)
                .frame(width: snake.width, height: snake.height).position(snake.position)
        }
        .background(Color.white)
        .onAppear {
            snake.move(inDirection: direction)
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
                        print("right")
                    } else {
                        snake.move(inDirection: .left)
                        print("left")
                    }
                } else {
                    // Vertical swipe
                    if verticalDistance > 0  {
                        snake.move(inDirection: .down)
                        print("down")
                    } else  {
                        snake.move(inDirection: .up)
                        print("up")
                    }
                }
            })
    }
}

#Preview {
    ContentView()
}
