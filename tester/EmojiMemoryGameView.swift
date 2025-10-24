//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by USER1 on 10/1/25.
//

// THIS IS THE VIEW FILE

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var deck: [String] = []
    
    var body: some View {
        VStack {
            // .themeName called the specific game color
            Text(viewModel.themeName)
                .font(.largeTitle).bold()
                .padding(.top, 4)

            // Grid
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }

            // Footer controls
            HStack {
                // calls the newGame() method
                Button("New Game") { viewModel.newGame() }
                Spacer()
                // calls the score method logic
                Text("Score: \(viewModel.score)")
                    .font(.headline)
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
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        .foregroundColor(viewModel.themeColor)
    }

    struct CardView: View{
        let card: MemoryGame<String>.Card
        
        init(_ card: MemoryGame<String>.Card) {
            self.card = card
        }
        
        var body: some View{
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group{
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(card.content)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(1, contentMode: .fit)
                }
                .opacity(card.isFaceUp ? 1: 0)
                base.fill().opacity(card.isFaceUp ? 0 : 1)
                
            }
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        }
    }

}

// testing new push

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
