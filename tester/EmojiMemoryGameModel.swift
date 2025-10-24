//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Vicki Diaz on 10/15/25.

// THIS IS THE MODEL FILE : LIKE LOGIC AND DATA OF THE GAME
//

import Foundation

// step 4 : a formal concept of a "Theme" to your Model
struct Theme<CardContent> {
    let name: String
    let emojis: [CardContent]
    // how many pairs to show this game
    let numberOfPairs: Int
    let color: String
}
 
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private var seenCardIDs: Set<String> = []
    
    // Track indices for delayed match processing
    private var firstCardIndex: Int?
    private var secondCardIndex: Int?
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = []
        // add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex)a"))
            cards.append(Card(content: content, id: "\(pairIndex)b"))
        }
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach{ cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    // Returns true if we need to process a match after a delay
    var needsMatchProcessing: Bool {
        firstCardIndex != nil && secondCardIndex != nil
    }
    
    mutating func choose(_ card: Card) {
        // Find the card in the array and validate it can be flipped (must be face down and not already matched)
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            
            // Check if this is the SECOND card being flipped (first card is already face up)
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                
                // --- SECOND CARD FLIP ---
                // Just flip it face up, DON'T reset indexOfOneAndOnlyFaceUpCard yet
                // (resetting it flips all cards down, which would hide the emojis)
                cards[chosenIndex].isFaceUp = true
                
                // Store indices for delayed match processing
                firstCardIndex = potentialMatchIndex
                secondCardIndex = chosenIndex
                
            } else {
                
                // --- FIRST CARD FLIP: Starting a new pair ---
                cards[chosenIndex].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
            
            print("choose \(card)")
        }
    }
    
    // Process the match/mismatch after both cards have been flipped and shown to user
    mutating func processMatch() {
        guard let firstIndex = firstCardIndex,
              let secondIndex = secondCardIndex else {
            return
        }
        
        // Compare card contents to see if we have a match
        if cards[firstIndex].content == cards[secondIndex].content {
            // MATCH FOUND: Mark both cards as matched and award points
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            score += 2
        } else {
            // MISMATCH: Apply penalty for each card that was previously seen
            if seenCardIDs.contains(cards[firstIndex].id) { score -= 1 }
            if seenCardIDs.contains(cards[secondIndex].id) { score -= 1 }
        }
        
        // Track that both cards have now been exposed/seen by the player
        seenCardIDs.insert(cards[firstIndex].id)
        seenCardIDs.insert(cards[secondIndex].id)
        
        // NOW reset the tracker - this flips all unmatched cards face down
        // (we do this AFTER the delay so user sees both cards first)
        indexOfOneAndOnlyFaceUpCard = nil
        
        // Clear the stored indices
        firstCardIndex = nil
        secondCardIndex = nil
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    func index(of card: Card) -> Int? {
        for index in cards.indices {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "Card (id: \(id)): \(content), is face up: \(isFaceUp), is matched: \(isMatched)"
        }
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        var id: String
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
