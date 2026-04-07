//
//  SearchViewModel.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//
import Foundation
import Combine
class SearchViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var playlists: [PlayLists]?
    @Published var songs: [Songs]?
    @Published var artists: [Artists]?
    @Published var recentSearches: [String] = []
    @Published var recentSongs: [Songs] = []
    private let songHistoryKey = "recent_songs_history"
    private let storageKey = "recent_searches_key"
    
    private var searchTask: Task<Void, Never>? = nil
    
    
    init() {
        loadRecentSearches()
        loadRecentSongs()
    }
    @MainActor
    
    
    func searchWithDebounce(key: String) {
            searchTask?.cancel()
            
            let trimmedKey = key.trimmingCharacters(in: .whitespaces)
            guard !trimmedKey.isEmpty else {
                self.songs = nil
                self.playlists = nil
                self.artists = nil
                return
            }
            searchTask = Task {
              
                try? await Task.sleep(nanoseconds: 500_000_000)
                
                if Task.isCancelled { return }
                
                self.isLoading = true
                
                if let data = await ApiSearch.getSearch(keyword: trimmedKey) {
                    self.songs = data.songs
                    self.playlists = data.playlists
                    self.artists = data.artists
                    
                    if !Task.isCancelled {
//                        self.addToRecent(trimmedKey)
                    }
                }
                
                self.isLoading = false
            }
        }
    
     func addToRecent(_ query: String){
        if let index = recentSearches.firstIndex(of: query){
            recentSearches.remove(at: index)
        }
        
        recentSearches.insert(query, at: 0)
        
        if recentSearches.count > 10{
            recentSearches.removeLast()
        }
        
        saveToUserDefaults()
    }
    
    func removeRecent(at index: Int) {
            guard recentSearches.indices.contains(index) else { return }
            recentSearches.remove(at: index)
            saveToUserDefaults()
        }
    func clearAllRecent() {
            recentSearches.removeAll()
            saveToUserDefaults()
        }
    
    private func saveToUserDefaults() {
            UserDefaults.standard.set(recentSearches, forKey: storageKey)
        }
        
        private func loadRecentSearches() {
            self.recentSearches = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        }
    
    func saveSongToHistory(_ song: Songs) {
            // 1. Nếu bài hát đã có trong lịch sử thì xóa cái cũ đi để đưa lên đầu
            if let index = recentSongs.firstIndex(of: song) {
                recentSongs.remove(at: index)
            }
            
            // 2. Thêm bài mới vào đầu mảng
            recentSongs.insert(song, at: 0)
            
            // 3. Giới hạn danh sách (ví dụ chỉ lưu 15 bài gần nhất cho nhẹ)
            if recentSongs.count > 15 {
                recentSongs.removeLast()
            }
            
            // 4. Mã hóa và lưu vào bộ nhớ máy
            if let encoded = try? JSONEncoder().encode(recentSongs) {
                UserDefaults.standard.set(encoded, forKey: songHistoryKey)
            }
        }
    
    private func loadRecentSongs() {
            if let data = UserDefaults.standard.data(forKey: songHistoryKey),
               let decoded = try? JSONDecoder().decode([Songs].self, from: data) {
                DispatchQueue.main.async {
                    self.recentSongs = decoded
                }
            }
        }
}
