//
//  UserProfileViewController.swift
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let userProfileView = UserProfileView(frame: UIScreen.main.bounds)
    private var username: String = "" // Initial username is empty, waiting to be loaded from Firebase
    private var email: String = "" // Initial email is empty
    private var score: Int = 0 // Initial score
    private var profileImage: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage = profileImage ?? UIImage(systemName: "person.circle") // Default profile image
        AppManager.shared.userProfileVC = self
        view.backgroundColor = .white
        print("View did load") // Debug log

        // Add UserProfileView
        view.addSubview(userProfileView)

        // Set up button actions
        setupEditButtonAction()
        authenticateUser()
        
    }

    // Check if the user is logged in
    private func authenticateUser() {
        if let currentUser = Auth.auth().currentUser {
                // If the user is already logged in
                print("User already logged in: \(currentUser.uid), displayName: \(currentUser.displayName ?? "Unknown User")")
                
                // Perform actions for logged-in users
                // For example, update UI or fetch user data from Firebase
                fetchUserProfileFromFirebase()

            } else {
                // If the user is not logged in, show login prompt
                print("No user logged in.")
                // You can choose to navigate to the login screen or show a login prompt
                showLoginAlert()
            }
    }
    
    // Show login alert if user is not logged in
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

    // Navigate to the login screen
    
    private func redirectToLogin() {
        let loginViewController = LoginViewControllerMain()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

    // MARK: - Firebase Data Fetch
    // Fetch user profile data from Firebase
    func fetchUserProfileFromFirebase() {
        FirebaseManager.shared.fetchUserProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print("Fetched user profile data: \(data)")

                // Update data
                self.username = data["userName"] as? String ?? "Unknown User"
                self.email = data["email"] as? String ?? "unknown@example.com"
                
                // Directly fetch the score from Firebase data
                self.score = data["score"] as? Int ?? 0  // Ensure the score is fetched from Firebase directly

                // If profile image URL is available, load the image from the network
                if let profileImageURL = data["profileImageURL"] as? String {
                    self.loadProfileImage(from: profileImageURL)
                }

                // Update the UI
                DispatchQueue.main.async {
                    self.updateUserProfileView()
                }

            case .failure(let error):
                print("Failed to fetch user profile: \(error.localizedDescription)")
            }
        }
    }

    // Load profile image from the provided URL
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to load profile image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.profileImage = image
                    self?.userProfileView.profileImageView.image = image
                }
            }
        }.resume()
    }

    // MARK: - Setup Methods
    // Update the UserProfileView with the latest user data
    private func updateUserProfileView() {
        userProfileView.usernameLabel.text = username
        userProfileView.emailLabel.text = email
        userProfileView.scoreLabel.text = "Score: \(score)"
        userProfileView.profileImageView.image = profileImage
        print("Updated User Profile View - Username: \(username), Email: \(email), Score: \(score)") // Debug log
    }

    // Set up the Edit button action
    private func setupEditButtonAction() {
        userProfileView.onEditButtonTapped = { [weak self] in
            self?.navigateToEditPage()
        }
        print("Page Edit button action set up") // Debug log
    }

    // MARK: - Actions
    // Navigate to the Edit Profile Page
    private func navigateToEditPage() {
        print("Navigating to Edit Profile Page") // Debug log

        let editViewController = EditProfileViewController()
        editViewController.username = username
        editViewController.profileImage = profileImage

        // Set the save callback for the edit page
        editViewController.onSave = { [weak self] updatedUsername, updatedImage in
            guard let self = self else { return }

            // Update Firebase data
            FirebaseManager.shared.uploadProfileImage(image: updatedImage ?? UIImage()) { result in
                switch result {
                case .success(let imageURL):
                    FirebaseManager.shared.updateUserProfile(username: updatedUsername, profileImageURL: imageURL) { result in
                        switch result {
                        case .success:
                            print("User profile updated successfully.")
                        case .failure(let error):
                            print("Failed to update user profile: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to upload profile image: \(error.localizedDescription)")
                }
            }

            // Update the local UI
            self.username = updatedUsername
            self.profileImage = updatedImage
            self.updateUserProfileView()
            print("Profile updated successfully.")
        }

        // Use the existing navigation controller to navigate
        navigationController?.pushViewController(editViewController, animated: true)
    }
}
