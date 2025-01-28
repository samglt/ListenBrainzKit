// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTopRecordings: Decodable {
    let recordings: [Recording]
    /// Total recordings listened to beyond what's in .recordings. Only populated from user
    let totalRecordingCount: Int?
    let lastUpdated: Date
    let from: Date
    let to: Date

    struct Recording: Decodable {
        let artistMbids: [UUID]?
        let artistName: String
        let listenCount: Int
        let recordingMbid: UUID?
        let releaseMbid: UUID?
        let releaseName: String
        let trackName: String
    }

    enum CodingKeys: String, CodingKey {
        case recordings
        case totalRecordingCount
        case lastUpdated
        case from = "fromTs"
        case to = "toTs"
    }
}
