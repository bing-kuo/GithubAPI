//
//  GitHub.swift
//  GithubAPI
//
//  Created by Bing Guo on 2022/12/20.
//

import Foundation

struct GitHub {
    struct UserResponse: Codable {
        let items: [User]?
        let message: String?
    }

    struct User: Codable {
        let id: Int
        let username: String
        let avatarURL: String
        let htmlURL: String

        enum CodingKeys: String, CodingKey {
            case username = "login"
            case id
            case avatarURL = "avatar_url"
            case htmlURL = "html_url"
        }
    }
}
