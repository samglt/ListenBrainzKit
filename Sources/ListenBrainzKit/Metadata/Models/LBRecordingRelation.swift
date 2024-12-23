// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// A relation between an artist and a recording
public struct LBRecordingRelation: Decodable {
    let artistName: String
    let artistMbid: UUID
    /// The type of the artist's involvement (vocal, instrument, etc.)
    let type: String
    /// Instrument played, if any
    let instrument: String?
}
