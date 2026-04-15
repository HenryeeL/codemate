import Foundation

class CountdownManager {
    static let shared = CountdownManager()

    private var timer: Timer?
    private(set) var remainingTime: Int = 0
    private(set) var isRunning: Bool = false

    var onUpdate: ((Int) -> Void)?
    var onComplete: (() -> Void)?

    private init() {}

    func startCountdown(from time: Int) {
        stopCountdown()
        remainingTime = time
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.onUpdate?(self.remainingTime)
            } else {
                self.stopCountdown()
                self.onComplete?()
            }
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}

