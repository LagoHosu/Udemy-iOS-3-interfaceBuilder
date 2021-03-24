//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Lago on 2021/02/08.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

struct K {
    //through 'static', it doesn't need to 초기화 
    static let appName =  "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
