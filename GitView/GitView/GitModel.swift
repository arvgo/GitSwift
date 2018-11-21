//
//  GitModel.swift
//  GitView
//
//  Created by RAG on 21/11/2018.
//  Copyright © 2018 RAG. All rights reserved.
//

import Foundation

// Get the following from the Github JSON
// - Commit title —> commit.message
// - Author Image —> author.avatar_url
// - Author name —> commit.author.name
// - Time —> commit.author.date
struct  GitList: Decodable {
    let commit: GitCommit
    let author: GitListAuthor
    
    enum CodingKeys: String, CodingKey {
        case commit
        case author
    }
}

struct GitListAuthor: Decodable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}

struct GitCommit: Decodable {
    let author: GitCommitAuthor
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case message
    }
}

struct GitCommitAuthor: Decodable {
    let name: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
    }
}
