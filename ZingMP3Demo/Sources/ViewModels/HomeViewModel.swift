//
//  HomeController.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation
import Combine

@MainActor

class HomeViewModel: ObservableObject{
    @Published var sections: [HomeSections] = []
    @Published var isLoading = false
    @Published var hasLoaded: Bool = false
    
    func fetchHome() async {
        guard !hasLoaded else { return }
        isLoading = true
        
        if let data = await ApiHome.getHome(){
            self.sections = data.items!
        }
        isLoading = false
        DispatchQueue.main.async {
            self.hasLoaded = true
            self.isLoading = false
        }
    }
    func refreshHome() async {
        hasLoaded = false
        await fetchHome()
    }
}
