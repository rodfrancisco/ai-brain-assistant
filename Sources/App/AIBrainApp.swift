import SwiftUI
import AppKit

@main
struct AIBrainApp: App {
    @StateObject private var appState = AppState()

    init() {
        // Ensure only one instance runs
        if NSRunningApplication.runningApplications(withBundleIdentifier: "com.aibrain.assistant").count > 1 {
            NSApp.terminate(nil)
            return
        }

        // Alternative: Use a lock file to prevent multiple instances
        ensureSingleInstance()
    }

    var body: some Scene {
        MenuBarExtra("AI Brain", systemImage: "brain") {
            MenuBarView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
    }

    private func ensureSingleInstance() {
        let lockFilePath = NSTemporaryDirectory() + "aibrain-assistant.lock"
        let lockFileURL = URL(fileURLWithPath: lockFilePath)

        // Try to create lock file
        if FileManager.default.fileExists(atPath: lockFilePath) {
            // Check if the process in the lock file is still running
            if let pidString = try? String(contentsOf: lockFileURL, encoding: .utf8),
               let pid = Int32(pidString.trimmingCharacters(in: .whitespacesAndNewlines)),
               kill(pid, 0) == 0 {
                // Process is still running, exit this instance
                print("AI Brain Assistant is already running (PID: \(pid))")
                exit(0)
            } else {
                // Stale lock file, remove it
                try? FileManager.default.removeItem(at: lockFileURL)
            }
        }

        // Write our PID to the lock file
        let pid = ProcessInfo.processInfo.processIdentifier
        try? String(pid).write(to: lockFileURL, atomically: true, encoding: .utf8)

        // Set up signal handler to clean up lock file on exit
        signal(SIGTERM) { _ in
            let path = NSTemporaryDirectory() + "aibrain-assistant.lock"
            try? FileManager.default.removeItem(atPath: path)
            exit(0)
        }

        signal(SIGINT) { _ in
            let path = NSTemporaryDirectory() + "aibrain-assistant.lock"
            try? FileManager.default.removeItem(atPath: path)
            exit(0)
        }
    }
}
