//
//  Message.swift
//  Operator
//
//  Created by Farini on 2/21/20.
//  Copyright © 2020 Farini. All rights reserved.
//

import Foundation

struct Message:Codable {
    
    var id:String
    var message:String
    var progress:Double?
    var state:String?
    
}
