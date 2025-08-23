//
//  MaskView.swift
//  TravelSchedule
//
//  Created by Алина on 23.08.2025.
//

import SwiftUI

struct MaskView: View {
    let numberOfSections: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

#Preview {
    Color.story1Background
        .ignoresSafeArea()
        .overlay(
            MaskView(numberOfSections: 3)
                .padding()
        )
}
