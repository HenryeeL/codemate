//
//  DiscussionViewController.swift
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DiscussionViewController: UIViewController {

    // MARK: - Properties
    private let discussionView = DiscussionView()
    private var comments: [Comment] = [] // Array to store comments
    private var filteredComments: [Comment] = [] // Array to store filtered results after search
    private var isSearching = false // Flag to check if searching
    private let commentManager = CommentManager() // Used for managing comments and Firebase interaction

    // Date formatter (global property to avoid recreating it multiple times)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm" // Format as Month/Day/Year Hour:Minute
        return formatter
    }()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = discussionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        setupView()
        
    }
    
    // Authenticate the user (check if logged in)
    private func authenticateUser() {
        if let currentUser = Auth.auth().currentUser {
            print("User already logged in: \(currentUser.uid), displayName: \(currentUser.displayName ?? "Unknown User")")
            // User is logged in, proceed with loading comments
            loadCommentsFromFirebase()
        } else {
            print("No user logged in.")
            // User is not logged in, show login alert
            showLoginAlert()
        }
    }

    // Show an alert if the user is not logged in
    private func showLoginAlert() {
        let alert = UIAlertController(
            title: "Not Logged In",
            message: "You need to log in to add comments.",
            preferredStyle: .alert
        )
        let loginAction = UIAlertAction(title: "Log In", style: .default) { _ in
            self.redirectToLogin()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    // Redirect to the login page
    private func redirectToLogin() {
        /*
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
         */
    }

    deinit {
        commentManager.stopListening()
    }

    // MARK: - Setup View
    // Set up the view with the required configurations
    private func setupView() {
        // Set up TableView data source and delegate
        discussionView.commentsTableView.dataSource = self
        discussionView.commentsTableView.delegate = self
        
        // Set up SearchBar delegate
        discussionView.searchBar.delegate = self

        // Set up Add Button action
        discussionView.addButton.addTarget(self, action: #selector(addCommentTapped), for: .touchUpInside)
    }

    // MARK: - Firebase Data
    // Load comments from Firebase
    private func loadCommentsFromFirebase() {
        commentManager.startListening { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loadedComments):
                self.comments = loadedComments
                DispatchQueue.main.async {
                    self.discussionView.commentsTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to load comments: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Actions
    // Handle the Add Comment button tap
    @objc private func addCommentTapped() {
        let addCommentVC = AddCommentViewController()
        addCommentVC.onSave = { [weak self] commentText in
            guard let self = self else { return }

            // Ensure the user is logged in
            guard let currentUser = Auth.auth().currentUser else {
                print("Error: User is not logged in")
                return
            }

            // Print current user information
            print("Current User ID: \(currentUser.uid)")

            // Get user ID
            let userID = currentUser.uid

            // Fetch the latest user name from Firestore
            let db = Firestore.firestore()
            db.collection("users").document(userID).getDocument { [weak self] document, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching user data from Firestore: \(error.localizedDescription)")
                    return
                }

                guard let document = document, document.exists, let data = document.data() else {
                    print("User data not found in Firestore.")
                    return
                }

                // Get the userName from Firestore, fall back to "Unknown User" if not available
                let userName = data["userName"] as? String ?? "Unknown User"
                print("Fetched User Name from Firestore: \(userName)")

                // Create a new comment object
                let newComment = Comment(
                    text: commentText,
                    userID: userID,
                    userName: userName,
                    timestamp: Date()
                )

                // Save comment to Firebase
                self.commentManager.addComment(newComment) { result in
                    switch result {
                    case .success:
                        print("Comment added successfully.")
                    case .failure(let error):
                        print("Failed to add comment: \(error.localizedDescription)")
                    }
                }
            }
        }
        present(addCommentVC, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension DiscussionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredComments.count : comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = isSearching ? filteredComments[indexPath.row] : comments[indexPath.row]
        
        // Format timestamp
        let formattedTimestamp = dateFormatter.string(from: comment.timestamp)
        
        // Get the first line of the comment
        let firstLine = comment.text.components(separatedBy: "\n").first ?? comment.text
        
        // Set the display content
        cell.textLabel?.text = "\(comment.userName): \(firstLine)    \(formattedTimestamp)"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DiscussionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = isSearching ? filteredComments[indexPath.row] : comments[indexPath.row]
        
        // Show full comment content in an alert
        let alertController = UIAlertController(
            title: "Comment Content",
            message: "\(comment.userName):\n\n\(comment.text)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let comment = isSearching ? filteredComments[indexPath.row] : comments[indexPath.row]
            
            // Check if the user has permission to delete the comment
            if comment.userID == Auth.auth().currentUser?.uid {
                showDeleteConfirmation(comment, at: indexPath)
            } else {
                showPermissionDeniedAlert()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension DiscussionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredComments = comments.filter {
                $0.text.lowercased().contains(searchText.lowercased()) ||
                $0.userName.lowercased().contains(searchText.lowercased())
            }
        }
        discussionView.commentsTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        discussionView.commentsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension DiscussionViewController {
    /// Show an alert when the user doesn't have permission to delete a comment
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Permission Denied",
            message: "You can only delete your own comments.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    /// Show a confirmation alert to delete a comment
    private func showDeleteConfirmation(_ comment: Comment, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Confirm Delete",
            message: "Are you sure you want to delete this comment?",
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteComment(comment, at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func deleteComment(_ comment: Comment, at indexPath: IndexPath) {
        // Check if the user has permission to delete
        guard let currentUser = Auth.auth().currentUser, currentUser.uid == comment.userID else {
            showPermissionDeniedAlert()
            return
        }

        // Call CommentManager to delete the comment from Firebase
        commentManager.deleteComment(comment) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("Comment deleted successfully.")
                // Remove the comment from the local array
                self.comments.remove(at: indexPath.row)
                //self.discussionView.commentsTableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("Failed to delete comment: \(error.localizedDescription)")
            }
        }
    }
}
