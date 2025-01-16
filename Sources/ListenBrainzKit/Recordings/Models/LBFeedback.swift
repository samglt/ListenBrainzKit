// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBFeedback: Decodable {
    let created: Date
    let recordingMbid: UUID
    let recordingMsid: UUID?
    let score: LBScore
    /// If populated, contains basic artist/track/release data and
    /// mbidMapping but not additionalInfo
    let trackMetadata: LBTrackMetadata?
    // userId: String
}
