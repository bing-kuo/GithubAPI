//
//  ViewController.swift
//  GithubAPI
//
//  Created by Bing Guo on 2022/12/20.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: HomeViewModel
    private let imageCache = ImageCache()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Search username"
        controller.searchBar.returnKeyType = .search
        controller.searchBar.delegate = self
        return controller
    }()
    private lazy var searchBar = {
        searchController.searchBar
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "HomeTableView"
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Constructors
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupUI()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateAllUserFollowingStatus()
        tableView.reloadData()
    }
}

// MARK: - Binding
private extension HomeViewController {
    func bindViewModel() {
        viewModel.userUpdatedClosure = { [weak self] _ in
            guard let self = self else { return }

            self.tableView.setState(.content)
            self.tableView.reloadData()
        }

        viewModel.errorOccurredClosure = { [weak self] error in
            guard let self = self else { return }

            switch (error as? NetworkingError) {
            case .noDataFound:
                self.tableView.setState(.noDataFound)
            case .APIError:
                self.tableView.setState(.serverError)
            case .unknown:
                self.tableView.setState(.unknown) {
                    self.viewModel.searchUser()
                }
            case .none:
                break
            }
        }
    }
}

// MARK: - Setup UI
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        title = "GitHub"

        view.addSubview(tableView)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        footerView.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
        ])

        tableView.tableFooterView = footerView
    }

    @objc func closeKeyboard() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell,
            let data = viewModel.cellForRowAt(indexPath)
        else {
            return UITableViewCell()
        }

        cell.config(model: data, cache: imageCache)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.users.count - 1 {
            viewModel.nextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let data = viewModel.cellForRowAt(indexPath),
            let url = URL(string: data.user.htmlURL)
        else { return }

        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}

// MARK: - UISearchBar
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.keyword = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchUser()
        closeKeyboard()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cleanSearchResult()
    }
}
