import Foundation
import FirebaseFirestore
import WidgetKit

final class FirestoreSyncService {
    static let didUpdateNotification = Notification.Name("FirestoreSyncService.didUpdate")

    private let db = Firestore.firestore()
    private let localManager: LocalCounterManager
    private var listener: ListenerRegistration?

    private var competitionDocument: DocumentReference {
        db.collection("counters").document("competition")
    }

    init(localManager: LocalCounterManager = LocalCounterManager()) {
        self.localManager = localManager
    }

    deinit {
        stopListening()
    }

    /// Writes both counts to `counters/competition`.
    func pushCountsToCloud(myCount: Int, partnerCount: Int) {
        let payload: [String: Any] = [
            "myCount": myCount,
            "partnerCount": partnerCount,
        ]

        competitionDocument.setData(payload, merge: true) { error in
            if let error {
                print("Firestore push failed: \(error.localizedDescription)")
            }
        }
    }

    /// Listens for remote changes, mirrors them into `LocalCounterManager`, and notifies the app.
    func listenForCloudUpdates() {
        listener?.remove()

        listener = competitionDocument.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }

            if let error {
                print("Firestore listener error: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else { return }

            let myCount = data["myCount"] as? Int ?? 0
            let partnerCount = data["partnerCount"] as? Int ?? 0
            let updated = CounterData(myCount: myCount, partnerCount: partnerCount)

            // Skip redundant writes when the local store already matches.
            guard updated != self.localManager.data else { return }

            self.localManager.data = updated

            // Refresh desktop widgets when partner (or remote) data changes.
            WidgetCenter.shared.reloadAllTimelines()

            NotificationCenter.default.post(
                name: Self.didUpdateNotification,
                object: self,
                userInfo: ["counterData": updated]
            )
        }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
