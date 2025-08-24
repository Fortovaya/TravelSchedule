//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Алина on 01.08.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(AppStorageKeys.isDarkThemeEnabled) private var isDarkThemeEnabled = false
    @AppStorage(AppStorageKeys.didBootstrapTheme) private var didBootstrapTheme = true
    
    @State private var showUserAgreement = false
    
    private enum Theme {
        static let onColor: Color   = .ypBlue
        static let offColor: Color  = .ypGray.opacity(0.3)
        static let thumbColor: Color = .white
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                List {
                    HStack {
                        Text("Темная тема")
                            .font(.regular17)
                            .foregroundColor(.ypBlack)
                        Spacer()
                        Toggle("", isOn: $isDarkThemeEnabled)
                            .labelsHidden()
                            .tint(Theme.onColor)
                            .onChange(of: isDarkThemeEnabled) { _, _ in
                                didBootstrapTheme = true
                            }
                    }
                    .listRowInsets(.init(top: 19, leading: 16, bottom: 19, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.top, 24)
                    
                    Button {
                        showUserAgreement = true
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(.regular17)
                                .foregroundColor(.ypBlack)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .frame(width: 24.0, height: 24.0)
                                .foregroundColor(.ypBlack)
                        }
                    }
                    .listRowInsets(.init(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .environment(\.defaultMinListRowHeight, 60)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showUserAgreement) {
                UserAgreementWebScreen()
            }
            
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 6) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.regular12)
                        .foregroundColor(.ypBlack)
                        .multilineTextAlignment(.center)
                    Text("Версия 1.0 (beta)")
                        .font(.regular12)
                        .foregroundColor(.ypBlack)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}
