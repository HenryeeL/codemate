//
//  EditProfileView.swift
//

import UIKit

class EditProfileView: UIView {

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile" // Title for Edit Profile screen
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let titleIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.text.rectangle.fill"))
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
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    let changePhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your username"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.textAlignment = .center
        return textField
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "RobotoSerif28ptCondensed-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Adding book icon under the username text field
    let bookIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "book"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
        addSubview(titleLabel)
        addSubview(titleIcon)  // Add title icon to the left of title
        addSubview(profileImageView)
        addSubview(changePhotoButton)
        addSubview(usernameTextField)
        addSubview(bookIcon)  // Add book icon
        // saveButton is commented out to avoid duplication
        // addSubview(saveButton)

        // Setup constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleIcon.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        bookIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title Icon Constraints (placed left of the title)
            titleIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -30), // Adjusted position
            titleIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Centered with title label
            titleIcon.widthAnchor.constraint(equalToConstant: 25),
            titleIcon.heightAnchor.constraint(equalToConstant: 25),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),

            // Change Photo Button
            changePhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -5),
            changePhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -5),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 40),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 40),

            // Username TextField
            usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Book Icon (placed below the username text field)
            bookIcon.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            bookIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookIcon.widthAnchor.constraint(equalToConstant: 50),  // Adjust size
            bookIcon.heightAnchor.constraint(equalToConstant: 50)  // Adjust size

            // Save Button constraints are commented out
            /*
            saveButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
            */
        ])
    }
}
