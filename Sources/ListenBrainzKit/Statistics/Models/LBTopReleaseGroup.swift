// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTopReleaseGroups: Decodable {
    let releaseGroups: [ReleaseGroup]
    /// Total release groups listened to beyond what's in .releaseGroups. Only populated from user
    let totalReleaseGroupCount: Int?
    let lastUpdated: Date
    let from: Date
    let to: Date

    struct ReleaseGroup: Decodable {
        let artistMbids: [UUID]?
        let artistName: String
        /// Only populated by user request
        let artists: [Artist]?
        let releaseGroupMbid: UUID?
        let releaseGroupName: String
        let listenCount: Int
    }

    struct Artist: Decodable {
        let credit: String
        let mbid: UUID

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case credit = "artistCreditName"
            case mbid = "artistMbid"
        }
    }

    enum CodingKeys: String, CodingKey {
        case releaseGroups
        case totalReleaseGroupCount
        case lastUpdated
        case from = "fromTs"
        case to = "toTs"
    }
}
