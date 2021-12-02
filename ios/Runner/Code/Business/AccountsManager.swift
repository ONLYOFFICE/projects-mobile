//
//  AccountsManager.swift
//  Runner
//
//  Created by Alexander Yuzhin on 02.12.2021.
//  Copyright © 2021 Ascensio System SIA. All rights reserved.
//

import Foundation
import KeychainSwift

class AccountsManager {
    public static let shared = AccountsManager()
    
    private(set) var accounts: [ASCAccount] = []
    private let keychain = KeychainSwift()
    
    // MARK: - Private
    
    init() {
        NSKeyedUnarchiver.setClass(ASCAccount.self, forClassName: "Projects.ASCAccount")
        NSKeyedUnarchiver.setClass(ASCAccount.self, forClassName: "ASCAccount")
        NSKeyedArchiver.setClassName("ASCAccount", for: ASCAccount.self)

        loadAccounts()
    }
    
    public class func start() {
        _ = AccountsManager.shared
    }
    
    private func loadAccounts() {
        keychain.accessGroup = Constants.Keychain.group
        keychain.synchronizable = true

        if let rawData = keychain.getData(Constants.Keychain.keyAccounts),
            let array = NSKeyedUnarchiver.unarchiveObject(with: rawData) as? [ASCAccount] {
            accounts = array
        } else {
            accounts = []
        }
    }
    
    private func storeAccounts() {
        let rawData = NSKeyedArchiver.archivedData(withRootObject: accounts)
        keychain.set(rawData, forKey: Constants.Keychain.keyAccounts)
    }
    
    private func index(of account: ASCAccount) -> Int? {
        return accounts.firstIndex(where: { ($0.email == account.email) && ($0.portal == account.portal) })
    }
    
    // MARK: - Public

    /// Add new account or update exist
    ///
    /// - Parameter account: New account object
    func add(account: ASCAccount) {
        if let index = index(of: account) {
            accounts[index] = account
        } else {
            accounts.append(account)
        }
        storeAccounts()
    }

    /// Remove exist account
    ///
    /// - Parameter account: Exist account object
    func remove(account: ASCAccount) {
        if let index = index(of: account) {
            accounts.remove(at: index)
            storeAccounts()
        }
    }
    
    /// Update exist account
    ///
    /// - Parameter account: Search exist record to update by 'id' and 'portal' properties of ASCAccount object
    func update(account: ASCAccount) {
        if let index = index(of: account) {
            accounts[index] = account
            storeAccounts()
        }
    }
    
    /// Add new account or update exist
    ///
    /// - Parameter json: New account object from json
    func add(json: [String : Any]) {
        guard let account = ASCAccount(JSON: json) else {
            return
        }
        add(account: account)
    }

    /// Remove exist account
    ///
    /// - Parameter json: Exist account object from json
    func remove(json: [String : Any]) {
        guard let account = ASCAccount(JSON: json) else {
            return
        }
        remove(account: account)
    }
    
    /// Update exist account
    ///
    /// - Parameter json: Search exist record to update by 'id' and 'portal' properties of ASCAccount object from json
    func update(json: [String : Any]) {
        guard let account = ASCAccount(JSON: json) else {
            return
        }
        update(account: account)
    }
    
    /// Add new account or update exist
    ///
    /// - Parameter json: New account object from json string
    func add(string: String) {
        guard let account = ASCAccount(JSONString: string) else {
            return
        }
        add(account: account)
    }

    /// Remove exist account
    ///
    /// - Parameter json: Exist account object from json string
    func remove(string: String) {
        guard let account = ASCAccount(JSONString: string) else {
            return
        }
        remove(account: account)
    }
    
    /// Update exist account
    ///
    /// - Parameter json: Search exist record to update by 'id' and 'portal' properties of ASCAccount object from json string
    func update(string: String) {
        guard let account = ASCAccount(JSONString: string) else {
            return
        }
        update(account: account)
    }

    /// Returns the account by portal address and email
    ///
    /// - Parameters:
    ///     - portal: Portal address
    ///     - email: User email
    ///
    /// - Returns: An account record
    func get(by portal: String, email: String) -> ASCAccount? {
        return accounts.first(where: { ($0.email == email) && ($0.portal == portal) })
    }
    
    /// Export accounts to json string
    /// - Returns: json string
    func exportAccounts() -> String? {
        return accounts.toJSONString()
    }
}
