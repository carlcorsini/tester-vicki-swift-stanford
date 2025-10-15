//
//  testerApp.swift
//  tester
//
//  Created by Carl Corsini on 10/2/25.
//

import SwiftUI

@main
struct testerApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
