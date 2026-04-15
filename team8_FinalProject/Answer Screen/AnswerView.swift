
import UIKit

class AnswerView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let countdownCircleView = UIView()
    let countdownLabel = UILabel()
    let textView = UITextView()
    let saveButton = UIButton(type: .system)
    let markCompletedButton = UIButton(type: .system)
    let voiceInputButton = UIButton(type: .system)

    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor(
            red: 0.1,
            green: 0.1,
            blue: 0.6,
            alpha: 1.0
        )
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        // Countdown Circle View
        countdownCircleView.backgroundColor = .white
        countdownCircleView.layer.cornerRadius = 75

        // Countdown Label
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 18)
        countdownLabel.textAlignment = .center
        countdownLabel.textColor = UIColor(
            red: 12 / 255.0,
            green: 10 / 255.0,
            blue: 189 / 255.0,
            alpha: 1.0
        )

        // Add countdown circle layers
        setupCountdownCircle()

        // Text View
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor(
            red: 12 / 255.0,
            green: 10 / 255.0,
            blue: 189 / 255.0,
            alpha: 1.0
        ).cgColor
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)

        // Voice Input Button
        voiceInputButton.setImage(UIImage(systemName: "mic"), for: .normal)
        voiceInputButton.tintColor = .white
        voiceInputButton.backgroundColor = .blue
        voiceInputButton.layer.cornerRadius = 24
        voiceInputButton.clipsToBounds = true

        // Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor(
            red: 12 / 255.0,
            green: 10 / 255.0,
            blue: 189 / 255.0,
            alpha: 1.0
        )
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.layer.cornerRadius = 16

        // Mark Completed Button
        markCompletedButton.setTitle("Mark as Completed and View Solution", for: .normal)
        markCompletedButton.backgroundColor = UIColor(
            red: 12 / 255.0,
            green: 10 / 255.0,
            blue: 189 / 255.0,
            alpha: 1.0
        )
        markCompletedButton.setTitleColor(.white, for: .normal)
        markCompletedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        markCompletedButton.layer.cornerRadius = 16

        // Add Subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(countdownCircleView)
        countdownCircleView.addSubview(countdownLabel)
        contentView.addSubview(textView)
        contentView.addSubview(voiceInputButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(markCompletedButton)

        // Layout
        layoutComponents()
    }

    private func setupCountdownCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 40, startAngle: -.pi / 2, endAngle: 1.5 * .pi, clockwise: true)

        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        circleLayer.lineWidth = 8
        circleLayer.lineCap = .round
        countdownCircleView.layer.addSublayer(circleLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor(
            red: 12 / 255.0,
            green: 10 / 255.0,
            blue: 189 / 255.0,
            alpha: 1.0
        ).cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1.0
        countdownCircleView.layer.addSublayer(progressLayer)
    }

    private func layoutComponents() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownCircleView.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        markCompletedButton.translatesAutoresizingMaskIntoConstraints = false
        voiceInputButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Countdown Circle View
            countdownCircleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            countdownCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countdownCircleView.widthAnchor.constraint(equalToConstant: 100),
            countdownCircleView.heightAnchor.constraint(equalToConstant: 100),

            // Countdown Label (inside the circle)
            countdownLabel.centerXAnchor.constraint(equalTo: countdownCircleView.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: countdownCircleView.centerYAnchor),

            // Text View
            textView.topAnchor.constraint(equalTo: countdownCircleView.topAnchor, constant: 50),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            // Voice Input Button (at bottom-right corner of textView)
            voiceInputButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10),
            voiceInputButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -10),
            voiceInputButton.widthAnchor.constraint(equalToConstant: 48),
            voiceInputButton.heightAnchor.constraint(equalToConstant: 48),

            // Save Button
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            saveButton.heightAnchor.constraint(equalToConstant: 50),

            markCompletedButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            markCompletedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            markCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            markCompletedButton.heightAnchor.constraint(equalToConstant: 50),
            markCompletedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        textView.textContainerInset = UIEdgeInsets(top: 50, left: 8, bottom: 8, right: 8)
        countdownCircleView.layer.zPosition = 1
    }
    
    func updateTitle(_ title: String) {
            titleLabel.text = title
        }
    
        func updateCountdown(_ countdownText: String) {
            countdownLabel.text = countdownText
        }
    
        func updateCountdownProgress(_ progress: CGFloat) {
            progressLayer.strokeEnd = progress
    
            let startColor = UIColor(red: 12 / 255.0, green: 10 / 255.0, blue: 189 / 255.0, alpha: 1.0)
            let endColor = UIColor.lightGray
    
            let interpolatedColor = interpolateColor(from: startColor, to: endColor, progress: 1.0 - progress)
            progressLayer.strokeColor = interpolatedColor.cgColor
        }
    
        private func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
            var startRed: CGFloat = 0
            var startGreen: CGFloat = 0
            var startBlue: CGFloat = 0
            var startAlpha: CGFloat = 0
            startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
    
            var endRed: CGFloat = 0
            var endGreen: CGFloat = 0
            var endBlue: CGFloat = 0
            var endAlpha: CGFloat = 0
            endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
    
            let red = startRed + (endRed - startRed) * progress
            let green = startGreen + (endGreen - startGreen) * progress
            let blue = startBlue + (endBlue - startBlue) * progress
            let alpha = startAlpha + (endAlpha - startAlpha) * progress
    
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
}

