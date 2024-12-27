// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct UserServicesRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(username: String) {
        self.data = .init(path: "/1/user/\(username)/services",
                          method: .get,
                          statusErrors: [401: .invalidAuth,
                                         403: .forbidden,
                                         404: .notFound])
    }

    struct Result: Decodable {
        var userName: String
        var services: [String]
    }
}
