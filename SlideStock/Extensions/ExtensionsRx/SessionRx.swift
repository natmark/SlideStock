//
//  SessionRx.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer.on(.next(res))
                    observer.on(.completed)
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }

    class func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
