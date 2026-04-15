//
//  UserProfileView.swift
//

import UIKit

class UserProfileView: UIView {

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile" // Display "Profile" as the title
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold) // Use system font with bold weight
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    // Adding the icon to the left of the title
    let titleIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.text.rectangle"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray // Placeholder background color for the profile image
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular) // Use system font with regular weight
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular) // Use system font with regular weight
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold) // Use system font with semibold weight
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.text = "Score: 0" // Default score value
        return label
    }()

    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold) // Use system font with semibold weight
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // Adding the hat image on top of the profile picture
    let hatImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hat"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Adding the Vector1 icon below score label
    let vector1Icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "flower")) // Assuming Vector1 is added in Assets
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Callback
    var onEditButtonTapped: (() -> Void)?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    private func setupViews() {
        backgroundColor = .white

        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor, // Start color with alpha for light blue
            UIColor.white.cgColor // End color (white)
        ]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0) // Add gradient as the background layer

        // Add subviews
        addSubview(titleIcon)  // Add title icon
        addSubview(titleLabel)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(emailLabel)
        addSubview(scoreLabel)
        addSubview(editButton)
        addSubview(vector1Icon)  // Add vector1 icon

        // Set constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleIcon.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        vector1Icon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title Icon Constraints
            titleIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -30), // Adjusted position
            titleIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Centered with title label
            titleIcon.widthAnchor.constraint(equalToConstant: 25),
            titleIcon.heightAnchor.constraint(equalToConstant: 25),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Edit Button Constraints
            editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Profile Image Constraints
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),

            // Username Label Constraints
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Email Label Constraints
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Score Label Constraints
            scoreLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Vector1 Icon Constraints (Placed below score label)
            vector1Icon.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            vector1Icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            vector1Icon.widthAnchor.constraint(equalToConstant: 30),  // Adjust size
            vector1Icon.heightAnchor.constraint(equalToConstant: 30)  // Adjust size
        ])
    }

    // MARK: - Setup Actions
    private func setupActions() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc private func editButtonTapped() {
        onEditButtonTapped?()
    }
}
