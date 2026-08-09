import AppKit
import FirebaseCore

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        configureFirebaseIfPossible()
    }

    /// Configures Firebase only when the app bundle is ready, avoiding a crash
    /// from a missing `GoogleService-Info.plist` or a repeated configure call.
    @discardableResult
    private func configureFirebaseIfPossible() -> Bool {
        if FirebaseApp.app() != nil {
            return true
        }

        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            assertionFailure("Firebase: GoogleService-Info.plist is missing from the app bundle.")
            print("Firebase was not configured: GoogleService-Info.plist not found.")
            return false
        }

        FirebaseApp.configure()

        let didInitialize = FirebaseApp.app() != nil
        if didInitialize {
            print("Firebase initialized successfully.")
        } else {
            print("Firebase configure() finished but FirebaseApp.app() is nil.")
        }
        return didInitialize
    }
}
