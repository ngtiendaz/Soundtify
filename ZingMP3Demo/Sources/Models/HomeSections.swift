//
//  HomeSections.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//
import Foundation

enum sectionType: String
{
    case quickPlay = "quickPlay"
    case songStation = "songStation"
    case recentPlaylist = "recentPlaylist"
    case playlist = "playlist"
    case adBanner = "adBanner"
    case newRelease = "new-release"
    case newReleaseChart = "newReleaseChart"
    case RTChart = "RTChart"
}

struct HomeSections: Codable {
    let sectionId: String?
    let sectionType: String
    let title: String?
    let viewType: String?
    let items: HomeItemData?
    
}
