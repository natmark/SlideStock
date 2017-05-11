//
//  SlideCell.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/11.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import PINRemoteImage
class SlideCell: UITableViewCell {
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var slideId: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(slide: Slide) {
        slideImageView.pin_setImage(from: URL(string: "https://speakerd.s3.amazonaws.com/presentations/\(slide.id)/slide_0.jpg"))
        titleLabel.text = slide.title
        authorLabel.text = slide.author
        slideId = slide.id
    }
}
