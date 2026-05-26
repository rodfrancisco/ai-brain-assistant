import Foundation

struct ClaudeAPIMessage: Codable {
    let role: String
    let content: String
}

struct ClaudeAPIRequest: Codable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeAPIMessage]
    let system: String?
    let stream: Bool
}

class ClaudeService {
    private let knowledgeBase: KnowledgeBaseService
    private let mcpService: MCPService
    private let skillService: SkillService
    private var conversationHistory: [ClaudeAPIMessage] = []

    // Bedrock configuration (matches Claude Code setup)
    private let bedrockURL: URL
    private let modelID: String
    private let authToken: String

    init(knowledgeBase: KnowledgeBaseService, mcpService: MCPService, skillService: SkillService) {
        self.knowledgeBase = knowledgeBase
        self.mcpService = mcpService
        self.skillService = skillService

        // Use same configuration as Claude Code (ANTHROPIC_BASE_URL, not BEDROCK)
        let baseURL = "https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl"
        self.bedrockURL = URL(string: "\(baseURL)/v1/messages")!
        self.modelID = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"

        // Auth token from Claude Code config
        self.authToken = "sk-8y2vPI6XLYra50TeJqGgUw"
    }

    func sendMessage(_ text: String) async throws -> AsyncStream<String> {
        // Add user message to history
        conversationHistory.append(ClaudeAPIMessage(role: "user", content: text))

        // Build system prompt with knowledge base context
        let systemPrompt = buildSystemPrompt()

        // Create request (Bedrock format)
        let request = ClaudeAPIRequest(
            model: modelID,
            max_tokens: 4096,
            messages: conversationHistory,
            system: systemPrompt,
            stream: true
        )

        var urlRequest = URLRequest(url: bedrockURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        urlRequest.setValue(authToken, forHTTPHeaderField: "x-api-key")
        urlRequest.timeoutInterval = 30.0 // 30 second timeout

        urlRequest.httpBody = try JSONEncoder().encode(request)

        // Stream response
        return AsyncStream { continuation in
            Task {
                do {
                    // Use a custom session with timeout configuration
                    let config = URLSessionConfiguration.default
                    config.timeoutIntervalForRequest = 30.0
                    config.timeoutIntervalForResource = 300.0
                    let session = URLSession(configuration: config)

                    let (asyncBytes, response) = try await session.bytes(for: urlRequest)

                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.yield("\n\nError: Invalid HTTP response\n")
                        continuation.finish()
                        return
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        continuation.yield("\n\nError: HTTP \(httpResponse.statusCode)\n")
                        continuation.yield("Endpoint: \(self.bedrockURL.absoluteString)\n")
                        continuation.yield("Check VPN connection to Salesforce network.\n")
                        continuation.finish()
                        return
                    }

                    continuation.yield("\n\n") // Clear the "Connecting..." message

                    var assistantMessage = ""

                    for try await line in asyncBytes.lines {
                        // Parse SSE format: "data: {...}"
                        if line.hasPrefix("data: ") {
                            let jsonString = String(line.dropFirst(6))

                            // Skip [DONE] message
                            if jsonString == "[DONE]" {
                                continue
                            }

                            if let data = jsonString.data(using: .utf8),
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let type = json["type"] as? String {

                                if type == "content_block_delta",
                                   let delta = json["delta"] as? [String: Any],
                                   let text = delta["text"] as? String {
                                    assistantMessage += text
                                    continuation.yield(text)
                                }
                            }
                        }
                    }

                    // Add assistant response to history
                    if !assistantMessage.isEmpty {
                        self.conversationHistory.append(ClaudeAPIMessage(role: "assistant", content: assistantMessage))
                    }

                    continuation.finish()
                } catch {
                    continuation.yield("Error: \(error.localizedDescription)\n")
                    continuation.yield("Make sure you're on Salesforce network/VPN.\n")
                    continuation.finish()
                }
            }
        }
    }

    private func buildSystemPrompt() -> String {
        // Load ALL context from knowledge base
        let profile = knowledgeBase.loadProfile() ?? "No profile available"
        let initiatives = knowledgeBase.loadCurrentInitiatives() ?? "No initiatives available"
        let stakeholders = knowledgeBase.loadStakeholderMap() ?? "No stakeholder map available"
        let toneOfVoice = knowledgeBase.loadToneOfVoice()
        let technicalDomains = knowledgeBase.loadTechnicalDomains()
        let todaysSummary = knowledgeBase.loadTodaysSummary()

        var prompt = """
        You are Rod Francisco's personal AI assistant with full access to his work context.

        # Your Role
        \(profile)

        # Current Projects
        \(initiatives)

        # Key Stakeholders
        \(stakeholders)
        """

        // Add tone of voice if available
        if let tone = toneOfVoice {
            prompt += """


            # Communication Style
            \(tone)
            """
        }

        // Add technical domains if available
        if let tech = technicalDomains {
            prompt += """


            # Technical Expertise
            \(tech)
            """
        }

        // Add today's summary if available
        if let summary = todaysSummary {
            prompt += """


            # Today's Summary
            \(summary)
            """
        }

        // Add available skills
        if !skillService.availableSkills.isEmpty {
            prompt += """


            # Available Skills
            You have access to the following executable skills:
            \(skillService.availableSkills.map { "- \($0.name): \($0.description)" }.joined(separator: "\n"))

            When the user asks you to run a workflow or perform automation, mention that you can execute these skills.
            Note: Skill execution is not yet implemented in the streaming API, so for now just mention what the skill would do.
            """
        }

        prompt += """


        # Guidelines
        - Be concise and actionable (match Rod's communication style from above)
        - Prioritize based on urgency and Rod's role
        - Proactively suggest relevant actions
        - When asked about meetings, check calendar via tools
        - When asked about Slack, check channels via tools
        - Always provide context from knowledge base when relevant
        - When asked "what should I focus on", reference today's urgent items and calendar
        - Use technical terminology Rod is familiar with (from Technical Expertise section)
        """

        return prompt
    }
}
