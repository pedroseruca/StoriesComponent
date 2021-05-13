import Foundation

public struct Story: Codable {
    let imageUrl: URL?
    let type: StoryType

    public init(imageUrl: URL, type: StoryType) {
        self.imageUrl = imageUrl
        self.type = type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = URL(string: try container.decode(String.self, forKey: .imageUrl))
        type = try container.decode(StoryType.self, forKey: .type)
    }
}

extension Story {
    public enum StoryType: String, Codable {
        case image
        // to do case video
    }
}
