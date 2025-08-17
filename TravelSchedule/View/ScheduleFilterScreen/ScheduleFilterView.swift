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
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if isApplyEnabled {
                HStack {
                    Button("Применить") {
                        
                    }
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.ypBlue)
                    .foregroundColor(.ypWhiteUniversal)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    ScheduleFilterView()
}
