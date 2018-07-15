//
//  Category.swift
//  Todoey
//
//  Created by user140860 on 7/13/18.
//  Copyright © 2018 Vergel de Guzman. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
