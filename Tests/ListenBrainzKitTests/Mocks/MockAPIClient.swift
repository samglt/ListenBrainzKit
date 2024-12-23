// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
@testable import ListenBrainzKit

class MockAPIClient: APIClient, @unchecked Sendable {
    let result: Result<Any, LBError>
    var request: (any APIRequest)?

    init(result: Result<Any, LBError>, request: (any APIRequest)? = nil) {
        self.result = result
        self.request = request
    }

    func execute<Request: APIRequest>(_ request: Request) async throws -> Request.Result {
        guard let res = try (result.get()) as? Request.Result else {
            preconditionFailure("Mismatch between request and mocked result")
        }

        self.request = request

        return res
    }
}
