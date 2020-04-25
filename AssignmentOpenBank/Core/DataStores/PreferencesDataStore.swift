//
//  PreferencesDataStore.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 07/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

public class PreferencesDataStore {
    
    private let preferences: Preferences

    init(preferences: Preferences = Preferences.standard) {
        self.preferences = preferences
    }

    func clear() {
        preferences.set(nil, forKey: PreferencesKeys.firstTimeAppLaunch)
        preferences.set(nil, forKey: PreferencesKeys.lastTransferCheckTimestamp)
    }
    
    func clearRegistration() {
        preferences.set(nil, forKey: PreferencesKeys.authVerificationId)
        preferences.set(nil, forKey: PreferencesKeys.authVerificationPhoneNumber)
    }
    
    // MARK: App launched
    func saveAppFirstTimeLaunched(_ launched: Bool) {
        preferences.set(launched, forKey: PreferencesKeys.firstTimeAppLaunch)
    }
    
    func getAppFirstTimeLaunched() -> Bool {
        return preferences.bool(forKey: PreferencesKeys.firstTimeAppLaunch)
    }
    
    // MARK: Registration
    func saveAuthVerificationId(_ id: String) {
        preferences.set(id, forKey: PreferencesKeys.authVerificationId)
    }
    
    func getAuthVerificationId() -> String? {
        return preferences.string(forKey: PreferencesKeys.authVerificationId)
    }
    
    func saveAuthVerificationPhoneNumber(_ phone: String) {
        preferences.set(phone, forKey: PreferencesKeys.authVerificationPhoneNumber)
    }
    
    func getAuthVerificationPhoneNumber() -> String? {
        return preferences.string(forKey: PreferencesKeys.authVerificationPhoneNumber)
    }
    
    // MARK: App launched
    func saveAppFirstTimeGetTransactions(_ launched: Bool) {
        preferences.set(launched, forKey: PreferencesKeys.firstTimeAppGetTransactions)
    }
    
    func getAppFirstTimeGetTransactions() -> Bool {
        return preferences.bool(forKey: PreferencesKeys.firstTimeAppGetTransactions)
    }
    
    // MARK: Transaction timestamp
    func saveLastTransactionCheck(_ date: Date) {
        preferences.set(date, forKey: PreferencesKeys.lastTransferCheckTimestamp)
    }
    
    func getLastTransactionCheck() -> Date {
        return preferences.object(forKey: PreferencesKeys.lastTransferCheckTimestamp) as! Date
    }
}
