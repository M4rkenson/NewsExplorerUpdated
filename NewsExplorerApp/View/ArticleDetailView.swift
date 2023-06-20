import SwiftUI
import Kingfisher

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            KFImage(URL(string: article.urlToImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title ?? "")
                    .font(.title)
                Text(article.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(article.author ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(article.publishedAt ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(article.source?.id ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(article.source?.name ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(article.title ?? "")
    }
}
