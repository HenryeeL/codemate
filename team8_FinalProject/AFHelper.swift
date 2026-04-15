import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchQuestion(byTitleSlug titleSlug: String, completion: @escaping (Result<Question, Error>) -> Void) {
        let url = "https://alfa-leetcode-api.onrender.com/select?titleSlug=\(titleSlug)"

        AF.request(url, method: .get).responseDecodable(of: QuestionAPIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):

                let question = Question(
                    questionFrontendId: apiResponse.questionId,
                    title: apiResponse.questionTitle,
                    titleSlug: apiResponse.titleSlug,
                    difficulty: apiResponse.difficulty,
                    description: apiResponse.question,
                    leetcodeLink: apiResponse.link,
                    exampleTestcases: apiResponse.exampleTestcases
                )
                completion(.success(question))
            case .failure(let error):
                completion(.failure(NetworkError.premiumQuestion))
            }
        }
    }
}

struct QuestionAPIResponse: Codable {
    let questionId: String
    let questionTitle: String
    let titleSlug: String
    let question: String
    let difficulty: String
    let link: String
    let exampleTestcases: String
}

enum NetworkError: Error {
    case premiumQuestion
}
