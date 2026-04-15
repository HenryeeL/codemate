//
//  EditProfileViewController.swift
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController {

    // MARK: - Properties
    var username: String = "" // Used to receive the username
    var profileImage: UIImage? = nil // Used to receive the profile image
    var onSave: ((String, UIImage?) -> Void)? // Callback after saving

    private let editProfileView = EditProfileView(frame: UIScreen.main.bounds)
    private var isSaving = false // Prevent multiple save triggers

    // MARK: - Lifecycle
    override func loadView() {
        self.view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup View
    // Set up the view with initial values
    private func setupView() {
        // Set initial values
        editProfileView.usernameTextField.text = username
        editProfileView.profileImageView.image = profileImage ?? UIImage(systemName: "person.circle")

        // Set up the navigation bar save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )

        // Add action for changing the profile picture button
        //editProfileView.changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    // Handle the save button tap
    @objc private func saveButtonTapped() {
            guard !isSaving else { return } // Prevent saving multiple times
            isSaving = true

            let updatedUsername = editProfileView.usernameTextField.text ?? ""
            //let updatedImage = editProfileView.profileImageView.image

            print("Save button tapped. Updated username: \(updatedUsername)")

            // Check user login status
            guard let currentUserID = FirebaseManager.shared.getCurrentUserID() else {
                print("User not logged in. Prompting user to log in.")
                isSaving = false
                showAlertForLogin()
                return
            }
            
            // Update user profile (username)
            updateUserProfile(username: updatedUsername, profileImageURL: nil)

            // Update all comments with the new username
            updateCommentsUsername(newUsername: updatedUsername)
    }
        
        /*

        if let updatedImage = updatedImage {
            // Upload profile image to Firebase Storage
            FirebaseManager.shared.uploadProfileImage(image: updatedImage) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let imageURL):
                    print("Profile image uploaded. URL: \(imageURL)")

                    // Update username and profile image URL to Firebase
                    self.updateUserProfile(username: updatedUsername, profileImageURL: imageURL)

                case .failure(let error):
                    print("Failed to upload profile image: \(error.localizedDescription)")
                    self.isSaving = false
                }
            }
        } else {
            // If no profile image is updated, only update the username
            
        }
         */
    

    // Update user profile on Firebase
    private func updateUserProfile(username: String, profileImageURL: String?) {
        FirebaseManager.shared.updateUserProfile(username: username, profileImageURL: profileImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("User profile updated successfully.")

                // Execute save callback
                if let onSave = self.onSave {
                    onSave(username, self.editProfileView.profileImageView.image)
                }

                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("Failed to update user profile: \(error.localizedDescription)")
            }
            self.isSaving = false
        }
    }

    
    // Update all comments with the new username
    private func updateCommentsUsername(newUsername: String) {
        // Fetch all comments related to the user
        let db = Firestore.firestore()
        db.collection("comments").whereField("userID", isEqualTo: FirebaseManager.shared.getCurrentUserID() ?? "").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching comments: \(error.localizedDescription)")
                return
            }

            // Update each comment's username
            snapshot?.documents.forEach { document in
                db.collection("comments").document(document.documentID).updateData([
                    "userName": newUsername
                ]) { error in
                    if let error = error {
                        print("Error updating comment username: \(error.localizedDescription)")
                    } else {
                        print("Comment username updated successfully.")
                    }
                }
            }
        }
    }
    
    /*

    @objc private func changePhotoTapped() {
        let alertController = UIAlertController(title: "Change Photo", message: "Choose a source", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Helper Methods
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Photo Library not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
     */

    // Show alert when the user is not logged in
    private func showAlertForLogin() {
        let alert = UIAlertController(title: "Not Logged In", message: "Please log in to save changes.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

/*
// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 更新头像
            editProfileView.profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
*/
