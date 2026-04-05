//
//  PlayListViewModel.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//
import Foundation
import Combine
import SwiftUI
class PlayListViewModel: ObservableObject {
    @Published var songs: [Songs] = []
    @Published var isLoading = false
    @Published var playlistColor: Color = Color.backgroundApp
    @Published var playlistDetail: PlayLists?
    
    func fetchSongs(playlistId: String) async {
        isLoading = true
        if let data = await ApiPlayList.detailPlayList(id: playlistId) {
            self.songs = data.song
            self.playlistDetail = data
        }
        isLoading = false
    }
    
    func updateColor(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data),
               let extractedColor = uiImage.averageColor {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        self.playlistColor = extractedColor
                    }
                }
            }
        }.resume()
    }
}
