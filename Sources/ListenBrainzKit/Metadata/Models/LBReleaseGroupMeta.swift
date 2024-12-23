// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBReleaseGroupMeta: Decodable {
    /// Cover art file ID in the Cover Art Archive
    let caaId: Int?
    /// Release's MBID on Cover Art Archive
    let caaReleaseMbid: UUID?

    let name: String
    let date: Date?
    let type: ReleaseType?
    // Note: I can't find examples of releases that have rels populated so I haven't included it here
    // let rels: [[String: String]]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.caaId = try container.decodeIfPresent(Int.self, forKey: .caaId)
        self.caaReleaseMbid = try container.decodeIfPresent(UUID.self, forKey: .caaReleaseMbid)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(ReleaseType.self, forKey: .type)

        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.formatOptions = []
            self.date = dateFormatter.date(from: dateString)
        } else { self.date = nil }
    }

    enum CodingKeys: String, CodingKey {
        case caaId
        case caaReleaseMbid
        case name
        case date
        case type
    }

    enum ReleaseType: String, Decodable {
        case album = "Album"
        case single = "Single"
        case ep = "EP"
        case broadcast = "Broadcast"
        case other = "Other"
    }
}
