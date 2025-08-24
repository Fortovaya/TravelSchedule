//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Алина on 01.08.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false
    @AppStorage("didBootstrapTheme") private var didBootstrapTheme = true
    @State private var showUserAgreement = false
    
    var onColor: Color = .ypBlue
    var offColor: Color = .ypGray.opacity(0.3)
    var thumbColor: Color = .white
    
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
                            .tint(onColor)
                            .onChange(of: isDarkThemeEnabled) { oldValue, newValue in
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
                UserAgreementView()
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
