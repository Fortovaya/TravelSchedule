//
//  CarrierRowView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI


struct CarrierTableRow: View {
    
    private enum Constants {
        enum Spacing {
            static let outer: CGFloat = 10
            static let inner: CGFloat = 12
            static let rowPadding: CGFloat = 14
        }
        enum Size {
            static let rowHeight: CGFloat = 104
            static let logo: CGFloat = 38
            static let lineHeight: CGFloat = 1
            static let lineWidth: CGFloat = 1
        }
        enum Corner {
            static let logo: CGFloat = 12
            static let card: CGFloat = 24
        }
        enum Opacity {
            static let card: CGFloat = 0.3
        }
        enum FontSize {
            static let name: CGFloat = 17
            static let time: CGFloat = 17
            static let date: CGFloat = 12
            static let duration: CGFloat = 12
            static let note: CGFloat = 12
        }
        enum Images {
            enum System {
                static let fallback = "building.2"
            }
        }
    }
    
    let viewModel: CarrierRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.outer) {
            headerContent
            timeContent
        }
        .padding(Constants.Spacing.rowPadding)
        .frame(height: Constants.Size.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: Constants.Corner.card)
                .fill(Color.ypLightGray)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.Corner.card)
                .stroke(Color.ypGray.opacity(Constants.Opacity.card), lineWidth: Constants.Size.lineWidth)
        )
    }
    
    private var headerContent: some View {
        HStack(spacing: Constants.Spacing.inner) {
            logoView
                .frame(width: Constants.Size.logo, height: Constants.Size.logo)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Corner.logo))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.carrierName)
                    .font(.system(size: Constants.FontSize.name, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
                
                if viewModel.hasTransfers, let note = viewModel.note {
                    Text(note)
                        .font(.system(size: Constants.FontSize.note, weight: .regular))
                        .foregroundColor(.ypRed)
                }
            }
            
            Spacer()
            
            Text(viewModel.dateText)
                .font(.system(size: Constants.FontSize.date, weight: .regular))
                .foregroundColor(.ypBlackUniversal)
        }
    }
    
    private var timeContent: some View {
        HStack(spacing: Constants.Spacing.inner) {
            departTimeText
            line
            durationText
            line
            arriveTimeText
        }
    }
    
    private var departTimeText: some View {
        Text(viewModel.departTime)
            .font(.system(size: Constants.FontSize.time, weight: .regular))
            .foregroundColor(.ypBlackUniversal)
    }
    
    private var arriveTimeText: some View {
        Text(viewModel.arriveTime)
            .font(.system(size: Constants.FontSize.time, weight: .regular))
            .foregroundColor(.ypBlackUniversal)
    }
    
    private var durationText: some View {
        Text(viewModel.durationText)
            .font(.system(size: Constants.FontSize.duration, weight: .regular))
            .foregroundColor(.ypBlackUniversal)
    }
    
    private var line: some View {
        Rectangle()
            .fill(Color.ypGray)
            .frame(height: Constants.Size.lineHeight)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var logoView: some View {
        if let url = viewModel.finalLogoURL {
            AsyncImage(url: url) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: Constants.Size.logo, height: Constants.Size.logo)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: Constants.Size.logo, height: Constants.Size.logo)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Corner.logo, style: .continuous))
                    case .failure:
                        fallbackLogo
                    @unknown default:
                        fallbackLogo
                }
            }
        } else if let name = viewModel.finalLogoSystemName, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .frame(width: Constants.Size.logo, height: Constants.Size.logo)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Corner.logo, style: .continuous))
        } else if let name = viewModel.finalLogoSystemName {
            Image(systemName: name)
                .resizable()
                .frame(width: Constants.Size.logo, height: Constants.Size.logo)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Corner.logo, style: .continuous))
                .foregroundColor(.ypGray)
        } else {
            fallbackLogo
        }
    }
    
    private var fallbackLogo: some View {
        Image(systemName: "photo")
            .resizable()
            .frame(width: Constants.Size.logo, height: Constants.Size.logo)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Corner.logo, style: .continuous))
            .foregroundColor(.ypGray)
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
            note: "С пересадкой в Костроме",
            carrierCode: "680",
            hasTransfers: true
        )
    )
    .padding(16)
    .background(Color.black)
    .environment(\.colorScheme, .dark)
}
