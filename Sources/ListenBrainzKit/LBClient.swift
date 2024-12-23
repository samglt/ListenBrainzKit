// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBClient: Sendable {
    public let core: LBCoreClient
    public let metadata: LBMetadataClient

    public init(token: String, customRoot: URL? = nil) {
        let client = ListenBrainzAPIClient(token: token, root: customRoot)

        self.core = LBCoreClient(client)
        self.metadata = LBMetadataClient(client)
    }
}
