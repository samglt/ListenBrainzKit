// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBLookup: Decodable {
    let artistCreditName: String
    let artistMbids: [UUID]
    let recordingMbid: UUID
    let recordingName: String
    let releaseMbid: UUID
    let releaseName: String

    let metadata: LBRecording?
}

struct OptLookup: Decodable {
    let artistCreditName: String?
    let artistMbids: [UUID]?
    let recordingMbid: UUID?
    let recordingName: String?
    let releaseMbid: UUID?
    let releaseName: String?

    func toLB() -> LBLookup? {
        if let artistCreditName,
           let artistMbids,
           let recordingMbid,
           let recordingName,
           let releaseMbid,
           let releaseName {
            .init(artistCreditName: artistCreditName,
                  artistMbids: artistMbids,
                  recordingMbid: recordingMbid,
                  recordingName: recordingName,
                  releaseMbid: releaseMbid,
                  releaseName: releaseName,
                  metadata: nil)
        } else { nil }
    }
}
