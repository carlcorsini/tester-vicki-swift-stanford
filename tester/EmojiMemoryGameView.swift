//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by USER1 on 10/1/25.
//

// THIS IS THE VIEW FILE

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var deck: [String] = []
    
    private let aspectRation: CGFloat = 2/3
    private let spacing = CGFloat(1)
    
    var body: some View {
        VStack {
            // .themeName called the specific game color
            Text(viewModel.themeName)
                .font(.largeTitle).bold()
                .padding(.top, 4)
            
            // Grid
            ScrollView {
                cards
//                    .animation(.default, value: viewModel.cards)
            }
            
            // Footer controls
            HStack {
                // calls the newGame() method
                Button("New Game") { viewModel.newGame() }
                Spacer()
                // calls the score method logic
                Text("Score: \(viewModel.score)")
                    .font(.headline).animation(nil)
                Spacer()
                // uses teh shuffle method like from lec 5
                Button("Shuffle") { viewModel.shuffle() }
            }
            .padding(.vertical, 8)
        }
        .padding()
    }
    
    
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            // loops each amoji in the deck
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.themeColor)
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        return 0
    }
}

// testing new push

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
