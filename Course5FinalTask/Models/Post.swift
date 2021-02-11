//
//  Post.swift
//  Course5FinalTask
//
//  Created by Evgeny Novgorodov on 30.11.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: String
    let description: String
    let image: URL
    let createdTime: Date
    let currentUserLikesThisPost: Bool
    let likedByCount: Int
    let author: String
    let authorUsername: String
    let authorAvatar: URL
}

struct PostIDRequest: Encodable {
    let postID: String
}

struct NewPostRequest: Encodable {
    let image: String
    let description: String
}