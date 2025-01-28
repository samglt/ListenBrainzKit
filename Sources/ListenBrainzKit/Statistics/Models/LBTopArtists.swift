// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTopArtists: Decodable {
    let artists: [Artist]
    /// Total artists listened to beyond what's in .artists. Only populated from user
    let totalArtistCount: Int?
    let lastUpdated: Date
    let from: Date
    let to: Date

    struct Artist: Decodable {
        let mbid: UUID?
        let name: String
        let listenCount: Int

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case mbid = "artistMbid"
            case name = "artistName"
            case listenCount
        }
    }

    enum CodingKeys: String, CodingKey {
        case artists
        case totalArtistCount
        case lastUpdated
        case from = "fromTs"
        case to = "toTs"
    }
}
