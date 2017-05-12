//
//  StockViewController.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/04/30.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift

class StockViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate let viewModel = StockViewModel()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = viewModel

        self.definesPresentationContext = true
        viewModel.searchController.searchResultsUpdater = viewModel
        viewModel.searchController.searchBar.sizeToFit()
        viewModel.searchController.dimsBackgroundDuringPresentation = false
        viewModel.searchController.hidesNavigationBarDuringPresentation = true
        viewModel.searchController.searchBar.barStyle = .black
        tableView.tableHeaderView = viewModel.searchController.searchBar
        bindUI()
    }
    func bindUI() {
        viewModel.slides.asObservable().bind(onNext: { _ in
            self.tableView.reloadData()
        })
            .addDisposableTo(disposeBag)
        viewModel.searchResults.asObservable().bind(onNext: { _ in
            self.tableView.reloadData()
        })
            .addDisposableTo(disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension StockViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) -> Void in
            tableView.isEditing = false

            tableView.beginUpdates()
            tableView.deleteRows(at: [index], with: .automatic)
            self.viewModel.removeAt(index: index.row)
            tableView.endUpdates()
        }
        return [myDeleteButton]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.searchController.resignFirstResponder()
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SlideViewController") as! SlideViewController
        viewController.slide = viewModel.indexOf(index: indexPath.row)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
extension StockViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.viewWillAppear(animated)
    }
}
