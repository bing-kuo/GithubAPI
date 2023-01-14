//
//  FollowingViewModel.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/8.
//

import Foundation

class FollowingViewModel {
    var followingUpdatedClosure: (([UserCellModel]) -> Void)?

    private(set) var following: [UserCellModel] = [] {
        didSet {
            followingUpdatedClosure?(following)
        }
    }

    func fetchFollowing() {
        following = UserDefaultHelper.getObject(key: .followingUser, type: [UserCellModel].self) ?? []
    }
}

// MARK: - TableView Actions
extension FollowingViewModel {
    func cellForRowAt(_ indexPath: IndexPath) -> UserCellModel? {
        following[safe: indexPath.row]
    }

    func numberOfRowsInSection() -> Int {
        following.count
    }
}
