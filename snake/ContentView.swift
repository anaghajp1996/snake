//
//  ContentView.swift
//  snake
//
//  Created by Anagha K J on 22/11/23.
//

import SwiftUI

enum Direction {
    case right
    case left
    case up
    case down
}

@Observable class Snake {
    var width: CGFloat = 10;
    var height: CGFloat  = 10;
    var position = CGPoint(x: 0, y: 0)
    var direction: Direction = .down
    private let maxHeight = UIScreen.main.bounds.height
    private let maxWidth = UIScreen.main.bounds.width
    
    func moveSnake(inDirection: Direction) {
        withAnimation(.linear(duration: 3)) {
            switch inDirection {
                case .right:
                    self.position.x = maxWidth
                    break
                case .left:
                    self.position.x = 0
                    break
                case .up:
                    self.position.y = 0
                    break
                case .down:
                    self.position.y = maxHeight
                    break
            }
        }
    }
}

struct ContentView: View {
    
    private let maxHeight = UIScreen.main.bounds.height

    @State var snake = Snake()
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.teal)
                .frame(width: snake.width, height: snake.height).position(snake.position)
        }.onAppear {
            snake.moveSnake(inDirection: .right)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
