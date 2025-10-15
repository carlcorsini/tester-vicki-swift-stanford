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
    
    // here i created the arrays of the emojis for each theme
    let hearts = ["❤️","🩷","💕","🧡","💙", "🤍", "🖤"]
    let flowers = ["🌸","🌼","🌺","🌹","💐","🌻","🪻"]
    let foods   = ["🧇","🥐","🍕","🍿","🍩","🍰","🌯","🍓","🥑","🍜"]
    
    // deck variable will hold whatever theme we pick in the current deck of cards being shown on screen
    @State var deck: [String] = []


    // another way to craete array as above line
    //let emojis: Array<String> = ["👻","🎃","🕷️","🕸️"]
    //@State var cardCount: Int = 4
    
    var body: some View {
        VStack{
            // adding the title ontop of screen
            Text("Memorize!").font(.largeTitle)
            // this allows you to scroll through screen
            ScrollView{
                cards
            }
            // space between the grid and the buttons
            Spacer()
            //cardCountAdjusters
            // call all teh theme buttons
            themeButtons
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        // sets a default theme so when we refresh there is cards
        .onAppear {
                // picks the theme
            changeTheme(hearts, pairs: 6)
            }
        // padding around teh whole vSack
        .padding()
    }
    
    // theme: [String] passes in one of the emoji arrays like hearts. whatever you click
    // pairs: Int passes how many emojis to use for the theme like how many to grad from the array.
    // theme.prefix(pairs) takes only the first N emojis, which is the pairs we passed in/ specified
    // and then is added/converts then into an array thorugh Array(...) .
    // deck hold teh emojis for teh deck which is made up by picks + picks . pick + pick make copy of the emoji and that is shuffled . step 7
    // i found that in here : https://developer.apple.com/documentation/swift/array/shuffled()
    

    func changeTheme(_ theme: [String], pairs: Int) {
        //isFaceUp = false
        let picked_emojis = Array(theme.prefix(pairs))

        deck = (picked_emojis + picked_emojis).shuffled()
       
    }

    
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
                // loops each amoji in the deck
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(viewModel.cards[index])
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                }
            }
            .foregroundColor(.orange)

        
    }
    
    // creating the theme buttons
    var themeButtons: some View {
        // Hstack to make them horizontaly next to eachother
        HStack {
            Spacer()
            // button for hearts
            Button{
                changeTheme(hearts, pairs: 4)
            } label: {
                VStack {
                    // found in finder, applications, then i went to sf symbols
                    Image(systemName: "heart.fill")
                    Text("Hearts").font(.caption)
                }
            }
            Spacer()
            // Flowers
            Button {
                changeTheme(flowers, pairs: 6)
            } label: {
                VStack {
                    // found in finder, applications, then i went to sf symbols
                    Image(systemName: "camera.macro")
                    Text("Flowers").font(.caption)
                }
            }

            Spacer()

            // Foods
            Button {
                changeTheme(foods, pairs: 8)
            } label: {
                VStack {
                    // found in finder, applications, then i went to sf symbols
                    Image(systemName: "fork.knife.circle")
                    Text("Foods").font(.caption)
                }
            }

            Spacer()

            // (you can keep your Vehicles, Animals, Faces here too)
        }
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
//            .onTapGesture{
//                card.isFaceUp.toggle()
//            }
        }
    }

}
// from lec 1 and 2




// testing new push

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
