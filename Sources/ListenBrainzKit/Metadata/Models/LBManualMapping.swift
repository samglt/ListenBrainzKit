// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// Represents a mapping from a recording's MessyBrainz ID to a MusicBrainz ID
public struct LBManualMapping: Decodable {
    /// MessyBrainz ID
    let msid: UUID
    /// MusicBrainz ID
    let mbid: UUID

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: MappingKey.self)
        let mapping = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .mapping)

        self.msid = try mapping.decode(UUID.self, forKey: .msid)
        self.mbid = try mapping.decode(UUID.self, forKey: .mbid)
    }

    enum MappingKey: String, CodingKey {
        case mapping
    }

    enum CodingKeys: String, CodingKey {
        case msid = "recordingMsid"
        case mbid = "recordingMbid"
    }
}
