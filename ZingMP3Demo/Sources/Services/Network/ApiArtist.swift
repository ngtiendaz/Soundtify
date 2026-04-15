//
//  ApiArtists.swift
//  ZingMP3Demo
//
//  Created by Daz on 2/4/26.
//

import Foundation

struct ApiArtist {
    static func getArtistSong(id: String) async -> [Songs] {
        let url = "\(ApiBase.artistsong)?id=\(id)&page=1&count=100"
        
        // Sửa lại kiểu dữ liệu trả về ở đây
        let response: BaseResponse<ArtistSongResponse>? = await ApiServices.shared.request(url: url)
        
        print("Fetching songs for artist URL: \(url)")
        
        return response?.data?.items ?? []
    }
}
