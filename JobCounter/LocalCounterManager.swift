import Foundation

struct CounterData: Codable, Equatable {
    var myCount: Int
    var partnerCount: Int

    static let zero = CounterData(myCount: 0, partnerCount: 0)
}

final class LocalCounterManager {
    private static let storageKey = "counterData"

    private let defaults: UserDefaults?

    init(defaults: UserDefaults? = AppGroup.shared) {
        self.defaults = defaults
    }

    var data: CounterData {
        get {
            guard
                let defaults,
                let stored = defaults.data(forKey: Self.storageKey),
                let decoded = try? JSONDecoder().decode(CounterData.self, from: stored)
            else {
                return .zero
            }
            return decoded
        }
        set {
            guard let defaults,
                  let encoded = try? JSONEncoder().encode(newValue)
            else {
                return
            }
            defaults.set(encoded, forKey: Self.storageKey)
        }
    }

    @discardableResult
    func incrementMyCount() -> CounterData {
        var current = data
        current.myCount += 1
        data = current
        return current
    }

    @discardableResult
    func incrementPartnerCount() -> CounterData {
        var current = data
        current.partnerCount += 1
        data = current
        return current
    }
}
