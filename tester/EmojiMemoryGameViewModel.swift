//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Vicki Diaz on 10/15/25.
//

// THIS IS THE VIEW MODEL FILE

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // creating the 6 themes
    private static let allThemes: [Theme<String>] = [
        Theme(name: "Halloween",
              emojis: ["👻","🎃","🕷️","🕸️","🍁","🦇","🥀","🧡","🌗","✨"],
              numberOfPairs: 6,
              color: "orange"),
        Theme(name: "Hearts",
              emojis: ["❤️","🩷","💕","🧡","💙", "🤍", "🖤","🩵","💚","💔"],
              numberOfPairs: 5,
              color: "red"),
        Theme(name: "Flowers",
              emojis: ["🌸","🌼","🌺","🌹","💐","🌻","🪻","🪷","🥀","🌷"],
              numberOfPairs: 6,
              color: "yellow"),
        Theme(name: "Food",
              emojis: ["🍔","🌭","🌮","🌯","🍝","🍣","🍪","🍟","🍱","🍧"],
              numberOfPairs: 8,
              color: "blue"),
        Theme(name: "School",
              emojis: ["🍎","📚","✏️","📓","🚌","🖇️","✂️","🖍️","📐","📕"],
              numberOfPairs: 7,
              color: "purple"),
        Theme(name: "Flags",
              emojis: ["🇨🇦","🇫🇷","🇨🇴","🇯🇵","🇰🇷","🇬🇹","🇮🇪","🇩🇴","🇮🇹","🇲🇽"],
              numberOfPairs: 6,
              color: "green")
    ]
    
    // Creates a MemoryGame based on a Theme<String>
    private static func createMemoryGame(from theme: Theme<String>) -> MemoryGame<String> {
        // Shuffle the emoji list so each game is different
        let picks = theme.emojis.shuffled()
        
        // limits number of pairs to the theme's defined amount
        let pairs = max(1, min(theme.numberOfPairs, picks.count))
        
        // Select just the needed number of emojis
        let chosen = Array(picks.prefix(pairs))
        
        // Create and return the MemoryGame model using those emojis
        return MemoryGame(numberOfPairsOfCards: pairs) { pairIndex in
            chosen[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String>
    @Published private var theme: Theme<String>

    init() {
        // Randomly pick a theme each time a new game starts
        let t = Self.allThemes.randomElement()!
        self.theme = t
        self.model = Self.createMemoryGame(from: t)
        self.model.shuffle()
    }

    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    var score: Int { model.score }
    var themeName: String { theme.name }
    
    var themeColor: Color {
        switch theme.color.lowercased() {
        case "orange": return .orange
        case "red":    return .red
        case "yellow": return .yellow
        case "blue":   return .blue
        case "purple": return .purple
        case "green":  return .green
        default:       return .gray
        }
    }

    // MARK: - Intents

    func shuffle() {
        withAnimation { model.shuffle() }
    }

    func choose(_ card: MemoryGame<String>.Card) {
        // Flip the card with animation
        withAnimation {
            model.choose(card)
//            model.processMatch()
        }
        
        // If this was the second card in a pair, wait before processing the match
        if model.needsMatchProcessing {
            Task { @MainActor in
                // Wait 0.6 seconds so user can see both cards
                try? await Task.sleep(for: .seconds(0.6))
                
                // Process the match/mismatch with animation
                withAnimation {
                    model.processMatch()
                }
            }
        }
    }

    // start new game with a new random theme
    func newGame() {
        let t = Self.allThemes.randomElement()!
        theme = t
        model = Self.createMemoryGame(from: t)
        model.shuffle()
    }
}
