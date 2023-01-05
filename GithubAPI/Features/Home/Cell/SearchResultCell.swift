import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    static let identifier = String(describing: self)

    // MARK: - Properties
    lazy var accountImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Constructors
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension SearchResultCell {
    func setupUI() {
        contentView.addSubview(accountImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            accountImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            accountImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            accountImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: accountImageView.trailingAnchor, constant: 5),
            accountImageView.widthAnchor.constraint(equalToConstant: 60),
            accountImageView.heightAnchor.constraint(equalToConstant: 60),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}
