//
//  HomeViewModel.swift
//  GithubAPI
//
//  Created by Bing Guo on 2022/12/20.
//

import Foundation
import UIKit

class HomeViewModel {
    // MARK: - Closures
    var userUpdatedClosure: (([UserCellModel]) -> Void)?
    var errorOccurredClosure: ((Error) -> Void)?

    // MARK: - Properties
    var keyword: String?
    
    private(set) var page: Int = 1
    private(set) var users: [UserCellModel] = [] {
        didSet {
            userUpdatedClosure?(users)
        }
    }
}

// MARK: - Search Actions
extension HomeViewModel {
    func cleanSearchResult() {
        keyword = nil
        users = []
    }

    func nextPage() {
        guard let keyword = keyword, !keyword.isEmpty else { return }
        page += 1
        fetchUserData(keyword: keyword, page: page) { [weak self] items in
            var cellModel = items.map { UserCellModel(user: $0, isFollowing: false) }
            self?.updateFollowingStatue(&cellModel)
            self?.users.append(contentsOf: cellModel)
        }
    }

    func searchUser() {
        guard let keyword = keyword, !keyword.isEmpty else { return }
        page = 1
        fetchUserData(keyword: keyword, page: 1) { [weak self] items in
            var cellModel = items.map { UserCellModel(user: $0, isFollowing: false) }
            self?.updateFollowingStatue(&cellModel)
            self?.users = cellModel
        }
    }

    func updateAllUserFollowingStatus() {
        updateFollowingStatue(&users)
    }

    private func updateFollowingStatue(_ models: inout [UserCellModel]) {
        let objects = UserDefaultHelper.getObject(key: .followingUser, type: [UserCellModel].self) ?? []
        let ids = objects.map(\.user.id)

        for (index, model) in models.enumerated() {
            models[index].isFollowing = ids.contains(model.user.id) ? true : false
        }
    }

    private func fetchUserData(keyword: String, page: Int, completion: @escaping ([GitHub.User]) -> ()) {
        NetworkingService.shared.fetchUsers(keyword: keyword, page: page) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    guard let items = response.items else {
                        self.users = []
                        if let message = response.message {
                            self.errorOccurredClosure?(NetworkingError.APIError(message))
                        } else {
                            self.errorOccurredClosure?(NetworkingError.unknown)
                        }
                        return
                    }

                    if items.count > 0 {
                        completion(items)
                    } else {
                        self.users = []
                        self.errorOccurredClosure?(NetworkingError.noDataFound)
                    }
                case let .failure(error):
                    self.users = []
                    self.errorOccurredClosure?(error)
                }
            }
        }
    }
}

// MARK: - TableView Actions
extension HomeViewModel {
    func cellForRowAt(_ indexPath: IndexPath) -> UserCellModel? {
        users[safe: indexPath.row]
    }

    func numberOfRowsInSection() -> Int {
        users.count
    }
}
