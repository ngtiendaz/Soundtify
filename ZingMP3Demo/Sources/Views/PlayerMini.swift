import SwiftUI
struct PlayerMini: View {
    var song: Songs
    @EnvironmentObject var playerviewmodel: PlayerViewModel
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // 1. ẢNH ALBUM
                ImageCustom(imageUrl: song.thumbnailM, width: 45, height: 45)
                    .cornerRadius(6)
                    .padding(.vertical, 8)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(song.artistsNames ?? "Unknown Artist")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // 3. NÚT ĐIỀU KHIỂN
                Button(action: {
                    playerviewmodel.togglePlayPause()
                }) {
                    Image(systemName: playerviewmodel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 12)
            
            Spacer(minLength: 0)
            
            SliderCustom(
                viewModel: playerviewmodel,
                height: 2,
                heightFrame: 2,
                showThumb: false,
                accentColor: .white
            )
            .padding(.horizontal, 2)
        }
        .frame(height: 64)
        .background(ZStack {
            playerviewmodel.miniBarColor
            Color.black.opacity(0.2)
        })
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .onAppear {
                    if let url = song.thumbnailM {
                        playerviewmodel.updateMiniColor(from: url)
                    }
                }
        // Theo dõi encodeId (là String) thay vì cả object song
        .onChange(of: song.encodeId) { newId in
            if let url = song.thumbnailM {
                playerviewmodel.updateMiniColor(from: url)
            }
        }
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Chỉ cho phép kéo lên (y âm)
                    if value.translation.height < 0 {
                        self.offset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -50 {
                        playerviewmodel.isShowingPlayer = true
                    }
                    // Reset lại vị trí mini player sau khi thả tay
                    withAnimation(.interactiveSpring()) {
                        self.offset = 0
                    }
                }
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                playerviewmodel.isShowingPlayer = true
            }
        }
    }
}
