// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct RecordingFeedbackRequest: APIRequest {
    typealias Result = NoResult

    let data: APIRequestData<Body>

    init(score: LBScore, recordingMbid: UUID?, recordingMsid: UUID?) {
        self.data = .init(path: "/1/feedback/recording-feedback",
                          method: .post,
                          queryItems: [:],
                          headers: ["Content-Type": "application/json"],
                          body: .init(score: score.rawValue,
                                      recordingMbid: recordingMbid,
                                      recordingMsid: recordingMsid),
                          statusErrors: [400: .invalidJSON,
                                         401: .invalidAuth])
    }

    struct Body: Encodable {
        let score: Int
        let recordingMbid: UUID?
        let recordingMsid: UUID?
    }
}
