//
//  Category.swift
//  ToDoey
//
//  Created by Wang, Zewen on 2018-01-23.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object{
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>() // [Item]() Array<Item>()
    
}
