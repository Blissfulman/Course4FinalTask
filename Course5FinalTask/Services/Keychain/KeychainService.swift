//
//  KeychainService.swift
//  Course5FinalTask
//
//  Created by Evgeny Novgorodov on 06.03.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol KeychainServiceProtocol {
    func getToken() -> TokenModel?
    func saveToken(_ token: TokenModel) -> Bool
}

final class KeychainService: KeychainServiceProtocol {
    
    // MARK: - Properties
    
    private let serviceName = "Course5FinalTask"
    
    // MARK: - Public methods
    
    /// Получение данных с сохранённым паролем.
    func getToken() -> TokenModel? {
        guard let items = readAllItems(service: serviceName),
              let key = items.keys.first,
              let token = items[key]
        else {
            print("No keychain data")
            return nil
        }
        return TokenModel(token: token)
    }
    
    func saveToken(_ token: TokenModel) -> Bool {
        let tokenData = token.token.data(using: .utf8)
        
        if readToken(service: serviceName) != nil {
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = tokenData as AnyObject
            
            let query = keychainQuery(service: serviceName)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keychainQuery(service: serviceName)
        item[kSecValueData as String] = tokenData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        
        return status == noErr
    }
    
    // MARK: - Private methods
    
    private func keychainQuery(service: String) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = service as AnyObject
        
//        if let account = account {
            query[kSecAttrAccount as String] = "token" as AnyObject
//        }
        
        return query
    }

    private func readToken(service: String) -> String? {
        var query = keychainQuery(service: service)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String: AnyObject],
              let passwordData = item[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8)
        else {
            return nil
        }
        return password
    }
    
    private func readAllItems(service: String) -> [String: String]? {
        var query = keychainQuery(service: service)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        if status != noErr {
            return nil
        }
        
        guard let items = queryResult as? [[String: AnyObject]] else {
            return nil
        }
        var passwordItems = [String: String]()
        
        for (index, item) in items.enumerated() {
            guard let passwordData = item[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    continue
            }
            
            if let account = item[kSecAttrAccount as String] as? String {
                passwordItems[account] = password
                continue
            }
            
            let account = "Empty account \(index)"
            passwordItems[account] = password
        }
        return passwordItems
    }
}
