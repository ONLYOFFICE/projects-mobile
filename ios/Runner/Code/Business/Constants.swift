//
//  Constants.swift
//  Runner
//
//  Created by Alexander Yuzhin on 02.12.2021.
//  Copyright © 2021 Ascensio System SIA. All rights reserved.
//

import Foundation

class Constants {
    
    struct Keychain {
        static let group                    = Constants.internalConstants["KeychainGroup"] as? String ?? ""
        static let keyAccounts              = "asc-accounts"
    }
    
    // MARK: - Methods
    
    class var internalConstants: [String : Any] {
        if let url = Bundle.main.url(forResource:"Internal", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                return try PropertyListSerialization.propertyList(from: data, format: nil) as? [String : Any] ?? [:]
            } catch {
                print(error)
            }
        }
        return [:]
    }
}
