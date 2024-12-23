// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct ReleasesMetaMap: Decodable {
    let releases: [UUID: LBRelease]

    init(from decoder: Decoder) throws {
        let dict = try (decoder.singleValueContainer()).decode([String: LBRelease].self)

        self.releases = Dictionary(dict.compactMap {
            if let uuid = UUID(uuidString: $0.key) {
                (uuid, $0.value)
            } else { nil }
        },
        uniquingKeysWith: { lhs, _ in lhs })
    }
}
