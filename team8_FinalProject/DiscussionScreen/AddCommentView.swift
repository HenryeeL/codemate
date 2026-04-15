//
//  AddCommentView.swift
//

import UIKit

class AddCommentView: UIView {

    // MARK: - UI Elements
    let commentTextView = UITextView()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .white

        // 设置标题
        let titleLabel = UILabel()
        titleLabel.text = "Add Comment"
        titleLabel.font = UIFont(name: "RobotoSerif28ptCondensed-Black", size: 20)
        titleLabel.textAlignment = .center

        // 设置 TextView
        commentTextView.font = UIFont.systemFont(ofSize: 16)
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 5
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // 设置按钮
        saveButton.setTitle("Save", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)

        // 布局
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [titleLabel, commentTextView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        // 约束
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            commentTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
