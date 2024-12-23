// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct ValidateTokenRequest: APIRequest {
    typealias Result = LBTokenInfo

    let data: APIRequestData<NoBody>

    init() {
        self.data = .init(path: "/1/validate-token",
                          method: .get,
                          statusErrors: [400: .noToken])
    }
}
