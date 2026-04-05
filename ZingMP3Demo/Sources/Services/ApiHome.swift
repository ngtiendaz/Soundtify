//
//  ApiHome.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//


import Foundation

struct ApiHome: Codable {
    
    
    static func getHome() async -> Home? {
        let url = "\(ApiBase.home)"
        
        let response: BaseResponse<Home>? = await ApiServices.shared.request(url: url)
        print(url)
        return response?.data
    }
}
