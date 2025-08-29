//
//  UserDefaultsThemePreferencesStore.swift
//  TravelSchedule
//
//  Created by Алина on 27.08.2025.
//

import Foundation

protocol ThemePreferencesStore: Sendable {
    var isDarkThemeEnabled: Bool { get set }
    var didBootstrapTheme: Bool { get set }
}

struct UserDefaultsThemePreferencesStore: ThemePreferencesStore, @unchecked Sendable {
    private let ud: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.ud = userDefaults
    }
    
    
    var isDarkThemeEnabled: Bool {
        get { ud.bool(forKey: AppStorageKeys.isDarkThemeEnabled) }
        set { ud.set(newValue, forKey: AppStorageKeys.isDarkThemeEnabled) }
    }
    
    var didBootstrapTheme: Bool {
        get { ud.bool(forKey: AppStorageKeys.didBootstrapTheme) }
        set { ud.set(newValue, forKey: AppStorageKeys.didBootstrapTheme) }
    }
}
