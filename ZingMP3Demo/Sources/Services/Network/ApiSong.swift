//
//  ApiSong.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//

import Foundation

struct ApiSong: Codable {
    
    static func fetchLinkSong(id: String) async -> LinkSong?{
        let url = "\(ApiBase.song)?id=\(id)"
        
        let response: BaseResponse<LinkSong>? = await ApiServices.shared.request(url: url)
        print(url)
        return  response?.data
    }
    static func fetchDetailSong(id: String) async -> Songs?{
        let url = "\(ApiBase.infosong)?id=\(id)"
        
        let response: BaseResponse<Songs>? = await ApiServices.shared.request(url: url)
        print(url)
        return  response?.data
    }
}
