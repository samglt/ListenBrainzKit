// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct UserListensCountRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(username: String) {
        self.data = .init(path: "/1/user/\(username)/listen-count",
                          method: .get,
                          statusErrors: [404: .userNotFound])
    }

    struct Result: Decodable {
        var payload: Payload
    }

    struct Payload: Decodable {
        var count: Int
    }
}
