// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct RawPlaylistResponse: Decodable {
    var count: Int?
    var offset: Int?
    var playlistCount: Int?
    var playlists: [PlaylistPayload]

    struct PlaylistPayload: Decodable {
        var playlist: RawPlaylist
    }
}

struct RawPlaylist: Decodable {
    var annotation: String?
    var creator: String
    var date: String?
    var duration: Int?
    var identifier: String
    var title: String
    var ext: PlaylistExtension
    var track: [RawPlaylistTrack]

    enum CodingKeys: String, CodingKey {
        case annotation
        case creator
        case date
        case duration
        case identifier
        case title
        case ext = "extension"
        case track
    }
}

struct RawPlaylistTrack: Decodable {
    var title: String?
    var album: String?
    var creator: String?
    var duration: Int?
    var identifier: [String]?
    var ext: TrackExtension?

    enum CodingKeys: String, CodingKey {
        case title
        case album
        case creator
        case duration
        case identifier
        case ext = "extension"
    }
}

struct PlaylistExtension: Decodable {
    var listenbrainz: ListenBrainzPlaylistExt

    enum CodingKeys: String, CodingKey {
        case listenbrainz = "https://musicbrainz.org/doc/jspf#playlist"
    }
}

struct ListenBrainzPlaylistExt: Decodable {
    var createdFor: String?
    var creator: String?
    var collaborators: [String]?
    var copiedFrom: String?
    var copiedFromDeleted: Bool?
    var isPublic: Bool
    var lastModifiedAt: String
    // var additionalMetadata:

    enum CodingKeys: String, CodingKey {
        case createdFor
        case creator
        case collaborators
        case copiedFrom
        case copiedFromDeleted
        case isPublic = "public"
        case lastModifiedAt
    }
}

struct TrackExtension: Decodable {
    var listenbrainz: ListenBrainzTrackExt
    enum CodingKeys: String, CodingKey {
        case listenbrainz = "https://musicbrainz.org/doc/jspf#track"
    }
}

struct ListenBrainzTrackExt: Decodable {
    var artistIdentifiers: [String]?
    var releaseIdentifier: String?
    var addedAt: String?
    var addedBy: String?
    var additionalMetadata: AdditionalMetadata?

    struct AdditionalMetadata: Decodable {
        var caaReleaseMbid: String? // uuid
        var caaId: Int?
        var artists: [Artist]?
    }

    struct Artist: Decodable {
        var artistCreditName: String?
        var artistMbid: String?
        var joinPhrase: String?
    }
}
