import UIKit

class LeaderboardView: UIView {
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0.0, 0.5, 1.0]
        return gradient
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Leaderboard"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let leaderboardTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.9)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(containerView)
        containerView.layer.insertSublayer(gradientLayer, at: 0)

        containerView.addSubview(titleLabel)
        containerView.addSubview(leaderboardTableView)

        NSLayoutConstraint.activate([
            // ContainerView for safe area
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // Leaderboard TableView
            leaderboardTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            leaderboardTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            leaderboardTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            leaderboardTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
}
