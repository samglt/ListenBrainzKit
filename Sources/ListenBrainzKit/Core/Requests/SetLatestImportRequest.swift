// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct SetLatestImportRequest: APIRequest {
    typealias Result = NoResult
    let data: APIRequestData<Body>

    init(date: Date) {
        self.data = .init(path: "/1/latest-import",
                          method: .post,
                          body: .init(ts: date),
                          statusErrors: [400: .invalidJSON,
                                         401: .invalidAuth])
    }

    public struct Body: Encodable {
        var ts: Date
    }
}
