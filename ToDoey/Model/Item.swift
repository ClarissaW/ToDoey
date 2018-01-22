//
//  File.swift
//  ToDoey
//
//  Created by Wang, Zewen on 2018-01-20.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import Foundation
class Item : Codable{//Encodable,Decodable
    var title: String = ""
    var done : Bool = false // the properties have to be standard data type
}
