// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBRecordingMeta: Decodable {
    /// Name of the recording
    let name: String
    /// Length of recording in milliseconds
    let length: Int?
    /// People involved in the recording
    let relations: [LBRecordingRelation]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.length = try container.decodeIfPresent(Int.self, forKey: .length)
        self.relations = try (container.decodeIfPresent([LBRecordingRelation].self, forKey: .relations)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case name
        case length
        case relations = "rels"
    }
}

public struct LBArtistMeta: Decodable {
    /// This artist's MBID
    let id: UUID
    /// The name of the artist
    let name: String
    /// How this artist's credit should be joined with others
    let joinPhrase: String?
    /// When the artist started (birth/formation/creation)
    let beginYear: Int?
    /// When the artist finished (death/dissolution)
    let endYear: Int?
    /// Gender of the artist, if applicable
    let gender: Gender?
    /// The area the artist is associated with or originated from
    let area: String?
    /// Artist type (person, group, etc.)
    let type: ArtistType?
    /// Map from type of link to link. Types listed here: https://musicbrainz.org/relationships/artist-url
    let links: [String: String]
    /// Tags associated with this artist (Only populated from /metadata/artist/)
    let tags: [LBTag]

    enum ArtistType: Equatable, Decodable {
        case character
        case choir
        case group
        case orchestra
        case person

        case other
        case unrecognized(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)

            self =
                switch raw.lowercased() {
                case "choir":
                    .choir
                case "orchestra":
                    .orchestra
                case "person":
                    .person
                case "group":
                    .group
                case "character":
                    .character
                case "other":
                    .other
                default:
                    .unrecognized(raw)
                }
        }
    }

    enum Gender: Equatable, Decodable {
        case female
        case male
        case other
        case unrecognized(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)

            self =
                switch raw.lowercased() {
                case "female":
                    .female
                case "male":
                    .male
                case "other":
                    .other
                default:
                    .unrecognized(raw)
                }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.joinPhrase = try container.decodeIfPresent(String.self, forKey: .joinPhrase)
        self.beginYear = try container.decodeIfPresent(Int.self, forKey: .beginYear)
        self.endYear = try container.decodeIfPresent(Int.self, forKey: .endYear)
        self.gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        self.area = try container.decodeIfPresent(String.self, forKey: .area)
        self.type = try container.decodeIfPresent(ArtistType.self, forKey: .type)
        self.links = try (container.decodeIfPresent([String: String].self, forKey: .links)) ?? [:]

        if let tagsContainer = try container.decodeIfPresent(ArtistMetaTags.self, forKey: .tag),
           let tags = tagsContainer.artist {
            self.tags = tags
        } else { self.tags = [] }
    }

    enum CodingKeys: String, CodingKey {
        case id = "artistMbid"
        case name
        case joinPhrase
        case beginYear
        case endYear
        case gender
        case area
        case type
        case links = "rels"
        case tag
    }
}

struct ArtistMetaTags: Decodable {
    let artist: [LBTag]?
}

public struct LBReleaseMeta: Decodable {
    let mbid: UUID
    let releaseGroupMbid: UUID

    let name: String
    let albumArtistName: String
    /// Year of release
    let year: Int?
    /// Cover art file ID in the Cover Art Archive
    let caaId: Int?
    /// Release's MBID on Cover Art Archive
    let caaReleaseMbid: UUID?
}
