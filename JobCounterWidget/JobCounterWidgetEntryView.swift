import WidgetKit
import SwiftUI
import AppIntents

struct JobCounterWidgetEntryView: View {
    var entry: JobCounterEntry

    var body: some View {
        HStack(spacing: 12) {
            countColumn(
                title: "My Applications",
                count: entry.myCount,
                intent: IncrementMyCountIntent()
            )

            countColumn(
                title: "His Applications",
                count: entry.partnerCount,
                intent: IncrementPartnerCountIntent()
            )
        }
        .padding(12)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func countColumn(
        title: String,
        count: Int,
        intent: some AppIntent
    ) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("\(count)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)

            Button(intent: intent) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.tint)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.background.secondary)
        }
    }
}
