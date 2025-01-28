// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTopReleases: Decodable {
    let releases: [Release]
    /// Total releases listened to beyond what's in .releases.
    /// Only populated for user requests
    let totalReleaseCount: Int?
    let lastUpdated: Date
    let from: Date
    let to: Date

    struct Release: Decodable {
        /// Only populated for user requests
        let artists: [Artist]?
        let artistMbids: [UUID]?
        let artistName: String
        let listenCount: Int
        let releaseMbid: UUID?
        let releaseName: String
    }

    struct Artist: Decodable {
        let name: String
        let mbid: UUID
        let joinPhrase: String

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case name = "artistCreditName"
            case mbid = "artistMbid"
            case joinPhrase
        }
    }

    enum CodingKeys: String, CodingKey {
        case releases
        case totalReleaseCount
        case lastUpdated
        case from = "fromTs"
        case to = "toTs"
    }
}
