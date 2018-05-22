//
//  KeychainStorageManger.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

class KeychainStorageManager{
    static func saveUserIDToKeychainStorage(selectedUserId:String, accountName:String){
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: accountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(selectedUserId)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    static func getUserIdFromKeychainStorage(accountName:String)-> String{
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: accountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        return ""
    }
}
