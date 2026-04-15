//
//  MenuBar.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house"
    case search = "magnifyingglass"
    case chat = "ellipsis.message.fill"
    case library = "music.note.square.stack.fill"
    case profile = "person.crop.circle"
  
    
    var title: String{
        switch self {
        case .home: return "Trang chủ"
        case .search: return "Tìm kiếm"
        case .chat: return "Đoạn chat"
        case .library: return "Thư viện"
        case .profile: return "Cá nhân"
        }
    }
}

struct BottomMenuBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                Button{
                    selectedTab = tab
                } label: {
                    VStack( spacing: 8){
                        Image(systemName: selectedTab == tab ? "\(tab.rawValue)" : tab.rawValue).font(.system(size: 28)).frame(height: 24)
                        Text(tab.title).font(.system(size: 10))
                    }.padding(.top, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(selectedTab == tab ? .white : .gray)
                }
            }
        }.padding(.top, 5)
            .background(Color.clear.opacity(0.93).ignoresSafeArea())
    }
}
