import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = String(describing: UserTableViewCell.self)

    // MARK: - Properties
    var model: UserCellModel?

    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = .lightGray
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        let unlikeImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let likeImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(unlikeImage, for: .normal)
        button.setImage(likeImage, for: .selected)
        button.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Constructors
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    func config(model: UserCellModel, cache: ImageCache) {
        self.model = model

        nameLabel.text = model.user.username
        if let url = URL(string: model.user.avatarURL) {
            avatarImageView.setImage(url: url, cache: cache)
        }
        setFollowButton(model.isFollowing)
    }

    @objc func followButtonTapped(_ sender: UIButton) {
        guard let model = model else { return }

        model.isFollowing.toggle()
        followButton.isSelected.toggle()
        setFollowButton(model.isFollowing)

        if model.isFollowing {
            model.follow()
        } else {
            model.unfollow()
        }
    }
}

// MARK: - Setup UI
private extension UserTableViewCell {
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(followButton)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            followButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            followButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 44),
            followButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }

    func setFollowButton(_ isFollowing: Bool) {
        followButton.isSelected = isFollowing
        followButton.tintColor = isFollowing ? .secondary : .gray
        followButton.backgroundColor = isFollowing ? .secondary.lighter() : .gray.lighter()
    }
}
