//
//  ApiPlayList.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//

import Foundation

struct ApiPlayList: Codable {
  
    static func detailPlayList(id: String) async -> PlayLists?{
        let url = "\(ApiBase.detailPlayList)?id=\(id)"
        
        let response: BaseResponse<PlayLists>? = await ApiServices.shared.request(url: url)
        print(url)
        return  response?.data
    }
    
}
