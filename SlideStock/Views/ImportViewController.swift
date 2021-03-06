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
import MBProgressHUD

class ImportViewController: UIViewController {

    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideAuthorLabel: UILabel!
    @IBOutlet weak var importButton: UIButton!

    fileprivate let viewModel = ImportViewModel()
    fileprivate let disposeBag = DisposeBag()
    fileprivate var progressHUD: MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = MBProgressHUD(view: self.view)
        self.view.addSubview(progressHUD!)

        // Do any additional setup after loading the view.
        URLTextField.attributedPlaceholder = NSAttributedString(string: "Input slide url here", attributes: [NSForegroundColorAttributeName:UIColor.white])
        bindViewState()
        bindUI()

    }
    fileprivate func bindViewState() {
        viewModel.componentsHidden
            .observeOn(MainScheduler.instance)
            .bind(onNext: {
                self.slideImageView.isHidden = $0
                self.slideTitleLabel.isHidden = $0
                self.byLabel.isHidden = $0
                self.slideAuthorLabel.isHidden = $0
                self.importButton.isHidden = $0
                self.progressHUD?.hide(animated: true)
            })
            .addDisposableTo(disposeBag)

        viewModel.loading
            .bind { loading in
            }
            .addDisposableTo(disposeBag)

        viewModel.requestCompleted
            .bind { post in
            }
            .addDisposableTo(disposeBag)

        viewModel.error
            .bind { error in
            }
            .addDisposableTo(disposeBag)
    }
    fileprivate func bindUI() {
        URLTextField.rx.controlEvent([.editingDidEnd])
            .flatMap({
                self.URLTextField.text.flatMap(Observable.just) ?? Observable.empty()
            })
            .bind(to: viewModel.urlString)
            .addDisposableTo(disposeBag)

        viewModel.slideId
            .bind(onNext: {
                self.slideImageView.pin_setImage(from: URL(string: "https://speakerd.s3.amazonaws.com/presentations/\($0)/slide_0.jpg"))
            })
            .addDisposableTo(disposeBag)

        viewModel.slideTitle
            .observeOn(MainScheduler.instance)
            .bind(onNext: {
                self.slideTitleLabel.text = $0
            })
            .addDisposableTo(disposeBag)

        viewModel.slideAuthor
            .observeOn(MainScheduler.instance)
            .bind(onNext: {
                self.slideAuthorLabel.text = $0
            })
            .addDisposableTo(disposeBag)

        importButton.rx.tap
            .bind(to: viewModel.importTrigger)
            .addDisposableTo(disposeBag)

        viewModel.importSlide
            .bind(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
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
        self.progressHUD?.show(animated: true)
        return true
    }
}
