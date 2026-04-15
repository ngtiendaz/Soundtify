//
//  HomeView.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        ZStack{
                Color.backgroundApp.ignoresSafeArea()
                VStack(alignment: .leading){
                    TopBar(titleView: "Trang chủ",typeView: "home")
                    ScrollView(.vertical, showsIndicators: false)
                    {
                        if homeViewModel.isLoading{
                            VStack(alignment: .center){
                                Spacer()
                                ProgressView().tint(.white).controlSize(.large)
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            VStack(spacing: 20){
                                ForEach(Array(homeViewModel.sections.enumerated()), id: \.offset) { index, section in
                                    if let itemData = section.items {
                                        switch itemData {
                                        case .array(let list):
                                            if !list.isEmpty {
                                                SectionItem(
                                                    sectionTitle: section.title ?? "",
                                                    items: list)
                                            }
                                        case .object( _):
                                            VStack(alignment: .leading) {
                                                Text(section.title ?? "Mới phát hành")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Text("Dữ liệu dạng Object - Sẽ xử lý sau")
                                                    .foregroundColor(.gray)
                                            }.padding(.horizontal)
                                        case .unknown:
                                            EmptyView()
                                        }
                                    }
                                }
                            }.padding(.leading,10)
                        }
                    }
                    .refreshable {
                        await homeViewModel.refreshHome()
                    }
                }
                .task {
                    await homeViewModel.fetchHome()
                }
            
        }
    }
}
