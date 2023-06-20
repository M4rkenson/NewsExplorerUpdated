import SwiftUI

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title ?? "")
                .font(.headline)
            Text(article.description ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        
        .padding(8)
    }
}
