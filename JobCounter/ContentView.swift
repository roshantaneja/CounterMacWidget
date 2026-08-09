import SwiftUI

struct ContentView: View {
    @State private var counter = CounterData.zero

    private let manager = LocalCounterManager()

    var body: some View {
        VStack(spacing: 24) {
            Text("Job Counter Competition")
                .font(.largeTitle)
                .fontWeight(.semibold)

            HStack(spacing: 20) {
                counterCard(
                    title: "My Applications",
                    count: counter.myCount,
                    action: {
                        counter = manager.incrementMyCount()
                    }
                )

                counterCard(
                    title: "His Applications",
                    count: counter.partnerCount,
                    action: {
                        counter = manager.incrementPartnerCount()
                    }
                )
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            counter = manager.data
        }
    }

    private func counterCard(
        title: String,
        count: Int,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)

            Text("\(count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()

            Button(action: action) {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
