import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let myCount: Int
    let partnerCount: Int

    init(date: Date = Date(), data: CounterData) {
        self.date = date
        self.myCount = data.myCount
        self.partnerCount = data.partnerCount
    }

    init(date: Date, myCount: Int, partnerCount: Int) {
        self.date = date
        self.myCount = myCount
        self.partnerCount = partnerCount
    }
}

struct JobCounterTimelineProvider: TimelineProvider {
    private let localManager = LocalCounterManager()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: .zero)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let timeline = Timeline(entries: [makeEntry()], policy: .never)
        completion(timeline)
    }

    private func makeEntry() -> SimpleEntry {
        // Reads CounterData from the App Group UserDefaults via LocalCounterManager.
        SimpleEntry(date: Date(), data: localManager.data)
    }
}
