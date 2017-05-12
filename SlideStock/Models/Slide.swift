//
//  Slide.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RealmSwift

class Slide: Object {
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var id: String = ""
    dynamic var pdfURL: String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
