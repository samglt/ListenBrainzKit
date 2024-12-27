// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct UserSimilarToRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(username: String, other: String) {
        self.data = .init(path: "/1/user/\(username)/similar-to/\(other)",
                          method: .get,
                          statusErrors: [404: .notFound])
    }

    struct Result: Decodable {
        var payload: LBSimilarUser
    }
}
