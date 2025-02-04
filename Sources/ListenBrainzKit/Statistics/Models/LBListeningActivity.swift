// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBListeningActivity: Decodable {
    let range: String
    let from: Date
    let to: Date
    let lastUpdated: Int
    let activity: [Chunk]

    struct Chunk: Codable {
        /// Human-readable description of this chunk's range
        let timeRange: String
        let from: Date
        let to: Date

        let listenCount: Int

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case timeRange
            case from = "fromTs"
            case to = "toTs"
            case listenCount
        }
    }

    enum CodingKeys: String, CodingKey {
        case range
        case from = "fromTs"
        case to = "toTs"
        case lastUpdated
        case activity = "listeningActivity"
    }
}
