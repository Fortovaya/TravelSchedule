//
//  FilterResultView.swift
//  TravelSchedule
//
//  Created by Алина on 24.08.2025.
//

import SwiftUI

struct FilterResultView: View {
    let headerFrom: String
    let headerTo: String
    let items: [CarrierRowViewModel]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("\(headerFrom) → \(headerTo)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                if items.isEmpty {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    List(items) { item in
                        CarrierTableRow(viewModel: item)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.ypBlack)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            Button(action: { dismiss() }) {
                Label {
                    Text("Уточнить время")
                        .font(.bold17)
                        .foregroundStyle(.ypWhiteUniversal)
                } icon: {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.ypRed)
                        .frame(width: 8, height: 8)
                }
                .labelStyle(TrailingIconLabelStyle())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.ypBlue, in: RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 6)
        }
    }
}

#Preview {
    NavigationStack {
        FilterResultView(
            headerFrom: "Москва (Ярославский вокзал)",
            headerTo: "Санкт-Петербург (Балтийский вокзал)",
            items: CarrierRowViewModel.mock.prefix(1).map { $0 }
        )
    }
}
