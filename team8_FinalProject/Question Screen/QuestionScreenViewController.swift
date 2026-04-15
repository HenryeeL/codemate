import UIKit
import Alamofire
import FirebaseAuth
import Firebase

class QuestionScreenViewController: UIViewController {
    var passUrl:String!
    let questionScreenView = QuestionScreenView()
    var questionList = [QuestionListItem]()
    var filteredList = [QuestionListItem]()
    let currentUser = Auth.auth().currentUser

    override func loadView() {
        view = questionScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: adding dummy data for testing table view...
        /*
        questionList.append(Question(questionFrontendId: "1", title: "One", titleSlug: "One", difficulty: "Easy"))
        questionList.append(Question(questionFrontendId: "2", title: "Two", titleSlug: "Two", difficulty: "Medium"))
        questionList.append(Question(questionFrontendId: "11", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        questionList.append(Question(questionFrontendId: "121", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        questionList.append(Question(questionFrontendId: "232", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        questionList.append(Question(questionFrontendId: "111", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        questionList.append(Question(questionFrontendId: "23", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        questionList.append(Question(questionFrontendId: "3", title: "Three", titleSlug: "Three", difficulty: "Hard"))
        */
        navigationController?.navigationBar.prefersLargeTitles = true
        //get all questions when the main screen loads...
        getAllQuestions()
        
        // Store all questions into filteredList
        //filteredList = questionList
        
        // Setup search text field to listen for changes
        questionScreenView.textFieldSearch.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        setupTableView()
        // Add observer for the question completion notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuestionCompletedNotification(_:)), name: .questionCompleted, object: nil)
        print("Filtered List: \(filteredList)")
    
    }
    
    deinit {
            // Always remove the observer when it's no longer needed
        NotificationCenter.default.removeObserver(self, name: .questionCompleted, object: nil)
        }
    @objc func handleQuestionCompletedNotification(_ notification: Notification) {
        // Clear both questionList and filteredList
        questionList.removeAll()
        filteredList.removeAll()
            
        // Call getAllQuestions to reload the data
        getAllQuestions()
            
        // Reload the table view to reflect the changes
        self.questionScreenView.tableViewQuestions.reloadData()
    }
    // Get the current user ID from Firebase Auth
    func getCurrentUserId() -> String {
        guard let currentUser = Auth.auth().currentUser else {
            return "guest_user" // Default fallback for unauthenticated users
        }
        return currentUser.uid
    }
    
    @objc func searchTextChanged() {
        let searchText = questionScreenView.textFieldSearch.text ?? ""
        filterQuestions(by: searchText)
    }
        
    private func filterQuestions(by keyword: String) {
        // Ensure both the keyword and the titles are trimmed and in lowercase for case-insensitive matching.
        let sanitizedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if sanitizedKeyword.isEmpty {
        // If the keyword is empty, show all questions
            filteredList = questionList
        } else {
            // Filter the questions where the title contains the keyword (case-insensitive)
            filteredList = questionList.filter { question in
                let sanitizedTitle = question.title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let sanitizedFrontendId = question.questionFrontendId.lowercased()
                            
                return sanitizedTitle.contains(sanitizedKeyword) || sanitizedFrontendId.contains(sanitizedKeyword)
            }
        }
        questionScreenView.tableViewQuestions.reloadData() // Reload the table view with the filtered data
    }
    
    private func setupTableView() {
        questionScreenView.tableViewQuestions.delegate = self
        questionScreenView.tableViewQuestions.dataSource = self
        questionScreenView.tableViewQuestions.register(QuestionTableViewCell.self, forCellReuseIdentifier: Configs.tableViewQuestion)
        questionScreenView.tableViewQuestions.separatorStyle = .none
    }
    
    //MARK: get all contacts call: getall endpoint...
    func getAllQuestions(){
        if let url = URL(string: passUrl){
            AF.request(url, method: .get).responseData(completionHandler: { response in
                //MARK: retrieving the status code...
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):
                    //MARK: there was no network error...
                    
                    //MARK: status code is Optional, so unwrapping it...
                    if let uwStatusCode = status{
                        switch uwStatusCode{
                            case 200...299:
                            //MARK: the request was valid 200-level...
                            self.questionList.removeAll()
                                let decoder = JSONDecoder()
                                do{
                                    let receivedData =
                                        try decoder
                                        .decode(QuestionResponse.self, from: data)
                                        
                                    for item in receivedData.problemsetQuestionList{
                                        self.questionList.append(item)
                                    }
                                    // Store all questions into filteredList
                                    self.filteredList = self.questionList
                                    self.questionScreenView.tableViewQuestions.reloadData()
                                }catch{
                                    print("JSON couldn't be decoded.")
                                }
                                break
                    
                            case 400...499:
                            //MARK: the request was not valid 400-level...
                                print(data)
                                break
                    
                            default:
                            //MARK: probably a 500-level error...
                                print(data)
                                break
                    
                        }
                    }
                    break
                    
                case .failure(let error):
                    //MARK: there was a network error...
                    print(error)
                    break
                }
            })
        }
    }

    

}

