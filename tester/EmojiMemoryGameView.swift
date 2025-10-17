//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by USER1 on 10/1/25.
//

// command shift l - for symbols

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var deck: [String] = []
    
    var body: some View {
        VStack{
            // adding the title ontop of screen
            Text("Memorize!").font(.largeTitle)
            // this allows you to scroll through screen
            ScrollView{
                cards.animation(.default, value: viewModel.cards)
            }
            // space between the grid and the buttons
            Spacer()

            Button("Shuffle") {
                viewModel.shuffle()
            }
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
            .foregroundColor(.orange)
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
