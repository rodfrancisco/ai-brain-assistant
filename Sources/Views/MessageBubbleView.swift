import SwiftUI

struct MessageBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)
                    .frame(maxWidth: 400, alignment: message.role == .user ? .trailing : .leading)

                if message.isStreaming {
                    HStack(spacing: 4) {
                        Text("Typing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ProgressView()
                            .scaleEffect(0.6)
                    }
                }

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if message.role == .assistant {
                Spacer()
            }
        }
    }
}
