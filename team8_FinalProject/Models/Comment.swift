//
//  Comment.swift
//

import Foundation
import FirebaseFirestore

struct Comment: Codable {
    @DocumentID var commentID: String?
    var text: String
    var userID: String
    var userName: String
    var timestamp: Date

    
    init(commentID: String? = nil, text: String, userID: String, userName: String, timestamp: Date = Date()) {
        self.commentID = commentID
        self.text = text
        self.userID = userID
        self.userName = userName
        self.timestamp = timestamp
    }

    
    init(from data: [String: Any]) {
        self.commentID = data["commentID"] as? String
        self.text = data["text"] as? String ?? ""
        self.userID = data["userID"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }

    
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "userID": userID,
            "userName": userName,
            "timestamp": Timestamp(date: timestamp)
        ]
    }
}
