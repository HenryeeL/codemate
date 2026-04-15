//
//  AddCommentViewController.swift
//

import UIKit

class AddCommentViewController: UIViewController {

    // MARK: - Properties
    private let addCommentView = AddCommentView()
    var onSave: ((String) -> Void)?

    // MARK: - Lifecycle
    override func loadView() {
        self.view = addCommentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    // MARK: - Setup Actions
    private func setupActions() {
        addCommentView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addCommentView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func saveButtonTapped() {
        guard let comment = addCommentView.commentTextView.text, !comment.isEmpty else { return }
        onSave?(comment) 
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
