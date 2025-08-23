//
//  MaskFragmentView.swift
//  TravelSchedule
//
//  Created by Алина on 23.08.2025.
//

import SwiftUI

struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: .progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: .progressBarHeight)
            .cornerRadius(3)
            .foregroundStyle(.white) // белый цвет для progressBar
    }
}


#Preview {
    Color.story1Background
        .ignoresSafeArea()
        .overlay(
            HStack {
                MaskFragmentView()
                MaskFragmentView()
                MaskFragmentView()
            }.padding()
        )
}
