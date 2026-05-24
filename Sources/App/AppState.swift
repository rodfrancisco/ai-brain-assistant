import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isStreaming: Bool = false
    @Published var knowledgeBasePath: String

    let claudeService: ClaudeService
    let knowledgeBaseService: KnowledgeBaseService
    let mcpService: MCPService

    private var currentTask: Task<Void, Never>?

    init() {
        let basePath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("knowledge-base").path

        self.knowledgeBasePath = basePath
        self.knowledgeBaseService = KnowledgeBaseService(basePath: basePath)
        self.mcpService = MCPService()
        self.claudeService = ClaudeService(
            knowledgeBase: knowledgeBaseService,
            mcpService: mcpService
        )
    }

    func sendMessage(_ text: String) async {
        // Cancel any existing task
        currentTask?.cancel()

        let userMessage = Message(role: .user, content: text)
        messages.append(userMessage)

        isStreaming = true

        currentTask = Task {
            do {
                var assistantContent = ""
                let stream = try await claudeService.sendMessage(text)

                for try await chunk in stream {
                    // Check for cancellation
                    if Task.isCancelled {
                        await MainActor.run {
                            messages.append(Message(role: .assistant, content: "Request cancelled", isStreaming: false))
                            isStreaming = false
                        }
                        return
                    }

                    assistantContent += chunk

                    // Update or create assistant message
                    await MainActor.run {
                        if let lastIndex = messages.lastIndex(where: { $0.role == .assistant && $0.isStreaming }) {
                            messages[lastIndex] = Message(role: .assistant, content: assistantContent, isStreaming: true)
                        } else {
                            messages.append(Message(role: .assistant, content: assistantContent, isStreaming: true))
                        }
                    }
                }

                // Mark streaming complete
                await MainActor.run {
                    if let lastIndex = messages.lastIndex(where: { $0.role == .assistant && $0.isStreaming }) {
                        messages[lastIndex] = Message(role: .assistant, content: assistantContent, isStreaming: false)
                    }
                    isStreaming = false
                }
            } catch {
                await MainActor.run {
                    messages.append(Message(role: .assistant, content: "Error: \(error.localizedDescription)", isStreaming: false))
                    isStreaming = false
                }
            }
        }

        await currentTask?.value
    }

    func clearChat() {
        messages.removeAll()
    }
}
