//
//  UserCellModel.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/9.
//

import Foundation

class UserCellModel: Codable, Equatable {
    let user: GitHub.User
    var isFollowing: Bool

    init(user: GitHub.User, isFollowing: Bool) {
        self.user = user
        self.isFollowing = isFollowing
    }

    static func == (lhs: UserCellModel, rhs: UserCellModel) -> Bool {
        lhs.user.id == rhs.user.id
    }

    func follow() {
        var objects = UserDefaultHelper.getObject(key: .followingUser, type: [UserCellModel].self) ?? []

        if let index = objects.firstIndex(of: self) {
            objects[index] = self
        } else {
            objects.append(self)
        }

        UserDefaultHelper.saveObjects(key: .followingUser, objects: objects)
    }

    func unfollow() {
        var objects = UserDefaultHelper.getObject(key: .followingUser, type: [UserCellModel].self) ?? []

        if let index = objects.firstIndex(of: self) {
            objects.remove(at: index)
        }

        UserDefaultHelper.saveObjects(key: .followingUser, objects: objects)
    }
}
