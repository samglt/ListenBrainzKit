// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct SearchUserRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(_ term: String) {
        self.data = .init(path: "/1/search/users",
                          method: .get,
                          queryItems: ["search_term": [term]])
    }

    struct Result: Decodable {
        var users: [UserResult]
    }

    struct UserResult: Decodable {
        var userName: String
    }
}
