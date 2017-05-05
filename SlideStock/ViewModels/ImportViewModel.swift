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
                    //TODO: Kanna
                } catch {

                }
            })
            .addDisposableTo(disposeBag)
    }
}
