import SwiftUI

struct MainView: View {
    @StateObject var router = AppRouter()
    @StateObject var playerViewModel = PlayerViewModel()
    @StateObject var searchViewModel = SearchViewModel()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundApp.ignoresSafeArea()
            
            Group {
                switch router.selectedTab {
                case .home:
                    NavigationStack(path: $router.homePath) {
                        HomeView()
                            .navigationDestination(for: AppDestination.self) { destination in
                                buildDestinationView(destination)
                            }
                    }
                case .search:
                    NavigationStack(path: $router.searchPath) {
                        SearchView()
                            .navigationDestination(for: AppDestination.self) { destination in
                                buildDestinationView(destination)
                            }
                    }
                case .library:
                    NavigationStack(path: $router.libraryPath) {
                        LibraryView()
                            .navigationDestination(for: AppDestination.self) { destination in
                                buildDestinationView(destination)
                            }
                    }
                case .profile:
                    NavigationStack(path: $router.libraryPath) {
                        ProfileView().navigationDestination(for: AppDestination.self) { destination in
                            buildDestinationView(destination) }
                    }
                case .chat:
                    NavigationStack(path: $router.chatPath) {
                        ChatView().navigationDestination(for: AppDestination.self) { destination in
                            buildDestinationView(destination) }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, playerViewModel.selectedSong != nil ? 135 : 75)
            
            VStack(spacing: 0) {
                if let song = playerViewModel.selectedSong {
                    MiniPlayer(song: song)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                BottomMenuBar(selectedTab: $router.selectedTab)
            }
        }
        .environmentObject(router)
        .environmentObject(playerViewModel)
        .environmentObject(searchViewModel)
        .onChange(of: playerViewModel.artistToNavigate) { _, newValue in
            if let artist = newValue {
                playerViewModel.isShowingPlayer = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    router.push(.artist(artist))
                    playerViewModel.artistToNavigate = nil
                }
            }
        }
        .fullScreenCover(isPresented: $playerViewModel.isShowingPlayer) {
            playerDestination
        }
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    private func buildDestinationView(_ destination: AppDestination) -> some View {
        switch destination {
        case .playlist(let playlist):
            PlaylistView(playlist: playlist)
        case .artist(let artist):
            ArtistView(artist: artist)
                .onAppear { playerViewModel.currentViewingArtist = artist }
                .onDisappear { playerViewModel.currentViewingArtist = nil }
            
        case .favorites:
            FavoriteView()
        }
    }
        
        @ViewBuilder
        var playerDestination: some View {
            if let song = playerViewModel.selectedSong {
                PlayerView(song: song)
                    .environmentObject(playerViewModel)
                    .environmentObject(router)
                    .environmentObject(searchViewModel)
            }
        }
    }
