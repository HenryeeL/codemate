//
//  DiscussionView.swift
//

import UIKit

class DiscussionView: UIView {
    
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discussion"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Adding the icon for the title
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "rectangle.3.group.bubble"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Here"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        // Make sure the background is clear
        backgroundColor = .white
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(searchBar)
        addSubview(commentsTableView)
        addSubview(addButton)
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Icon Image Constraints (Adjusted size)
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8), // This will place the icon to the left of the titleLabel
            iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Aligns the icon vertically with the title
            iconImageView.widthAnchor.constraint(equalToConstant: 30),  // Adjust the size here
            iconImageView.heightAnchor.constraint(equalToConstant: 30), // Adjust the size here
            
            // Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Table View Constraints
            commentsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            // Add Button Constraints
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
