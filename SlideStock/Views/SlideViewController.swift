//
//  SlideViewController.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import KYNavigationProgress

class SlideViewController: UIViewController {
    var slide = Slide()
    fileprivate let WKView = WKWebView()
    fileprivate let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.progressTintColor = UIColor.red
        self.navigationItem.title = slide.title

        self.view = self.WKView
        self.WKView.navigationDelegate = self
        guard let url = URL(string: slide.pdfURL) else {
            return
        }
        self.WKView.load(URLRequest(url: url))
        bindUI()
    }
    func bindUI() {
        self.WKView.rx.estimatedProgress.bind(onNext: {
            // self.progressView.progress = Float($0)
            self.navigationController?.setProgress(Float($0), animated: false)
        })
        .addDisposableTo(disposeBag)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.cancelProgress()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SlideViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationController?.finishProgress()
    }
}
