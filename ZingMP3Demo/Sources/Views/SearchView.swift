//
//  Sr.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @StateObject var searchViewModel = SearchViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            Color.backgroundApp.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10){
                TopBar(titleView: "Tìm kiếm", typeView: "search")
                
    
                SearchBarCustom(text: $searchText, onSearch: {
                    searchViewModel.addToRecent(searchText)
                })
                .padding(.top)
                .onChange(of: searchText) { oldValue, newValue in
                    searchViewModel.searchWithDebounce(key: newValue)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if searchText.isEmpty {
                            renderRecentSearches
                        }
                        else {
                            renderSearchResults
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // --- Giao diện Lịch sử tìm kiếm ---
    private var renderRecentSearches: some View {
        VStack(alignment: .leading, spacing: 15) {
            if !searchViewModel.recentSearches.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Nội dung tìm kiếm gần đây")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Button("Xóa tất cả") {
                                    searchViewModel.clearAllRecent()
                                }
                                .font(.subheadline)
                                .foregroundColor(.green)
                            }
                            
                            // Hiển thị dạng thẻ (Chips)
                            FlowLayout(items: Array(searchViewModel.recentSearches.prefix(8))) { word in
                                Text(word)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        self.searchText = word
                                    }
                            }.frame(maxHeight: 95, alignment: .top) // ÉP CHIỀU CAO CHO 2 DÒNG
                                .clipped()
                        }
                    }
                    if !searchViewModel.recentSongs.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Nghe gần đây")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // Sửa từ songs sang viewModel.recentSongs
                            ForEach(searchViewModel.recentSongs.prefix(10), id: \.encodeId) { song in
                                Button {
                                    playerViewModel.play(song: song, from: searchViewModel.recentSongs)
                                } label: {
                                    HorizSongItem(
                                        encodeId: song.encodeId,
                                        imageUrl: song.thumbnailM ?? "",
                                        songName: song.title,
                                        artistName: song.artistsNames ?? ""
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.top)
    }
    
    private var renderSearchResults: some View {
        Group {
            if searchViewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity).padding()
            }
            
            // Nghệ sĩ
            if let artists = searchViewModel.artists, !artists.isEmpty {
                Text("Nghệ sĩ").font(.title3.bold()).foregroundColor(.white)
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack{
                        ForEach(artists, id:\.id){ artist in
                            Button {
                                searchViewModel.addToRecent(searchText)
                                playerViewModel.triggerNavigation(to: artist)
                                playerViewModel.isShowingPlayer = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    playerViewModel.selectedArtist = artist
                                }
                            } label: {
                                ArtistItem(id: artist.id, imageUrl: artist.thumbnail, title: artist.name)
                            }
                        }
                    }
                }
            }
            
            // Bài hát
            if let songs = searchViewModel.songs, !songs.isEmpty {
                Text("Bài hát").font(.title3.bold()).foregroundColor(.white)
                ForEach(songs, id:\.encodeId){ song in
                    Button {
                        searchViewModel.addToRecent(searchText)
                        searchViewModel.saveSongToHistory(song)
                        playerViewModel.play(song: song, from: searchViewModel.songs ?? [])
                    } label: {
                        HorizSongItem(encodeId: song.encodeId, imageUrl: song.thumbnailM, songName: song.title, artistName: song.artistsNames)
                    }
                }
            }
            
            // Playlists
            if let playlists = searchViewModel.playlists, !playlists.isEmpty {
                Text("PlayList").font(.title3.bold()).foregroundColor(.white)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(playlists, id:\.universalId){ playlist in
                            NavigationLink {
                                PlaylistDetail(playlist: playlist).environmentObject(searchViewModel)
                                    .onAppear { searchViewModel.addToRecent(searchText)
                                }
                            } label: {
                                VertiPlaylitsItem(imageUrl: playlist.thumbnail, title: playlist.title)
                            }
                        }
                    }
                }
            }
        }
    }
}

// Helper để tự động xuống dòng các từ khóa search (Giống ZingMP3)
struct FlowLayout<Content: View>: View {
    let items: [String]
    let content: (String) -> Content
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .padding(.all, 4)
                        .alignmentGuide(.leading) { d in
                            if (abs(width - d.width) > geo.size.width) {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == items.last {
                                width = 0 // reset
                            } else {
                                width -= d.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { d in
                            let result = height
                            if item == items.last {
                                height = 0 // reset
                            }
                            return result
                        }
                }
            }
        }
        .frame(minHeight: 100) // Tùy chỉnh độ cao vùng hiển thị
    }
}
