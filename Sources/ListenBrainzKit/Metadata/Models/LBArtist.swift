/// Single credit for one or more artists, with metadata for each one
public struct LBArtist: Decodable {
    /// Name of the credited artist(s) (i.e. Alice & Bob feat. Charlie)
    let name: String
    /// Artist credit ID
    let artistCreditId: Int
    /// Metadata for each artist
    let artists: [LBArtistMeta]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.artistCreditId = try container.decode(Int.self, forKey: .artistCreditId)
        self.artists = try (container.decodeIfPresent([LBArtistMeta].self, forKey: .artists)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case name
        case artistCreditId
        case artists
    }
}
