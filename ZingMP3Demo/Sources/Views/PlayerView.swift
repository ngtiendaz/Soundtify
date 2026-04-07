import SwiftUI

struct PlayerView: View {
    var song: Songs
    @State private var progress: Double = 0.0
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isShowingLyricFull = false
    
    var body: some View {
        NavigationStack{
            ZStack (alignment: .top){
                BackGroundCustom(imageUrl: song.thumbnailM).ignoresSafeArea()
                ScrollView(showsIndicators: false){
//                    BackGroundCustom(imageUrl: song.thumbnailM)
                    VStack() {
                        TopBarPlayer(songName: song.title).padding(.bottom,70).padding(.horizontal,8)
                        Spacer()
                        ImageCustom(imageUrl: song.thumbnailM, width: 400, height: 400).padding(.bottom,30)
                        VStack(alignment: .leading, spacing: 18) {
                            SongInForPlayer(songName: song.title, artists: song.artists)
                            PlayBackControls(progress: $progress, viewModel: playerViewModel)
                        }
                        .padding(.horizontal, 25).padding(.bottom,8)
                        LyricMini().environmentObject(playerViewModel)
                    }
                }.ignoresSafeArea(edges: .top)
        }.navigationBarBackButtonHidden(true)
        }.toolbar(.hidden, for: .navigationBar)
    }
}


