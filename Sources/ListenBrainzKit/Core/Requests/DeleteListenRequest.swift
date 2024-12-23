// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct DeleteListenRequest: APIRequest {
    typealias Result = NoResult

    let data: APIRequestData<Body>

    init(listenedAt: Date, recordingMsid: UUID) {
        self.data = .init(path: "/1/delete-listen",
                          method: .post,
                          headers: ["Content-Type": "application/json"],
                          body: .init(listenedAt: listenedAt.unixTimestamp(), recordingMsid: recordingMsid),
                          statusErrors: [400: .invalidJSON,
                                         401: .invalidAuth])
    }

    struct Body: Encodable {
        let listenedAt: Int
        let recordingMsid: UUID
    }
}
