// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct StatsActivityRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(user: String?, range: LBStatRange?) {
        var query = [String: [String]]()
        query.setQueryItem("range", value: range?.rawValue)

        if let user {
            self.data = .init(path: "/1/stats/user/\(user)/listening-activity",
                              method: .get,
                              queryItems: query,
                              headers: [:],
                              body: nil,
                              statusErrors: [400: .badRequest,
                                             404: .notFound,
                                             204: .noContent])
        } else {
            self.data = .init(path: "/1/stats/sitewide/listening-activity",
                              method: .get,
                              queryItems: query,
                              headers: [:],
                              body: nil,
                              statusErrors: [400: .badRequest,
                                             404: .notFound,
                                             204: .noContent])
        }
    }

    struct Result: Decodable {
        let payload: LBListeningActivity
    }
}
