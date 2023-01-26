import Foundation
import UIKit

class TableStateView: UIView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .gray
        label.accessibilityIdentifier = "TableViewBackgroundTitle"
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tintColor = .gray
        button.setTitleColor(.gray, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    private var action: (() -> Void)?

    init(frame: CGRect, title: String, subtitle: String? = nil, image: UIImage? = nil, buttonTitle: String? = nil, action: (() -> Void)? = nil) {
        super.init(frame: frame)

        setupUI()

        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)

        titleLabel.text = title
        subtitleLabel.text = subtitle

        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.isHidden = (buttonTitle == nil)
        self.action = action
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(actionButton)

        stackView.setCustomSpacing(32, after: subtitleLabel)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        action?()
    }
}

extension UITableView {
    enum ViewState {
        case content
        case noDataFound
        case noInternet
        case serverError
        case unknown
    }

    func setState(_ state: ViewState, action: (() -> Void)? = nil) {
        let frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        switch state {
        case .content:
            backgroundView = nil
        case .noDataFound:
            backgroundView = TableStateView(frame: frame, title: "No Data Found", subtitle: "Please try different keywords.", image: UIImage(systemName: "xmark.bin"))
        case .noInternet:
            backgroundView = TableStateView(frame: frame, title: "No Internet Connection", subtitle: "Please check your connection and try again.", image: UIImage(systemName: "wifi.exclamationmark"), buttonTitle: "Try again", action: action)
        case .serverError:
            backgroundView = TableStateView(frame: frame, title: "Server Error", subtitle: "Please check your connection and try again.", image: UIImage(systemName: "exclamationmark.icloud"), buttonTitle: "Try again", action: action)
        case .unknown:
            backgroundView = TableStateView(frame: frame, title: "Something went wrong", subtitle: "Please try again.", image: UIImage(systemName: "cloud.heavyrain"), buttonTitle: "Try again", action: action)
        }
    }
}
