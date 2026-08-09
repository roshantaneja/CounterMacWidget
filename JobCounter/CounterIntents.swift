import AppIntents
import WidgetKit

enum CounterIntentSupport {
    static func apply(_ mutate: (LocalCounterManager) -> CounterData) {
        FirebaseBootstrap.configureIfPossible()

        let manager = LocalCounterManager()
        let updated = mutate(manager)

        FirestoreSyncService(localManager: manager)
            .pushCountsToCloud(myCount: updated.myCount, partnerCount: updated.partnerCount)

        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct IncrementMyCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment My Count"
    static var description = IntentDescription("Adds one to My Applications.")

    func perform() async throws -> some IntentResult {
        CounterIntentSupport.apply { $0.incrementMyCount() }
        return .result()
    }
}

struct DecrementMyCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Decrement My Count"
    static var description = IntentDescription("Subtracts one from My Applications.")

    func perform() async throws -> some IntentResult {
        CounterIntentSupport.apply { $0.decrementMyCount() }
        return .result()
    }
}

struct IncrementPartnerCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment Partner Count"
    static var description = IntentDescription("Adds one to His Applications.")

    func perform() async throws -> some IntentResult {
        CounterIntentSupport.apply { $0.incrementPartnerCount() }
        return .result()
    }
}

struct DecrementPartnerCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Decrement Partner Count"
    static var description = IntentDescription("Subtracts one from His Applications.")

    func perform() async throws -> some IntentResult {
        CounterIntentSupport.apply { $0.decrementPartnerCount() }
        return .result()
    }
}
