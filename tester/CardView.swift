//
//  CardView.swift
//  tester
//
//  Created by Carl Corsini on 10/28/25.
//
import SwiftUI

struct CardView: View{
    typealias Card = MemoryGame<String>.Card
    let card: Card
        
    init(_ card: Card) {
        self.card = card
    }
    
  
        
    var body: some View{
        Pie(startAngle: .degrees(0), endAngle: .degrees(240))
            .opacity(0.4)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.inset)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: false), value: card.isMatched)
            )
            .padding(Constants.inset)
            .cardify(isFaceUp: card.isFaceUp)
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = 0.01
        }
    }
}

#Preview {
    //    typealias Card = CardView.Card
    VStack{
        
    
        HStack{
            CardView(MemoryGame<String>.Card(content: "X", id: "test1"))
                .padding()
                .foregroundColor(.green)
            CardView(MemoryGame<String>.Card(content: "X", id: "test1"))
                .padding()
                .foregroundColor(.green)
        }
        HStack{
            CardView(MemoryGame<String>.Card(content: "X", id: "test1"))
                .padding()
                .foregroundColor(.green)
            CardView(MemoryGame<String>.Card(content: "X", id: "test1"))
                .padding()
                .foregroundColor(.green)
        }
    }
    
}
