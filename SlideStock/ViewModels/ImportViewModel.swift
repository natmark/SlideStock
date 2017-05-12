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
import RealmSwift

class ImportViewModel {
    init() {
        bindSearchRequest()
    }
    let error = PublishSubject<Error>()

    let urlString = PublishSubject<String>()
    let slideId = PublishSubject<String>()
    let slideTitle = PublishSubject<String>()
    let slideAuthor = PublishSubject<String>()
    let pdfURL = PublishSubject<String>()

    var loading: Observable<Bool> {
        return isLoading.asObservable()
    }

    var componentsHidden: Observable<Bool> {
        return Observable
            .combineLatest(slideTitle, slideAuthor, slideId) { slideTitle, slideAuthor, slideId -> Bool in
                return slideTitle.isEmpty || slideAuthor.isEmpty || slideId.isEmpty
            }
            .startWith(true)
    }
    var importSlide: Observable<Void> {
        return Observable
            .zip(slideTitle, slideAuthor, slideId, pdfURL, importTrigger) { slideTitle, slideAuthor, slideId, pdfURL, importTrigger -> Void in
                let slide = Slide()
                slide.title = slideTitle
                slide.author = slideAuthor
                slide.id = slideId
                slide.pdfURL = pdfURL
                let realm = try! Realm()
                try? realm.write {
                    realm.add(slide, update: true)
                }
        }
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
                    guard let title = details.css("h1").first?.innerHTML else {
                        return
                    }
                    guard let author = details.css("a").first?.innerHTML else {
                        return
                    }
                    guard let pdfURL = doc?.body?.css("#share_pdf").first?["href"] else {
                        return
                    }
                    guard let slidesContainer = doc?.body?.css("div#slides_container").first?.innerHTML else {
                        return
                    }
                    var ans: [String] = []
                    if !slidesContainer.pregMatche(pattern: "data-id=\"([a-z0-9]+)\"", matches: &ans) || ans.count < 2 {
                        return
                    }
                    let id = ans[1]

                    self.slideId.onNext(id)
                    self.slideAuthor.onNext(author)
                    self.slideTitle.onNext(title)
                    self.pdfURL.onNext(pdfURL)
                } catch {
                }
            })
            .addDisposableTo(disposeBag)
    }
}
