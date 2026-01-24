import SwiftUI

struct About: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("awesomenotchicon")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(width: 100, height: 100)

            VStack(spacing: 8) {
                Text("awesome notch")
                    .font(.system(size: 24, weight: .bold))
                Text("A macOS application that transforms your MacBook's notch into an interactive control center, providing quick access to media controls and system information directly from the top of your screen.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    
                Text("Version 1.5.3")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(role: .destructive) {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit App", systemImage: "power")
            }
            .buttonStyle(.borderedProminent)
            Text("© 2025 Y MENGSEA. All rights reserved.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .padding()
    }
}
