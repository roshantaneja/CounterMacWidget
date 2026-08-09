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
}

struct JobCounterProvider: TimelineProvider {
    func placeholder(in context: Context) -> JobCounterEntry {
        JobCounterEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (JobCounterEntry) -> Void) {
        completion(JobCounterEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<JobCounterEntry>) -> Void) {
        let entry = JobCounterEntry(date: Date())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct JobCounterWidgetEntryView: View {
    var entry: JobCounterEntry

    var body: some View {
        Text("Job Counter")
            .containerBackground(.fill.tertiary, for: .widget)
    }
}

#Preview(as: .systemMedium) {
    JobCounterWidget()
} timeline: {
    JobCounterEntry(date: .now)
}
