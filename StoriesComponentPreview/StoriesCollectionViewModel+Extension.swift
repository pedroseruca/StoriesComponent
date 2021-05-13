import Foundation
import StoriesComponent

extension StoriesCollectionViewModel {
    convenience init() {
        let url = Bundle.main.url(forResource: "mockResponse", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let model = try! JSONDecoder().decode(StoriesResponse.self, from: data)
        self.init(stories: model)
    }
}
