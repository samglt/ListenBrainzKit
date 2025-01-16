// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct RecordingUserFeedbackRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(username: String, score: LBScore?, count: Int?, offset: Int?, metadata: Bool?) {
        var query = [String: [String]]()

        query.setQueryItem("score", value: score?.rawValue)
        query.setQueryItem("count", value: count)
        query.setQueryItem("offset", value: offset)
        if let metadata { query.setQueryItem("metadata", value: metadata ? "true" : "false") }

        self.data = .init(path: "/1/feedback/user/\(username)/get-feedback",
                          method: .get,
                          queryItems: query,
                          headers: [:],
                          body: nil,
                          statusErrors: [:])
    }

    struct Result: Decodable {
        let count: Int
        let feedback: [LBFeedback]
        let offset: Int
        let totalCount: Int
    }
}
