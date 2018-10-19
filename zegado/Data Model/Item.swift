//
//  Item.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 19..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
