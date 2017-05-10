//
//  ImportViewModel.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kanna

class ImportViewModel {
    init() {
        bindSearchRequest()
    }
    let error = PublishSubject<Error>()

    let urlString = PublishSubject<String>()
    let thumbnailString = PublishSubject<String>()
    let title = PublishSubject<String>()
    let author = PublishSubject<String>()

    var loading: Observable<Bool> {
        return isLoading.asObservable()
    }

    var componentsHidden: Observable<Bool> {
        return Observable
            .combineLatest(title, author, thumbnailString) { title, author, thumbnailString -> Bool in
                return !title.isEmpty && !author.isEmpty && !thumbnailString.isEmpty
            }
            .startWith(true)
    }

    fileprivate let disposeBag = DisposeBag()
    fileprivate let isLoading: Variable<Bool> = Variable(false)

    let importTrigger = PublishSubject<Void>()
    let requestCompleted = PublishSubject<Slide>()

    fileprivate func bindSearchRequest() {
        urlString
            .subscribe(onNext: { path in
                do {
                    print(path)
                    let data = try FetchSlideRequest.getHTML(path: path)
                    let doc = HTML(html: data, encoding: String.Encoding.utf8)
                    guard let details = doc?.body?.css("div#talk-details").first else {
                        return
                    }
                    guard let slideName = details.css("h1").first?.innerHTML else {
                        return
                    }
                    guard let author = details.css("a").first?.innerHTML else {
                        return
                    }
                    guard let slidesContainer = doc?.body?.css("div#slides_container").first?.innerHTML else {
                        return
                    }
                    var ans: [String] = []
                    if !slidesContainer.pregMatche(pattern: "data-id=\"([a-z0-9]+)\"", matches: &ans) || ans.count < 2 {
                        return
                    }
                    let slideId = ans[1]

                    print(slideName)
                    print(author)
                    print(slideId)
                } catch {

                }
            })
            .addDisposableTo(disposeBag)
    }
}
