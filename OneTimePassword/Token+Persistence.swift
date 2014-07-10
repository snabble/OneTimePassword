//
//  Token+Persistence.swift
//  OneTimePassword
//
//  Created by Matt Rubin on 7/9/14.
//  Copyright (c) 2014 Matt Rubin. All rights reserved.
//

extension Token {
    struct KeychainItem {
        let token: Token
        let keychainItemRef: NSData

        static func keychainItemForToken(token: Token) -> KeychainItem? {
            if let persistentRef = addKeychainItemWithURLAndSecret(token.url(), token.secret) {
                return KeychainItem(token: token, keychainItemRef: persistentRef)
            }
            return nil
        }

        static func keychainItemWithKeychainItemRef(keychainItemRef: NSData) -> KeychainItem? {
            if let result = keychainItemForPersistentRef(keychainItemRef) {
                return keychainItemWithDictionary(result)
            }
            return nil
        }

        static func keychainItemWithDictionary(keychainDictionary: NSDictionary) -> KeychainItem? {
            let urlData = keychainDictionary.objectForKey(_kSecAttrGeneric()) as? NSData
            let urlString: NSString? = NSString(data: urlData, encoding:NSUTF8StringEncoding)
            if let url = NSURL.URLWithString(urlString) {
                if let secret = keychainDictionary.objectForKey(_kSecValueData()) as? NSData {
                    if let keychainItemRef = keychainDictionary.objectForKey(_kSecValuePersistentRef()) as? NSData {
                        if let token = Token.tokenWithURL(url, secret: secret) {
                            return KeychainItem(token: token, keychainItemRef: keychainItemRef)
                        }
                    }
                }
            }
            return nil
        }

        static func allKeychainItems() -> Array<KeychainItem> {
            var items = Array<KeychainItem>()
            if let keychainItems = _allKeychainItems() {
                for item: AnyObject in keychainItems {
                    if let keychainDict = item as? NSDictionary {
                        if let keychainItem = keychainItemWithDictionary(keychainDict) {
                            items.append(keychainItem)
                        }
                    }
                }
            }
            return items
        }


        // After calling removeFromKeychain(), the KeychainItem's keychainItemRef is no longer valid, and the keychain item should be discarded
        func removeFromKeychain() -> Bool {
            return deleteKeychainItemForPersistentRef(self.keychainItemRef)
        }
    }
}
