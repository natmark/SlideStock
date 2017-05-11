//
//  SlideViewController.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var slide = Slide()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.loadRequest(URLRequest(url: URL(string: "")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
