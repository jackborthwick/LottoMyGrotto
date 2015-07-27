//
//  Entries.swift
//  LottoMyGrotto
//
//  Created by Jack Borthwick on 7/8/15.
//  Copyright (c) 2015 Jack Borthwick. All rights reserved.
//

import UIKit
import Parse
@objc(Entries)
class Entries: PFObject, PFSubclassing  {
    @NSManaged var entryNumOne: String
    @NSManaged var entryNumTwo: String
    @NSManaged var entryNumThree: String
    @NSManaged var entryNumFour: String
    @NSManaged var entryNumFive: String
    @NSManaged var entryPowerball: String
    @NSManaged var winStatus: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Entries"
    }
}
