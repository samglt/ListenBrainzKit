// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct RecordingFeedbackForRequest: APIRequest {
    let data: APIRequestData<Body>

    init(mbids: [UUID], username: String) {
        self.data = .init(path: "/1/feedback/user/\(username)/get-feedback-for-recordings",
                          method: .post,
                          queryItems: [:],
                          headers: ["Content-Type": "application/json"],
                          body: .init(recordingMbids: mbids),
                          statusErrors: [400: .invalidJSON])
    }

    struct Body: Encodable {
        let recordingMbids: [UUID]
    }

    struct Result: Decodable {
        let feedback: [LBFeedback]
    }
}
