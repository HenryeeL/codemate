//
//  LandingView.swift
//

import UIKit

class LandingView: UIView {
    let landingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "landing_image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Join Now To KickStart Your Lesson"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Journey To Acing Technical Interviews Starts Here. Study On The Go, Anytime, Anywhere."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.0, blue: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(landingImageView)
        addSubview(welcomeLabel)
        addSubview(descriptionLabel)
        addSubview(signInButton)
        addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            // Image View
            landingImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            landingImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            landingImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            landingImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: landingImageView.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            // Sign In Button
            signInButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            signInButton.widthAnchor.constraint(equalToConstant: 120),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: signInButton.topAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),
            signUpButton.heightAnchor.constraint(equalTo: signInButton.heightAnchor)
        ])
    }
}
