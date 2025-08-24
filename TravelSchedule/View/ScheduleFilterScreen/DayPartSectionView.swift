//
//  DayPartSectionView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI

enum DayPart: String, CaseIterable, Identifiable, Hashable {
    case morning = "Утро 06:00 – 12:00"
    case day     = "День 12:00 – 18:00"
    case evening = "Вечер 18:00 – 00:00"
    case night   = "Ночь 00:00 – 06:00"
    var id: Self { self }
}

struct DayPartSectionView: View {
    @Binding var selectedParts: Set<DayPart>
    
    private let hInset: CGFloat = 16
    
    var body: some View {
        Section {
            ForEach(DayPart.allCases) { part in
                Button {
                    toggle(part)
                } label: {
                    HStack {
                        Text(part.rawValue)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.ypBlack)
                        Spacer()
                        Image(selectedParts.contains(part) ? "excludeOn" : "excludeOff")
                            .renderingMode(.template)
                            .foregroundColor(.ypBlack)
                            .frame(width: 24, height: 24)
                    }
                    .frame(height: 60)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
        } header: {
            Text("Время отправления")
                .textCase(nil)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.ypBlack)
        }
    }
    
    private func toggle(_ part: DayPart) {
        if selectedParts.contains(part) { selectedParts.remove(part) }
        else { selectedParts.insert(part) }
    }
    
}

extension DayPart {
    var range: Range<Int> {
        switch self {
            case .morning: return 6..<12
            case .day:     return 12..<18
            case .evening: return 18..<24
            case .night:   return 0..<6
        }
    }
    func contains(hour: Int) -> Bool { range.contains(hour) }
}


#Preview {
    List {
        DayPartSectionView(selectedParts: .constant([.morning, .night]))
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(.ypWhite)
}
