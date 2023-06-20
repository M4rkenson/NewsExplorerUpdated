import Foundation

class NewsViewModel: ObservableObject{
    @Published var articles: [Article] = []
    @Published var searchKeyword: String = ""
    private var originalArticles: [Article] = []
    private let manager = NewsNetworkManager()
    @Published var selectedSortParameter: SortParameter = .date
    @Published var selectedTimePeriod : TimePeriod = .all
    @Published var sortAscending = true
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    func fetchArticles() {
        manager.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self?.articles = articles
                    self?.originalArticles = articles
                    self?.sortArticles()
                }
            case .failure(let error):
                print("Error fetching articles: \(error.localizedDescription)")
            }
        }
    }
    
    func searchArticles() {
        guard !searchKeyword.isEmpty else {
            return
        }
        let filteredArticles = articles.filter { article in
            return article.title?.localizedCaseInsensitiveContains(searchKeyword) == true ||
            article.description?.localizedCaseInsensitiveContains(searchKeyword) == true
        }
        DispatchQueue.main.async {
            self.articles = filteredArticles
        }
    }
    
    func filteredArticlesbyDate(selectedTimePeriod: TimePeriod) -> [Article]{
        let oneDayInterval: TimeInterval = 24 * 60 * 60
        let oneWeekInterval: TimeInterval = 7 * oneDayInterval
        let oneMonthInterval: TimeInterval = 30 * oneDayInterval
        let filteredArticles: [Article]
        
        switch selectedTimePeriod {
        case .day:
            filteredArticles = filterArticlesByTimeInterval(minInterval: 1, maxInterval: oneWeekInterval)
        case .week:
            filteredArticles = filterArticlesByTimeInterval(minInterval: oneWeekInterval, maxInterval: oneMonthInterval)
        case .month:
            filteredArticles = filterArticlesByTimeInterval(minInterval: oneMonthInterval, maxInterval: TimeInterval.greatestFiniteMagnitude)
        case .all:
            filteredArticles = originalArticles
        }
        return filteredArticles
    }
    
    func sortArticles() {
        var sortedArticles = filteredArticlesbyDate(selectedTimePeriod: selectedTimePeriod)
        
        switch selectedSortParameter {
        case .date:
            sortedArticles = sortArticlesByParameter(filteredArticles:sortedArticles,keyPath: \.publishedAt)
        case .author:
            sortedArticles = sortArticlesByParameter(filteredArticles:sortedArticles,keyPath: \.author)
        case .title:
            sortedArticles = sortArticlesByParameter(filteredArticles:sortedArticles,keyPath: \.title)
        case .description:
            sortedArticles = sortArticlesByParameter(filteredArticles:sortedArticles,keyPath: \.description)
        }
        DispatchQueue.main.async {
            self.articles = sortedArticles
        }
    }
    private func filterArticlesByTimeInterval(minInterval: TimeInterval, maxInterval: TimeInterval) -> [Article] {
        let currentDate = Date()
        return originalArticles.filter { article in
            if let publishedAt = article.publishedAt, let articleDate = dateFormatter.date(from: publishedAt) {
                let timeInterval = currentDate.timeIntervalSince(articleDate)
                return timeInterval >= minInterval && timeInterval <= maxInterval
            }
            return false
        }
    }
    
    private func sortArticlesByParameter<T: Comparable>(filteredArticles: [Article],keyPath: KeyPath<Article, T?>) -> [Article]{
        return filteredArticles.sorted { article1, article2 in
            let value1 = article1[keyPath: keyPath]
            let value2 = article2[keyPath: keyPath]
            if let comparableValue1 = value1, let comparableValue2 = value2 {
                return sortAscending ? comparableValue1 < comparableValue2 : comparableValue1 > comparableValue2
            }
            return false
        }
    }
}
