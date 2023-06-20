import SwiftUI

@main
struct NewsExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            let controller = NewsViewModel()
            NewsListView(controller: controller)
        }
    }
}
