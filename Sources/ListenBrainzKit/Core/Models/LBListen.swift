// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBUserListens: Decodable {
    let newestListen: Date
    let oldestListen: Date
    let listens: [LBListen]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKeys.self)
        let payload = try container.nestedContainer(keyedBy: PayloadKeys.self, forKey: .payload)

        self.newestListen = try payload.decode(Date.self, forKey: .latestListenTs)
        self.oldestListen = try payload.decode(Date.self, forKey: .oldestListenTs)
        self.listens = try (payload.decodeIfPresent([LBListen].self, forKey: .listens)) ?? []
    }

    enum OuterKeys: String, CodingKey {
        case payload
    }

    enum PayloadKeys: String, CodingKey {
        case latestListenTs
        case oldestListenTs
        case listens
        // case count
        // case userId
    }
}

public struct LBListen: Decodable {
    let insertedAt: Date
    let listenedAt: Date
    let recordingMsid: UUID
    let trackMetadata: LBTrackMetadata
}

public struct LBListenSubmission {
    let listenedAt: Date
    let meta: LBTrackMetadata

    /// A listen submission with metadata and listening timestamp
    /// Metadata matching is fuzzy and can tolerate capitalization
    /// and spelling differences
    ///
    /// > Note: Dates are truncated to Int timestamps, so
    /// > you cannot rely listenedAt equaling a Date that
    /// > comes back from ListenBrainz
    ///
    /// - Parameters:
    ///   - meta:       Track metadata. More means better matching
    ///   - listenedAt: Date the listen began
    /// - Returns: return
    public init(meta: LBTrackMetadata, listenedAt: Date) {
        self.listenedAt = listenedAt
        self.meta = meta
    }
}
