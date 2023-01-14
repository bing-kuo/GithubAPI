//
//  FollowingViewController.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/8.
//

import UIKit
import SafariServices

class FollowingViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: FollowingViewModel
    private let imageCache = ImageCache()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(updateFollowing), for: .valueChanged)
        return control
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "HomeTableView"
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Constructors
    init(viewModel: FollowingViewModel = FollowingViewModel()) {
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
        viewModel.fetchFollowing()
    }
}

// MARK: - Binding
private extension FollowingViewController {
    func bindViewModel() {
        viewModel.followingUpdatedClosure = { [weak self] _ in
            guard let self = self else { return }

            self.tableView.setState(.content)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Actions
private extension FollowingViewController {
    @objc func updateFollowing() {
        viewModel.fetchFollowing()
    }
}

// MARK: - Setup UI
private extension FollowingViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = "Follwing"

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FollowingViewController: UITableViewDataSource, UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let data = viewModel.cellForRowAt(indexPath),
            let url = URL(string: data.user.htmlURL)
        else { return }

        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}
