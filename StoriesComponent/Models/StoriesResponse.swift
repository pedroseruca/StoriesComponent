
public struct StoriesResponse: Codable {
    public let stories: [StoriesGroup]
    
    public init(stories: [StoriesGroup]) {
        self.stories = stories
    }
}
