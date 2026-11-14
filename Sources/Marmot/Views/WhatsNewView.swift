import SwiftUI

/// In-app release highlights, shown once after each update lands via
/// Sparkle. Maintainers: refresh `WhatsNew.highlights` during the release
/// ritual — the version comparison handles the rest.
enum WhatsNew {

    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    static let highlights: [(icon: String, text: String)] = [
        ("sparkles",
         "Marmot is now version 1.0.0: the same app, starting over with a new version number and a fresh release history."),
        ("arrow.triangle.2.circlepath",
         "Your settings, History and Autopilot rules carry over, and updates keep arriving automatically."),
        ("mug",
         "Homebrew users now install Marmot from kasakir-ai/tap. If you used the old tap, its README shows the one-time move."),
        ("checkmark.shield",
         "As always, nothing is removed until you've reviewed it, and everything goes to the Trash so you can restore it from History.")
    ]

    /// True once per updated version, never on a fresh install (onboarding
    /// covers that) and never twice for the same version.
    static func shouldShow() -> Bool {
        guard !version.isEmpty else { return false }
        let seen = UserDefaults.standard.string(forKey: Prefs.lastSeenVersion)
        if seen == version { return false }
        if seen == nil {
            UserDefaults.standard.set(version, forKey: Prefs.lastSeenVersion)
            return false
        }
        return true
    }

    static func markSeen() {
        UserDefaults.standard.set(version, forKey: Prefs.lastSeenVersion)
    }
}

struct WhatsNewView: View {
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("🐿️").font(.system(size: 40))
                Text("What's new in Marmot \(WhatsNew.version)")
                    .font(.title3.weight(.semibold))
            }
            .padding(.top, 24)
            .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 14) {
                ForEach(WhatsNew.highlights, id: \.text) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.title3)
                            .foregroundStyle(Theme.accent)
                            .frame(width: 28)
                        Text(item.text)
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 28)

            Spacer()
            Divider()
            HStack {
                Spacer()
                Button("Nice — let's go") { onClose() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(width: 460, height: 380)
    }
}
