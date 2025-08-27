//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Алина on 27.08.2025.
//

import Foundation
import Combine
import Observation

@Observable
final class SettingsViewModel {
    var isDarkThemeEnabled: Bool
    var showUserAgreement: Bool = false
    
    private let themeDidChangeSubject = PassthroughSubject<Bool, Never>()
    var themeDidChange: AnyPublisher<Bool, Never> { themeDidChangeSubject.eraseToAnyPublisher() }
    
    private var didBootstrapTheme: Bool
    private var store: ThemePreferencesStore
    
    init(store: ThemePreferencesStore = UserDefaultsThemePreferencesStore()) {
        self.store = store
        self.isDarkThemeEnabled = store.isDarkThemeEnabled
        self.didBootstrapTheme  = store.didBootstrapTheme
    }
    
    func toggleDarkTheme(_ isOn: Bool) {
        isDarkThemeEnabled = isOn
        store.isDarkThemeEnabled = isOn
        didBootstrapTheme = true
        store.didBootstrapTheme = true
        themeDidChangeSubject.send(isOn) 
    }
    
    func openAgreement() {
        showUserAgreement = true
    }
}
