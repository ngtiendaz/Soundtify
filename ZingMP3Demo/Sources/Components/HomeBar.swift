//
//  HomeBar.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct HomeBar: View {
    var body: some View {
        HStack{
            Image("daz").resizable().frame(width: 40,height: 40).cornerRadius(30)
            Text("Home").font(.system(size:32,weight: .bold)).foregroundColor(.white)
            Spacer()
            Button(action: {
                
            }, label:{
                Image(systemName: "gearshape.fill").resizable().scaledToFill().frame(width: 30,height: 30).tint(.white)
            })
        }.padding(.horizontal,14)
    }
}
