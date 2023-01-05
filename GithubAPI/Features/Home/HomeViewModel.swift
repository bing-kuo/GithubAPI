//
//  HomeViewModel.swift
//  GithubAPI
//
//  Created by Bing Guo on 2022/12/20.
//

import Foundation

class HomeViewModel {
    // MARK: - Closures
    var userUpdatedClosure: (([GitHub.User]) -> Void)?
    var errorOccurredClosure: ((Error) -> Void)?
    var isLoadingClosure: ((Bool) -> Void)?

    // MARK: - Properties
    var keyword: String?
    private(set) var page: Int = 0
    private(set) var users: [GitHub.User] = [] {
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
            self?.users.append(contentsOf: items)
        }
    }

    func searchUser() {
        guard let keyword = keyword, !keyword.isEmpty else { return }
        page = 0
        fetchUserData(keyword: keyword, page: 0) { [weak self] items in
            self?.users = items
        }
    }

    private func fetchUserData(keyword: String, page: Int, completion: @escaping ([GitHub.User]) -> ()) {
        isLoadingClosure?(true)

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
                self.isLoadingClosure?(false)
            }
        }
    }
}

// MARK: - TableView Actions
extension HomeViewModel {
    func cellForRowAt(_ indexPath: IndexPath) -> GitHub.User? {
        users[safe: indexPath.row]
    }

    func numberOfRowsInSection() -> Int {
        users.count
    }
}
