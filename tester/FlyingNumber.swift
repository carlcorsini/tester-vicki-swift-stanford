//
//  FlyingNumber.swift
//  tester
//
//  Created by Carl Corsini on 10/31/25.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number)
        }
        
    }
}

#Preview {
    FlyingNumber(number: 5)
}
