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
    let searchController = UISearchController(searchResultsController: nil)

    let slides = Variable<[Slide]>([])
    let searchResults = Variable<[Slide]>([])

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
        if searchController.isActive {
            try? realm.write {
                realm.delete(searchResults.value[index])
            }
            searchResults.value.remove(at: index)
        } else {
            try? realm.write {
                realm.delete(slides.value[index])
            }
            slides.value.remove(at: index)
        }
    }
    func indexOf(index: Int) -> Slide {
        if searchController.isActive {
            return searchResults.value[index]
        } else {
            return slides.value[index]
        }
    }
}
extension StockViewModel : UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.value.count
        } else {
            return slides.value.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! SlideCell
        if searchController.isActive {
            cell.configureCell(slide: searchResults.value[indexPath.row])
        } else {
            cell.configureCell(slide: slides.value[indexPath.row])
        }
        return cell
    }
}
extension StockViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResults.value = self.slides.value.filter {
            $0.title.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
    }
}
