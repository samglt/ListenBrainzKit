// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBRadioTag: Decodable {
    let recordingMbid: UUID

    let popularity: Float
    let source: String
    let tagCount: Int

    enum CodingKeys: String, CodingKey {
        case recordingMbid

        case popularity = "percent"
        case source
        case tagCount
    }
}
