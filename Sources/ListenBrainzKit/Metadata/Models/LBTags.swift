// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTags: Decodable {
    let artist: [UUID: [LBTag]]
    let recording: [LBTag]
    let releaseGroup: [LBTag]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recording = try container.decodeIfPresent([LBTag].self, forKey: .recording) ?? []
        self.releaseGroup = try container.decodeIfPresent([LBTag].self, forKey: .releaseGroup) ?? []
        let flatArtistTags = try container.decodeIfPresent([ArtistTag].self, forKey: .artist) ?? []
        var dict = [UUID: [LBTag]]()
        for flatArtistTag in flatArtistTags {
            let uuid = flatArtistTag.artistMbid
            if dict[uuid] == nil { dict[uuid] = [] }
            dict[uuid]?.append(LBTag(tag: flatArtistTag.tag,
                                     voteCount: flatArtistTag.count,
                                     genreMbid: flatArtistTag.genreMbid))
        }
        self.artist = dict
    }

    public struct ArtistTag: Decodable {
        let tag: String
        let count: Int
        let genreMbid: UUID?
        let artistMbid: UUID
    }

    enum CodingKeys: String, CodingKey {
        case artist
        case recording
        case releaseGroup
    }
}
