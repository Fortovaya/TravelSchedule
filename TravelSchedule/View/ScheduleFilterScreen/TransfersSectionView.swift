//
//  TransfersSectionView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI

enum TransfersOption: String, Identifiable, Hashable {
    case yes, no
    var id: Self { self }
    var title: String { self == .yes ? "Да" : "Нет" }
}

struct TransfersSectionView: View {
    @Binding var transfers: TransfersOption?
    
    var body: some View {
        Section {
            ForEach([TransfersOption.yes, .no]) { option in
                HStack {
                    Text(option.title)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.ypBlack)
                    Spacer()
                    Image(transfers == option ? "circleOn" : "circleOff")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.ypBlack)
                        .frame(width: 24, height: 24)
                }
                .contentShape(Rectangle())
                .onTapGesture { transfers = option }
                .listRowSeparator(.hidden)
                .frame(height: 60)
            }
        } header: {
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.ypBlack)
        }
    }
}

#Preview("TransfersSection • none selected") {
    List {
        TransfersSectionView(transfers: .constant(nil))
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(.ypWhite)
}

#Preview("TransfersSection • YES selected") {
    List {
        TransfersSectionView(transfers: .constant(.yes))
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(.ypWhite)
}
