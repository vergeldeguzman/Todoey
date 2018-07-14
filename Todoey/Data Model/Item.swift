//
//  Item.swift
//  Todoey
//
//  Created by user140860 on 7/13/18.
//  Copyright © 2018 Vergel de Guzman. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
