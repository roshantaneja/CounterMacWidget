import Foundation

enum AppGroup {
    static let suiteName = "group.com.jobcounter.app"

    static let shared = UserDefaults(suiteName: suiteName)

    /// `true` when the App Group suite was available and `UserDefaults` was created.
    static var isAvailable: Bool {
        shared != nil
    }
}
