import SwiftUI

struct ExportAccountsShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any] {
        do {
            return [try AccountStore.getFileURL()]
        }
        catch {
            return []
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ExportAccountsShareSheet>) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ExportAccountsShareSheet>) {
        // Do nothing
    }
}
