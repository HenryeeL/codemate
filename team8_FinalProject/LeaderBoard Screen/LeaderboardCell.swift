//
//  LeaderboardCell.swift
//

import UIKit

class LeaderboardCell: UITableViewCell {
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "crown.fill")
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4

        contentView.addSubview(crownImageView)
        contentView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            // Crown Icon
            crownImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            crownImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 30),
            crownImageView.heightAnchor.constraint(equalToConstant: 30),

            // Rank Label
            rankLabel.leadingAnchor.constraint(equalTo: crownImageView.trailingAnchor, constant: 10),
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),

            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Score Label
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(rank: Int, name: String, score: Int) {
        rankLabel.text = "\(rank)"
        nameLabel.text = name
        scoreLabel.text = "\(score) pts"

        // Highlight top three ranks
        switch rank {
        case 1:
            crownImageView.isHidden = false
            contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        case 2:
            crownImageView.isHidden = true
            contentView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        case 3:
            crownImageView.isHidden = true
            contentView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        default:
            crownImageView.isHidden = true
            contentView.backgroundColor = UIColor.white
        }
    }
}
