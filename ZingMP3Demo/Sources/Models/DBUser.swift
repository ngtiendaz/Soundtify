//
//  DBUser.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import Foundation

struct DBUser: Codable {
    let uid: String
    let email: String?
    let photoURL: String?
    let displayName: String?
}
