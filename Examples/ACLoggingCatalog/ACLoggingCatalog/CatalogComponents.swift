import ACLogging
import SwiftUI

struct CatalogSection<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: Content

    init(
        _ title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

struct ParameterPreview: View {
    let parameters: LogParameters?

    var body: some View {
        if let parameters, !parameters.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(parameters.sorted { $0.key < $1.key }, id: \.key) { key, value in
                    HStack(alignment: .firstTextBaseline) {
                        Text(key)
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(format(value))
                            .font(.caption.monospaced())
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        } else {
            Text("No parameters")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func format(_ value: LogValue) -> String {
        switch value {
        case let .string(value):
            return "\"\(value)\""
        case let .int(value):
            return "\(value)"
        case let .double(value):
            return "\(value)"
        case let .bool(value):
            return "\(value)"
        case let .date(value):
            return value.formatted(date: .abbreviated, time: .shortened)
        }
    }
}

struct LogTypeBadge: View {
    let logType: LogType

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.16))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var title: String {
        switch logType {
        case .info:
            return "info"
        case .analytic:
            return "analytic"
        case .warning:
            return "warning"
        case .severe:
            return "severe"
        }
    }

    private var color: Color {
        switch logType {
        case .info:
            return .blue
        case .analytic:
            return .green
        case .warning:
            return .orange
        case .severe:
            return .red
        }
    }
}
