//
//  Storage.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/7/16.
//  Copyright © 2016 Daniel Hauagge. All rights reserved.
//

import Foundation
import RealmSwift

class Account : Object {
    dynamic var username = ""
    dynamic var password  = ""
    override class func primaryKey() -> String? {
        return "username"
    }
}

class LoginedUser : Object {
    dynamic var username = ""
    override class func primaryKey() -> String? {
        return "username"
    }
}

// compoundKey: https://github.com/realm/realm-cocoa/issues/1192
class Record : Object {
    dynamic var username = ""
    dynamic var time = 0.0
    dynamic var score  = 0
    dynamic var compoundKey = ""
    override class func primaryKey() -> String? {
        return "compoundKey"
    }
    func setCompoundKeyValue() {
        compoundKey = "\(username)-\(time)"
    }
}