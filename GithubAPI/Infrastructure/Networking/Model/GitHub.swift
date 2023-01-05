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

        enum CodingKeys: String, CodingKey {
            case username = "login"
            case id
            case avatarURL = "avatar_url"
        }
    }

    struct Repo: Codable {
        let archived: Bool
        let description: String?
        let htmlURL: String
        let name: String
        let owner: Owner

        enum CodingKeys: String, CodingKey {
            case htmlURL = "html_url"
            case archived, description, name, owner
        }
    }

    struct Owner: Codable {
        let avatarURL: String
        let reposURL: String

        enum CodingKeys: String, CodingKey {
            case avatarURL = "avatar_url"
            case reposURL = "repos_url"
        }
    }
}
