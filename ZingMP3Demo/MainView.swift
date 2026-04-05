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
    @StateObject var viewModel = PlayerViewModel()
    @State private var navPath = NavigationPath()
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
                        .onAppear { viewModel.currentViewingArtist = artist }
                        .onDisappear { viewModel.currentViewingArtist = nil }
                        }
                    }
                case .search:
                    NavigationStack { SearchView() }
                case .library:
                    NavigationStack { Text("Library View").foregroundColor(.white) }
                case .profile:
                    NavigationStack { Text("Profile View").foregroundColor(.white) }
                case .add:
                    NavigationStack { Text("Add View").foregroundColor(.white) }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, viewModel.selectedSong != nil ? 130 : 70)
            VStack(spacing: 0){
                if let song = viewModel.selectedSong {
                    PlayerMini(song: song)
                    
                        .environmentObject(viewModel)
                }
                MenuBar(selectedTab: $selectedTab)
            }
        }.environmentObject(viewModel)
            .onChange(of: viewModel.artistToNavigate) { oldValue, newValue in
                        if let artist = newValue {
                            viewModel.isShowingPlayer = false // 1. Ẩn Player
                            navPath.append(artist)            // 2. Nhảy trang
                            viewModel.artistToNavigate = nil  // 3. Reset trigger
                        }
                    }
            .fullScreenCover(isPresented: $viewModel.isShowingPlayer) {
                if let song = viewModel.selectedSong {
                    PlayerView(song: song)
                        // QUAN TRỌNG: Phải truyền lại VM vào đây cho PlayerView dùng
                        .environmentObject(viewModel)
                }
            }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainView()
}
