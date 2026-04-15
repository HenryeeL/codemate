import UIKit
import Firebase
import Speech

class AnswerViewController: UIViewController, SFSpeechRecognizerDelegate {
    private let answerView = AnswerView()
    private let questionID: String
    private let leetcodeLink: String
    private var user: User
    private var remainingTime: Int
    private let titleSlug: String
    private var timer: Timer?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var previousRecognitionText: String = ""

    init(questionID: String, leetcodeLink: String, user: User, remainingTime: Int, titleSlug: String) {
        self.questionID = questionID
        self.leetcodeLink = leetcodeLink
        self.user = user
        self.remainingTime = remainingTime
        self.titleSlug = titleSlug
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = answerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVoiceInputButton()

        answerView.saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        answerView.markCompletedButton.addTarget(self, action: #selector(didTapMarkCompleted), for: .touchUpInside)
        answerView.voiceInputButton.addTarget(self, action: #selector(didTapVoiceInput), for: .touchUpInside)


        answerView.updateTitle(formatTitleSlug(titleSlug))
        startCountdown()
        loadPreviousAnswer()
        loadSolvedQuestions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCountdown()
    }

    private func formatTitleSlug(_ slug: String) -> String {
        return slug.split(separator: "-").map { $0.capitalized }.joined(separator: " ")
    }

    private func loadPreviousAnswer() {
       
        guard let userID = user.userID else {
            print("User ID is not available. Please log in first.")
            return
        }
        
        if let savedAnswer = user.answers[questionID] {
            answerView.textView.text = savedAnswer.answerText
        } else {
            let db = Firestore.firestore()
            db.collection("answers").document(userID).collection("userAnswers").document(questionID).getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching previous answer: \(error)")
                    return
                }
                guard let data = snapshot?.data(),
                      let answerText = data["answerText"] as? String else {
                    self.answerView.textView.text = ""
                    return
                }
                
                self.answerView.textView.text = answerText
            }
        }
    }


    @objc private func didTapSave() {
        saveAnswer(isCompleted: false)
    }

    @objc private func didTapMarkCompleted() {
        guard let existingAnswer = user.answers[questionID], existingAnswer.isCompleted else {
            saveAnswer(isCompleted: true)
            NotificationCenter.default.post(name: .questionCompleted, object: nil)
            return
        }

        let alert = UIAlertController(title: "Already Completed", message: "This question is already marked as completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "View Answer on LeetCode", style: .default) { _ in
            if let url = URL(string: self.leetcodeLink) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }

    private func saveAnswer(isCompleted: Bool) {
        guard let userID = user.userID else {
            print("User ID is not available. Please log in first.")
            return
        }

        let answerText = answerView.textView.text ?? ""
        let timestamp = Date()

        // Create or update the Answer object
        let answer = Answer(questionID: questionID, answerText: answerText, isCompleted: isCompleted, timestamp: timestamp)
        user.answers[questionID] = answer

        // Reference to the Firestore collection
        let db = Firestore.firestore()
        let answerDocumentRef = db.collection("answers").document(userID).collection("userAnswers").document(questionID)

        // Update the answer document in Firestore
        answerDocumentRef.getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            if document?.exists == true {
                // If document exists, update it
                answerDocumentRef.updateData([
                    "questionID": self.questionID,
                    "answerText": answerText,
                    "isCompleted": isCompleted,
                    "timestamp": Timestamp(date: timestamp)
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Answer updated in Firebase successfully.")
                    }
                }
            } else {
                // If document doesn't exist, create a new one
                answerDocumentRef.setData([
                    "questionID": self.questionID,
                    "answerText": answerText,
                    "isCompleted": isCompleted,
                    "timestamp": Timestamp(date: timestamp)
                ]) { error in
                    if let error = error {
                        print("Error saving document: \(error.localizedDescription)")
                    } else {
                        print("Answer saved in Firebase successfully.")
                    }
                }
            }

            // Calculate total score based on completed answers and update it in Firestore
            let solvedQuestionsRef = db.collection("answers").document(userID).collection("userAnswers")
            solvedQuestionsRef.whereField("isCompleted", isEqualTo: true).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching solved questions: \(error.localizedDescription)")
                    return
                }

                let completedCount = snapshot?.documents.count ?? 0
                let userDocumentRef = db.collection("users").document(userID)
                userDocumentRef.updateData([
                    "score": completedCount
                ]) { error in
                    if let error = error {
                        print("Error updating user score: \(error.localizedDescription)")
                    } else {
                        print("User score updated successfully.")
                        AppManager.shared.userProfileVC?.fetchUserProfileFromFirebase()
                    }
                }
            }
        }

        // Alert for save and completed actions
        let alertTitle = isCompleted ? "Completed" : "Saved"
        let alertMessage = isCompleted ? "This question has been marked as completed!" : "Your answer has been saved successfully!"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if isCompleted {
            alert.addAction(UIAlertAction(title: "View Answer on LeetCode", style: .default) { _ in
                if let url = URL(string: self.leetcodeLink) {
                    UIApplication.shared.open(url)
                }
            })
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }

       
    
    // get all completed anwsers by the user, by using user.solvedQuestions
    private func loadSolvedQuestions() {
       
        guard let userID = user.userID else {
            print("User ID is not available. Please log in first.")
            return
        }

        let db = Firestore.firestore()
        db.collection("answers")
            .document(userID)
            .collection("userAnswers")
            .whereField("isCompleted", isEqualTo: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching completed answers: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.user.solvedQuestions = documents.compactMap { doc in
                    let data = doc.data()
                    guard let questionID = data["questionID"] as? String,
                          let answerText = data["answerText"] as? String,
                          let isCompleted = data["isCompleted"] as? Bool,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return Answer(
                        questionID: questionID,
                        answerText: answerText,
                        isCompleted: isCompleted,
                        timestamp: timestamp.dateValue()
                    )
                }
                
                print("The user solved \(self.user.solvedQuestions.count) questions.")
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
        let progress = CGFloat(remainingTime) / CGFloat(15 * 60)
        answerView.updateCountdownProgress(progress)

        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        answerView.updateCountdown(String(format: "%02d:%02d", minutes, seconds))
        
    }
    

    private func showTimeUpAlert() {
        let alert = UIAlertController(title: "Time is up!", message: "You can continue writing your answer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // Voice Input logics here
    
    private func setupVoiceInputButton() {
        // Add action to the voice input button
        answerView.voiceInputButton.addTarget(self, action: #selector(didTapVoiceInput), for: .touchUpInside)
    }
 
    private func startVoiceRecognition() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request.")
            return
        }

        let inputNode = audioEngine.inputNode

        recognitionRequest.shouldReportPartialResults = true

        // replace previous recognized texts to null
        previousRecognitionText = ""

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                
                if recognizedText != self.previousRecognitionText {
                    let newText = String(recognizedText.dropFirst(self.previousRecognitionText.count))
                    self.previousRecognitionText = recognizedText
                    
                    DispatchQueue.main.async {
                        let currentText = self.answerView.textView.text ?? ""
                        self.answerView.textView.text = currentText + newText
                    }
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.stopVoiceRecognition()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine start failed: \(error.localizedDescription)")
        }

        // Update to active
        updateVoiceInputButton(isListening: true)
    }

//    @objc private func didTapVoiceInput() {
//        if audioEngine.isRunning {
//            stopVoiceRecognition()
//        } else {
//            startVoiceRecognition()
//        }
//    }
    
    @objc private func didTapVoiceInput() {

        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        print("Speech recognition authorized.")
                        self?.startVoiceRecognition()
                    case .denied, .restricted, .notDetermined:
                        print("Speech recognition is not available.")
                        self?.showPermissionDeniedAlert()
                    @unknown default:
                        print("Unknown authorization status.")
                    }
                }
            }
        case .authorized:
            if audioEngine.isRunning {
                stopVoiceRecognition()
            } else {
                startVoiceRecognition()
            }
        case .denied, .restricted:
            showPermissionDeniedAlert()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Speech Recognition Unavailable",
            message: "Please enable speech recognition in Settings to use voice input.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


    private func stopVoiceRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        // Update to inactive
        updateVoiceInputButton(isListening: false)
    }
    
    private func updateVoiceInputButton(isListening: Bool) {
        // Change voice input button icon and color based on status
        if isListening {
            answerView.voiceInputButton.setImage(UIImage(systemName: "waveform"), for: .normal)
            answerView.voiceInputButton.tintColor = .blue
            answerView.voiceInputButton.backgroundColor = .white
        } else {
            answerView.voiceInputButton.setImage(UIImage(systemName: "mic"), for: .normal)
            answerView.voiceInputButton.tintColor = .white
            answerView.voiceInputButton.backgroundColor = .blue
        }
    }
}
