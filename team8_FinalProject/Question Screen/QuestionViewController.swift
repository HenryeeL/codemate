import UIKit

class QuestionViewController: UIViewController {
    private let questionView = QuestionView()
    private let titleSlug: String
    private var question: Question?
    private var user: User
    private var remainingTime: Int = 15 * 60
    private var totalTime: Int = 15 * 60
    private var timer: Timer?

    init(titleSlug: String, user: User) {
        self.titleSlug = titleSlug
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = questionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Question Details"
        questionView.startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        fetchQuestionData()
    }

    private func fetchQuestionData() {
        NetworkManager.shared.fetchQuestion(byTitleSlug: titleSlug) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let question):
                    self?.question = question
                    self?.setTimerBasedOnDifficulty(question.difficulty)
                    self?.displayQuestionData(question)
                    self?.questionView.updateTitle(self?.formatTitleSlug(question.titleSlug) ?? question.titleSlug)
//                    self?.questionView.updateTitle(question.titleSlug)
                case .failure(let error):
//                    self?.showErrorAlert(message: error.localizedDescription)
                    if let networkError = error as? NetworkError, networkError == .premiumQuestion {
                                            self?.showPremiumQuestionAlert(titleSlug: self?.titleSlug ?? "")
                    } else {
                        self?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func setTimerBasedOnDifficulty(_ difficulty: String) {
        switch difficulty.lowercased() {
        case "easy":
            totalTime = 30 * 60
        case "medium":
            totalTime = 40 * 60
        case "hard":
            totalTime = 50 * 60
        default:
            totalTime = 15 * 60
        }
        remainingTime = totalTime
        startCountdown()
    }


    private func formatTitleSlug(_ slug: String) -> String {
        return slug.split(separator: "-").map { $0.capitalized }.joined(separator: " ")
    }
    
    private func displayQuestionData(_ question: Question) {
        if let data = question.description.data(using: .utf8) {
            do {

                let attributedString = try NSMutableAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil
                )

                let mutableParagraphStyle = NSMutableParagraphStyle()
                mutableParagraphStyle.firstLineHeadIndent = 0
                mutableParagraphStyle.headIndent = 0
                mutableParagraphStyle.tailIndent = 0
                mutableParagraphStyle.paragraphSpacing = 0
                mutableParagraphStyle.paragraphSpacingBefore = 0
                mutableParagraphStyle.alignment = .left

            
                let fullRange = NSRange(location: 0, length: attributedString.length)
                attributedString.addAttributes([
                    .font: UIFont.systemFont(ofSize: 18),
                    .paragraphStyle: mutableParagraphStyle
                ], range: fullRange)

                questionView.descriptionTextView.attributedText = attributedString
            } catch {
 
                questionView.descriptionTextView.text = question.description
                questionView.descriptionTextView.font = UIFont.systemFont(ofSize: 18)
            }
        } else {
            questionView.descriptionTextView.text = question.description
            questionView.descriptionTextView.font = UIFont.systemFont(ofSize: 18)
        }
    }


    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.updateCountdownUI()
            } else {
                self.timer?.invalidate()
                self.showTimeUpAlert()
            }
        }
    }

    private func updateCountdownUI() {
        let progress = CGFloat(remainingTime) / CGFloat(totalTime)
        questionView.updateCountdownProgress(progress)

        let minutes = remainingTime / 60
        questionView.countdownLabel.text = "\(minutes) min"
    }

    private func showTimeUpAlert() {
        let alert = UIAlertController(title: "Time is up!", message: "You can continue writing your answer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showPremiumQuestionAlert(titleSlug: String) {
            let alert = UIAlertController(
                title: "⁉️ Premium Question",
                message: "We are sorry, this question is not visible since it is a premium question on LeetCode.com. Press 'View on LeetCode' to check details there.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))

            alert.addAction(UIAlertAction(title: "View on LeetCode", style: .default, handler: { _ in
                if let url = URL(string: "https://leetcode.com/problems/\(titleSlug)") {
                    UIApplication.shared.open(url)
                }
            }))

            present(alert, animated: true)
        }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapStart() {
        guard let question = question else {
            showErrorAlert(message: "Failed to load question data.")
            return
        }
        let answerVC = AnswerViewController(
            questionID: question.questionFrontendId,
            leetcodeLink: question.leetcodeLink,
            user: user,
            remainingTime: self.remainingTime,
            titleSlug: question.titleSlug
        )
        navigationController?.pushViewController(answerVC, animated: true)
    }

    deinit {
        timer?.invalidate()
    }
}

