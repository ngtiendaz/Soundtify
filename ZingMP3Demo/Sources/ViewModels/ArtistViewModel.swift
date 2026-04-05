//
//  ArtistViewModel.swift
//  ZingMP3Demo
//
//  Created by Daz on 2/4/26.
//
import Foundation
import Combine
class ArtistViewModel: ObservableObject {
    @MainActor
    @Published var songs: [Songs] = []
    @Published var isLoading = false
    
    func fetchArtistSongs(artistId: String) async {
        isLoading = true
        let fetchedSongs = await ApiArtist.getArtistSong(id: artistId)
        self.songs = fetchedSongs
        
        isLoading = false
    }
}
