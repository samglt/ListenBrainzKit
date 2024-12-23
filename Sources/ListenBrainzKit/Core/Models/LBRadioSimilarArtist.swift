// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBRadioSimilarArtist: Decodable {
    let artistMbid: UUID
    let artistName: String

    let recordings: [Recording]

    public struct Recording: Decodable {
        let recordingMbid: UUID
        let totalListenCount: Int
    }
}
