//
//  Item.swift
//  ToDoey
//
//  Created by Wang, Zewen on 2018-01-23.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //linkingobjects represent 0 or more that are linked to its owning model object
    // category.self means the type of the object
    // items is the forwarded relation type
}
