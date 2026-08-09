import AppIntents
import WidgetKit

struct IncrementMyCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment My Count"
    static var description = IntentDescription("Adds one to My Applications.")

    func perform() async throws -> some IntentResult {
        let manager = LocalCounterManager()
        let updated = manager.incrementMyCount()

        FirestoreSyncService(localManager: manager)
            .pushCountsToCloud(myCount: updated.myCount, partnerCount: updated.partnerCount)

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct IncrementPartnerCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment Partner Count"
    static var description = IntentDescription("Adds one to His Applications.")

    func perform() async throws -> some IntentResult {
        let manager = LocalCounterManager()
        let updated = manager.incrementPartnerCount()

        FirestoreSyncService(localManager: manager)
            .pushCountsToCloud(myCount: updated.myCount, partnerCount: updated.partnerCount)

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
