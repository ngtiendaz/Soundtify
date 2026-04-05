import SwiftUI

struct PlayerView: View {
    var song: Songs
    @State private var progress: Double = 0.0
    @EnvironmentObject var playerviewmodel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            ZStack {
                BackGroundCustom(imageUrl: song.thumbnailM)
                VStack(spacing: 30) {
                    TopBarPlayer(songName: song.title)
                    Spacer()
                    ImageCustom(imageUrl: song.thumbnailM, width: 400, height: 400)
                    VStack(alignment: .leading, spacing: 20) {
                        SongInForPlayer(songName: song.title, artists: song.artists)
                        PlayBackControls(progress: $progress, viewModel: playerviewmodel)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 30)
                }
        }.navigationBarBackButtonHidden(true)
    }
}


