import Foundation
import KeychainAccess

class NewsNetworkManager: ObservableObject {
    @Published var articles: [Article] = []
    private let baseURL = "https://newsapi.org/v2"
    init() {
            handleAuthenticationSuccess(token: "25123cd1605c4258b764be26f22f4c25")
        }
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let token = KeychainStorage.shared.accessToken,
              let url = URL(string: "\(baseURL)/everything?q=apple&apiKey=\(token)") else { completion(.failure(NetworkError.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(ArticlesResponse.self, from: data)
                            DispatchQueue.main.async {
                                self.articles = response.articles
                                completion(.success(response.articles))
                            }
            } catch(let error) {completion(.failure(error))}
        }.resume()
    }
    func handleAuthenticationSuccess(token: String) {
        KeychainStorage.shared.accessToken = token
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
