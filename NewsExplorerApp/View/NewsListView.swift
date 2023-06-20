import SwiftUI

struct NewsListView: View {
    @ObservedObject var controller: NewsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $controller.searchKeyword, onSearch: controller.searchArticles)
                Picker("Sort By", selection: $controller.selectedTimePeriod) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Text(period.rawValue)
                        }
                    }
                    .onChange(of: controller.selectedTimePeriod) { _ in
                        controller.sortArticles()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    Picker("Sort Parameter", selection: $controller.selectedSortParameter) {
                        ForEach(SortParameter.allCases, id: \.self) { parameter in
                            Text(parameter.rawValue)
                        }
                    }
                    .onChange(of: controller.selectedSortParameter) { _ in
                        controller.sortArticles()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    Button(action: {
                        controller.sortAscending.toggle()
                        controller.sortArticles()
                    }) {
                        Image(systemName: controller.sortAscending ? "arrow.up" : "arrow.down")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                
                List(controller.articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleRowView(article: article)
                    }
                }
            }
            .navigationBarTitle("News")
        }
        .onAppear {
            controller.fetchArticles()
        }
    }
}
