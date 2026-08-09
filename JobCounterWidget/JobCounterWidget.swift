import WidgetKit
import SwiftUI

struct JobCounterWidget: Widget {
    let kind: String = "JobCounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: JobCounterProvider()) { entry in
            JobCounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Job Counter")
        .description("Tracks application counts.")
        .supportedFamilies([.systemMedium])
    }
}

struct JobCounterEntry: TimelineEntry {
    let date: Date
    let myCount: Int
    let partnerCount: Int
}

struct JobCounterProvider: TimelineProvider {
    func placeholder(in context: Context) -> JobCounterEntry {
        JobCounterEntry(date: Date(), myCount: 0, partnerCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (JobCounterEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<JobCounterEntry>) -> Void) {
        let timeline = Timeline(entries: [currentEntry()], policy: .never)
        completion(timeline)
    }

    private func currentEntry() -> JobCounterEntry {
        let data = LocalCounterManager().data
        return JobCounterEntry(
            date: Date(),
            myCount: data.myCount,
            partnerCount: data.partnerCount
        )
    }
}

#Preview(as: .systemMedium) {
    JobCounterWidget()
} timeline: {
    JobCounterEntry(date: .now, myCount: 12, partnerCount: 9)
}
