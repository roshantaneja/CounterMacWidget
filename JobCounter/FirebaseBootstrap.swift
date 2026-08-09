import Foundation
import FirebaseCore

enum FirebaseBootstrap {
    /// Configures Firebase when `GoogleService-Info.plist` is present. Safe to call from app or intents.
    @discardableResult
    static func configureIfPossible() -> Bool {
        if FirebaseApp.app() != nil {
            return true
        }

        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            return false
        }

        FirebaseApp.configure()
        return FirebaseApp.app() != nil
    }
}
