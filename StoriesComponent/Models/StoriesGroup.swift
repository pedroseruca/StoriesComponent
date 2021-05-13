
import Foundation

public struct StoriesGroup: Codable {
    public let name: String
    public let imageUrl: URL?
    public let list: [Story]

    public init(name: String, imageUrl: URL, list: [Story]) {
        self.name = name
        self.imageUrl = imageUrl
        self.list = list
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = URL(string: try container.decode(String.self, forKey: .imageUrl))
        list = try container.decode([Story].self, forKey: .list)
    }
}
