import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            }
        }
        .autocapitalization(.none)
        .padding()
    }
}

