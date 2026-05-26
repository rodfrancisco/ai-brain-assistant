import SwiftUI
import AppKit

@main
struct AIBrainApp: App {
    @StateObject private var appState = AppState()

    init() {
        // CRITICAL: Set activation policy to regular app (not background)
        NSApplication.shared.setActivationPolicy(.regular)
    }

    var body: some Scene {
        WindowGroup {
            MenuBarView()
                .environmentObject(appState)
        }
        .commands {
            // Remove "New Window" command
            CommandGroup(replacing: .newItem) { }
        }
    }
}
