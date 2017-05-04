//
//  ImportViewController.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import PINRemoteImage

class ImportViewController: UIViewController {

    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideAuthorLabel: UILabel!
    @IBOutlet weak var importButton: UIButton!

    fileprivate let viewModel = ImportViewModel()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        URLTextField.attributedPlaceholder = NSAttributedString(string: "Input slide url here", attributes: [NSForegroundColorAttributeName:UIColor.white])
        bindViewState()
        bindUI()

    }
    fileprivate func bindViewState() {
        viewModel.componentsHidden
            .bind(onNext: {
                self.slideImageView.isHidden = $0
                self.slideTitleLabel.isHidden = $0
                self.byLabel.isHidden = $0
                self.slideAuthorLabel.isHidden = $0
                self.importButton.isHidden = $0
            })
            .addDisposableTo(disposeBag)

        viewModel.loading
            .bind { loading in
                // ここでこのloadingをindicatorViewなどのrx_animatingなどにbindする。
            }
            .addDisposableTo(disposeBag)

        viewModel.requestCompleted
            .bind { post in
                // 投稿が成功した時の処理を行う
            }
            .addDisposableTo(disposeBag)

        viewModel.error
            .bind { error in
                // 投稿の通信でerrorが出てしまった場合の処理を行う
            }
            .addDisposableTo(disposeBag)
    }
    fileprivate func bindUI() {
        URLTextField.rx.text
            .flatMap { $0.flatMap(Observable.just) ?? Observable.empty() }
            .bind(to: viewModel.urlString)
            .addDisposableTo(disposeBag)

        viewModel.thumbnailString
            .bind(onNext: {
                self.slideImageView.pin_setImage(from: URL(string: $0))
            })
            .addDisposableTo(disposeBag)

        viewModel.title
            .bind(onNext: {
                self.slideTitleLabel.text = $0
            })
            .addDisposableTo(disposeBag)

        viewModel.author
            .bind(onNext: {
                self.slideAuthorLabel.text = $0
            })
            .addDisposableTo(disposeBag)

        importButton.rx.tap
            .bind(to: viewModel.importTrigger)
            .addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ImportViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
