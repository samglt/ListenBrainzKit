// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct SubmitListensRequest: APIRequest {
    typealias Result = NoResult

    let data: APIRequestData<Body>

    init(type: LBListenType, submissions: [Payload]) {
        self.data = .init(path: "/1/submit-listens",
                          method: .post,
                          headers: ["Content-Type": "application/json"],
                          body: .init(listenType: type.rawValue,
                                      payload: submissions),
                          statusErrors: [400: .invalidJSON,
                                         401: .invalidAuth])
    }

    struct Body: Encodable {
        let listenType: String
        let payload: [Payload]
    }

    struct Payload: Codable {
        var listenedAt: Date?
        var trackMetadata: LBTrackMetadata
    }
}
