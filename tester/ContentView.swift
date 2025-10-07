//
//  ContentView.swift
//  tester
//
//  Created by Carl Corsini on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["🎃", "⛳️", "👹", "🐣", "👻", "🙉", "🍦", "🇱🇹", "🚌"]
    @State var cardCount: Int = 4
    var body: some View {
        VStack {
            ScrollView{
                Cards
            }
            
            Spacer()
            CardCountAdjusters
        }.padding()

    }
    
    

    var Cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index]).aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)

    }
    
    func cardCountAdjuster(by offset: Int, symbol: String)-> some View {
        Button(
            action: {
                cardCount += offset
            },
            label: {
                Image(systemName: symbol)
            }
        ).disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }

    var CardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.plus.fill")
            .imageScale(.large)
            .font(.largeTitle)
    }

    var CardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
        .imageScale(.large)
        .font(.largeTitle)
    }

    var CardCountAdjusters: some View {
        HStack {
            Spacer()
            CardRemover
            Spacer()
            CardAdder
            Spacer()
            Button(
                action: {
                    cardCount = 4
                },
                label: {
                    Image(systemName: "rectangle.stack.badge.play.fill")
                }
            )
            .imageScale(.large)
            .font(.largeTitle)
            Spacer()
        }
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = true
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
            // test change

        }
    }
}

#Preview {
    ContentView()
}
