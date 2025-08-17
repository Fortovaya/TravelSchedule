//
//  CarrierRowView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI
import UIKit

// MARK: - Table Row
struct CarrierTableRow: View {
    
    private enum Constants {
        static let outerSpacing: CGFloat = 10
        static let hStackSpacing: CGFloat = 12
        static let rowPadding: CGFloat = 14
        static let rowHeight: CGFloat = 104
        static let logoSize: CGFloat = 38
        static let logoCorner: CGFloat = 12
        static let cardCorner: CGFloat = 24
        static let cardStrokeOpacity: CGFloat = 0.3
        static let nameFont: CGFloat = 17
        static let timeFont: CGFloat = 17
        static let dateFont: CGFloat = 12
        static let durationFont: CGFloat = 12
        static let noteFont: CGFloat = 12
        static let lineHeight: CGFloat = 1
        static let lineWidth: CGFloat = 1
        static let fallbackSymbol = "building.2"
    }
    
    let viewModel: CarrierRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.outerSpacing) {
            HStack(spacing: Constants.hStackSpacing) {
                logoView(name: viewModel.logoSystemName)
                    .frame(width: Constants.logoSize, height: Constants.logoSize)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.logoCorner))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.carrierName)
                        .font(.system(size: Constants.nameFont, weight: .regular))
                        .foregroundColor(.ypBlackUniversal)
                    if let note = viewModel.note {
                        Text(note)
                            .font(.system(size: Constants.noteFont, weight: .regular))
                            .foregroundColor(.ypRed)
                    }
                }
                
                Spacer()
                Text(viewModel.dateText)
                    .font(.system(size: Constants.dateFont, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
            }
            
            HStack(spacing: Constants.hStackSpacing) {
                Text(viewModel.departTime)
                    .font(.system(size: Constants.timeFont, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
                line
                Text(viewModel.durationText)
                    .font(.system(size: Constants.durationFont, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
                line
                Text(viewModel.arriveTime)
                    .font(.system(size: Constants.timeFont, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
            }
        }
        .padding(Constants.rowPadding)
        .frame(height: Constants.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: Constants.cardCorner)
                .fill(Color.ypLightGray)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCorner)
                .stroke(Color.ypGray.opacity(Constants.cardStrokeOpacity), lineWidth: Constants.lineWidth)
        )
    }
    
    private var line: some View {
        Rectangle()
            .fill(Color.ypGray)
            .frame(height: Constants.lineHeight)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func logoView(name: String?) -> some View {
        if let name, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
                .clipped()
        } else if let name {
            Image(systemName: name)
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            Image(systemName: Constants.fallbackSymbol)
                .resizable()
                .scaledToFill()
                .clipped()
        }
    }
}

#Preview("CarrierTableRow • Dark", traits: .sizeThatFitsLayout) {
    CarrierTableRow(
        viewModel: CarrierRowViewModel(
            carrierName: "РЖД",
            logoSystemName: "rzd",
            dateText: "14 января",
            departTime: "10:00",
            arriveTime: "14:30",
            durationText: "4 ч 30 мин",
            note: "С пересадкой в Костроме"
        )
    )
    .padding(16)
    .background(Color.black)
    .environment(\.colorScheme, .dark)
}
