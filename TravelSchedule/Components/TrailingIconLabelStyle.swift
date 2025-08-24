//
//  TrailingIconLabelStyle.swift
//  TravelSchedule
//
//  Created by Алина on 24.08.2025.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.title
            configuration.icon
        }
    }
}
