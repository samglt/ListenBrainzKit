// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct UserListensRequest: APIRequest {
    typealias Result = LBUserListens

    let data: APIRequestData<NoBody>

    init(username: String, latest: Date?, earliest: Date?, count: Int?) {
        var query = [String: [String]]()
        query.setQueryItem("max_ts", value: latest?.unixTimestamp())
        query.setQueryItem("min_ts", value: earliest?.unixTimestamp())
        query.setQueryItem("count", value: count)

        self.data = .init(path: "/1/user/\(username)/listens",
                          method: .get,
                          queryItems: query,
                          statusErrors: [404: .userNotFound])
    }
}
