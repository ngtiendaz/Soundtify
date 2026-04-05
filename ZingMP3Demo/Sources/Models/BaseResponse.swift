//
//  ResponseData.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation
struct BaseResponse<T: Codable> : Codable {
    let err: Int?
    let msg: String?
    let data: T?
    let timestamp: Int
    let url: String?
}
