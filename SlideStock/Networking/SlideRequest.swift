//
//  SlideRequest.swift
//  SlideStock
//
//  Created by AtsuyaSato on 2017/05/03.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

protocol SlideRequest {
    static var baseURL: String { get }
    static func getHTML(path: String) throws -> Data
}
extension SlideRequest {
    static var baseURL: String {
        return "https://speakerdeck.com/"
    }
    static func getHTML(path: String) throws -> Data {
        return try Data(contentsOf: URL(string: baseURL + path)!)
    }
}
class FetchSlideRequest: SlideRequest {

}
