//
//  StoriesStripView.swift
//  TravelSchedule
//
//  Created by Алина on 23.08.2025.
//

import SwiftUI

struct StoriesStripView: View {
    let stories: [Story]
    var onTap: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories.indices, id: \.self) { i in
                    StoryCardView(story: stories[i])
                        .onTapGesture { onTap(i) }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }
}

#Preview("Stories strip") {
    StoriesStripView(stories: Array(Story.all.prefix(8))) { _ in }
        .padding(.vertical, 8)
}
