//
//  Category.swift
//  Todoey
//
//  Created by Anand Agrawal on 11/03/18.
//  Copyright © 2018 Anand Agrawal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
