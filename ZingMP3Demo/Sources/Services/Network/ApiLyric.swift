//
//  ApiLyric.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import Foundation

struct ApiLyric: Codable{
    
      static func getLyric(id: String) async -> Lyrics?{
          let url = "\(ApiBase.lyric)?id=\(id)"
          
          let response: BaseResponse<Lyrics>? = await ApiServices.shared.request(url: url)
          print(url)
          return  response?.data
      }
}
