//
//  Destination.swift
//  ZingMP3Demo
//
//  Created by Daz on 8/4/26.
//
import Foundation
import Combine


enum AppDestination: Hashable {
    case playlist(PlayLists)
    case artist(Artists)
    case favorites
}
