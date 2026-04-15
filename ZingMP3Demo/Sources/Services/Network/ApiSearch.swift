//
//  ApiSearch.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import Foundation

struct ApiSearch: Codable {
    
    
    static func getSearch(keyword: String) async -> SearchResult? {
        let url = "\(ApiBase.search)?keyword=\(keyword)"
        
        let response: BaseResponse<SearchResult>? = await ApiServices.shared.request(url: url)
        print(url)
        return response?.data
    }
}
