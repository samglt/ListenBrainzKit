// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct GetLatestImportRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(username: String) {
        self.data = .init(path: "/1/latest-import",
                          method: .get,
                          queryItems: ["user_name": [username]])
    }

    public struct Result: Decodable {
        var musicbrainzId: String
        var latestImport: Date
    }
}
