//
//  Category.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 19..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
