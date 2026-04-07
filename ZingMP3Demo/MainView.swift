//
//  ContentView.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    @State private var isShowingPlayer = false
    @State private var selectedSong: Songs?
    @StateObject var playViewModel = PlayerViewModel()
    @State private var navPath = NavigationPath()
    @StateObject var searchViewModel = SearchViewModel()
    init()
    {
        
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack(alignment: .bottom){
            Color.backgroundApp.ignoresSafeArea()
            Group{
                switch selectedTab {
                case .home:
                    NavigationStack(path: $navPath){
                        HomeView()
                        .navigationDestination(for: PlayLists.self) { playlist in
                        PlaylistDetail(playlist: playlist)
                         }
                        .navigationDestination(for: Artists.self) { artist in
                        ArtistDetail(artist: artist)
                        .onAppear { playViewModel.currentViewingArtist = artist }
                        .onDisappear { playViewModel.currentViewingArtist = nil }
                        }
                    }
                case .search:
                    NavigationStack (path: $navPath){
                        SearchView()
                        .navigationDestination(for: PlayLists.self) { playlist in
                        PlaylistDetail(playlist: playlist)
                         }
                        .navigationDestination(for: Artists.self) { artist in
                        ArtistDetail(artist: artist).environmentObject(playViewModel)
                        .onAppear { playViewModel.currentViewingArtist = artist }
                        .onDisappear { playViewModel.currentViewingArtist = nil }
                        }
                    }
                case .library:
                    NavigationStack { Text("Library View").foregroundColor(.white) }
                case .profile:
                    NavigationStack { Text("Profile View").foregroundColor(.white) }
                case .add:
                    NavigationStack { Text("Add View").foregroundColor(.white) }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, playViewModel.selectedSong != nil ? 130 : 70)
            VStack(spacing: 0){
                if let song = playViewModel.selectedSong {
                    PlayerMini(song: song)
                    
                        .environmentObject(playViewModel)
                }
                MenuBar(selectedTab: $selectedTab)
            }
        }.environmentObject(playViewModel)
            .environmentObject(searchViewModel)
            .onChange(of: playViewModel.artistToNavigate) { oldValue, newValue in
                        if let artist = newValue {
                            playViewModel.isShowingPlayer = false // 1. Ẩn Player
                            navPath.append(artist)            // 2. Nhảy trang
                            playViewModel.artistToNavigate = nil  // 3. Reset trigger
                        }
                    }
            .fullScreenCover(isPresented: $playViewModel.isShowingPlayer) {
                if let song = playViewModel.selectedSong {
                    PlayerView(song: song)
                        // QUAN TRỌNG: Phải truyền lại VM vào đây cho PlayerView dùng
                        .environmentObject(playViewModel)
                        .environmentObject(searchViewModel)
                }
            }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainView().environmentObject(AuthManager.shared)
}
