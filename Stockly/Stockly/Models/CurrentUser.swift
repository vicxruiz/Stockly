//
//  CurrentUser.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    var name: String
    var phoneNumber: String
    var email: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.phoneNumber = dictionary["phone number"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
