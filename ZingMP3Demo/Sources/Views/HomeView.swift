//
//  HomeView.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        ZStack{
                Color.backgroundApp.ignoresSafeArea()
                VStack(alignment: .leading){
                    HomeBar()
                    ScrollView(.vertical, showsIndicators: false)
                    {
                        if viewModel.isLoading{
                            ProgressView().tint(.white)
                        } else {
                            VStack(spacing: 20){
                                ForEach(Array(viewModel.sections.enumerated()), id: \.offset) { index, section in
                                    if let itemData = section.items {
                                        switch itemData {
                                        case .array(let list):
                                            if !list.isEmpty {
                                                SectionView(
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
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refreshHome()
                    }
                }.padding(.leading,10)
                .task {
                    await viewModel.fetchHome()
                }
            
        }
    }
}
