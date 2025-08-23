//
//  StoryCardView.swift
//  TravelSchedule
//
//  Created by Алина on 23.08.2025.
//

import SwiftUI

struct StoryCardView: View {
    let story: Story
    private let size = CGSize(width: 92, height: 140)
    private let corner: CGFloat = 16
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let name = story.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                story.backgroundColor
                    .frame(width: size.width, height: size.height)
            }
            
            Text(story.title)
                .font(.regular12)
                .foregroundColor(.ypWhiteUniversal)
                .lineLimit(3)
                .padding(8)
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
    }
}

#Preview("CardLight", traits: .sizeThatFitsLayout) {
    StoryCardView(story: .storyOne)
        .padding()
}

#Preview("CardDark", traits: .sizeThatFitsLayout) {
    StoryCardView(story: .storyOne)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Strip (horizontal)", traits: .fixedLayout(width: 390, height: 200)) {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            ForEach(Array(Story.all.prefix(5)).indices, id: \.self) { i in
                StoryCardView(story: Story.all[i])
            }
        }
        .padding()
    }
}
