//
//  ScheduleFilterView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI

struct ScheduleFilterView: View {
    
    @State private var selectedParts: Set<DayPart> = []
    @State private var transfers: TransfersOption? = nil
    
    var onApply: ((Set<DayPart>, TransfersOption?) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    private var isApplyEnabled: Bool { !selectedParts.isEmpty && transfers != nil }
    
    var body: some View {
        ZStack {
            List {
                DayPartSectionView(selectedParts: $selectedParts)
                TransfersSectionView(transfers: $transfers)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if isApplyEnabled {
                Button {
                    onApply?(selectedParts, transfers)
                } label: {
                    Text("Применить")
                        .font(.bold17)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                .foregroundColor(.ypWhiteUniversal)
                .background(Color.ypBlue)
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                .background(Color(.systemBackground))
            }
        }
    }
}

#Preview {
    ScheduleFilterView()
}
