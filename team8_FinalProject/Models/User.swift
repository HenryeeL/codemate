//
//  User.swift
//

import Foundation
import FirebaseFirestore

// User model, conforms to Codable protocol for Firebase interaction
struct User: Codable {
    @DocumentID var userID: String? // Automatically generated Firebase document ID
    var userName: String
    var profilePicURL: String? // Firebase Storage URL for the user's profile picture
    var email: String
    var score: Int = 0
    var answers: [String: Answer] = [:] // [QuestionID: Answer] mapping, initialized to empty
    var solvedQuestions: [Answer] = [] // List of Answer objects for solved questions
    var comments: [String] = [] // List of CommentIDs

    // Default initializer
    init(
        userID: String? = nil,
        userName: String,
        profilePicURL: String? = nil,
        email: String,
        answers: [String: Answer] = [:],
        solvedQuestions: [Answer] = [],
        comments: [String] = []
    ) {
        self.userID = userID
        self.userName = userName
        self.profilePicURL = profilePicURL
        self.email = email
        self.answers = answers
        self.solvedQuestions = solvedQuestions
        self.comments = comments
    }

    // Initialize from Firebase data
    init(from data: [String: Any]) {
        self.userID = data["userID"] as? String
        self.userName = data["userName"] as? String ?? ""
        self.profilePicURL = data["profilePicURL"] as? String
        self.email = data["email"] as? String ?? ""
        
        // Directly initialize answers and solvedQuestions
        self.answers = [:]
        self.solvedQuestions = []
        self.comments = data["comments"] as? [String] ?? []
    }

    // Convert model data to dictionary for Firebase storage
    func toDictionary() -> [String: Any] {
        return [
            "userID": userID ?? "",
            "userName": userName,
            "profilePicURL": profilePicURL ?? "",
            "email": email,
            "score": score,
            "answers": answers.reduce(into: [String: [String: Any]]()) { result, pair in
                result[pair.key] = [
                    "questionID": pair.value.questionID,
                    "answerText": pair.value.answerText,
                    "isCompleted": pair.value.isCompleted,
                    "timestamp": pair.value.timestamp
                ]
            },
            "solvedQuestions": solvedQuestions.map { [
                "questionID": $0.questionID,
                "answerText": $0.answerText,
                "isCompleted": $0.isCompleted,
                "timestamp": $0.timestamp
            ] },
            "comments": comments
        ]
    }
}
