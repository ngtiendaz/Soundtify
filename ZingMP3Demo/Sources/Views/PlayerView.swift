import SwiftUI

struct PlayerView: View {
    var song: Songs
    @State private var progress: Double = 0.0
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isShowingLyricFull = false
    
    @State private var showingCommentSheet = false

    
    var body: some View {
            ZStack (alignment: .top){
                BackGroundCustom(imageUrl: song.thumbnailM).ignoresSafeArea()
                ScrollView(showsIndicators: false){
//                    BackGroundCustom(imageUrl: song.thumbnailM)
                    VStack() {
                        TopBarPlayer(songName: song.title).padding(.bottom,70).padding(.horizontal,8)
                        Spacer()
                        ImageCustom(imageUrl: song.thumbnailM, width: 400, height: 400).padding(.bottom,30)
                        VStack(alignment: .leading, spacing: 18) {
                            SongInForPlayer(song: song, showComment: $showingCommentSheet)
                            PlayBackControls(progress: $progress, viewModel: playerViewModel)
                        }
                        .padding(.horizontal, 25).padding(.bottom,8)
                        MiniLyric().environmentObject(playerViewModel)
                    }
                }.ignoresSafeArea(edges: .top)
        }.navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $playerViewModel.isShowingLyricFull)
        {
            LyricView().environmentObject(playerViewModel)
        }
        .sheet(isPresented: $showingCommentSheet) {
                    // Nội dung hiển thị bên trong sheet
                    CommentSheetView(song: song)
                        // 4. ĐÂY LÀ DÒNG QUAN TRỌNG NHẤT (iOS 16+)
                        // Giúp sheet chỉ dài bằng một nửa màn hình (medium detent)
                        .presentationDetents([.medium, .large])
                        // .medium: Nửa màn hình, .large: Cả màn hình (có thể vuốt lên)
                        
                        // Option: Thêm một chút góc bo tròn cho sheet
                        .presentationCornerRadius(20)
                        // Option: Hiện thanh gạch ngang để user biết có thể vuốt
                        .presentationDragIndicator(.visible)
                }
    }
}


