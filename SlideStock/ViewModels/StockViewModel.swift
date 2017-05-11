//
//  StockViewModel.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class StockViewModel: NSObject {
    fileprivate let cellIdentifier = "slideCell"
    let slides = Variable<[Slide]>([])
    override init() {
        super.init()
    }
    func reloadData() {
        let realm = try! Realm()
        let results = realm.objects(Slide.self)
        print(results)
        self.slides.value = Array(results)
    }
    func removeAt(index: Int) {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(slides.value[index])
        }
        slides.value.remove(at: index)
    }
}
extension StockViewModel : UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slides.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! SlideCell
        cell.configureCell(slide: slides.value[indexPath.row])
        return cell
    }
}
