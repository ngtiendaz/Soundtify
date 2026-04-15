//
//  AppRouter.swift
//  ZingMP3Demo
//
//  Created by Daz on 8/4/26.
//
import Foundation
import Combine
import SwiftUI


class AppRouter: ObservableObject {
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var libraryPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    @Published var chatPath = NavigationPath()
    @Published var selectedTab: Tab = .home
    
    func push(_ destination: AppDestination) {
        switch selectedTab {
        case .home:
            homePath.append(destination)
        case .search:
            searchPath.append(destination)
        case .library:
            libraryPath.append(destination)
        case .profile:
            libraryPath.append(destination)
        case .chat:
            chatPath.append(destination)
        default:
            break
        }
    }
    
    func pop() {
        switch selectedTab {
        case .home:
            if !homePath.isEmpty { homePath.removeLast() }
        case .search:
            if !searchPath.isEmpty { searchPath.removeLast() }
        case .library:
            if !libraryPath.isEmpty { libraryPath.removeLast() }
        case .profile:
            if !profilePath.isEmpty { profilePath.removeLast() }
        case .chat:
            if !chatPath.isEmpty { chatPath.removeLast() }
        default:
            break
        }
    }
    
    func popToRoot() {
        switch selectedTab {
        case .home:
            homePath.removeLast(homePath.count)
        case .search:
            searchPath.removeLast(searchPath.count)
        case .library:
            libraryPath.removeLast(libraryPath.count)
        case .profile:
            profilePath.removeLast(profilePath.count)
        case .chat:
            chatPath.removeLast(chatPath.count)
        default:
            break
        }
    }
}
