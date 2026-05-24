import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("🧠 AI Brain")
                    .font(.headline)
                Spacer()
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            // Chat area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(appState.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .frame(height: 400)
                .onChange(of: appState.messages.count) {
                    if let lastMessage = appState.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // Input area
            HStack {
                TextField("Ask me anything...", text: $inputText)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        sendMessage()
                    }

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .disabled(inputText.isEmpty || appState.isStreaming)
            }
            .padding()

            Divider()

            // Footer
            HStack {
                Button("Clear Chat") {
                    appState.clearChat()
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Last active: just now")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(width: 500, height: 600)
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""

        Task {
            await appState.sendMessage(text)
        }
    }
}
