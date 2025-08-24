//
//  CloseButton.swift
//  TravelSchedule
//
//  Created by Алина on 23.08.2025.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(.close)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 30, height: 30)
        .background(Color.ypBlackUniversal)
        .clipShape(Circle())
        .contentShape(Circle())
    }
}
