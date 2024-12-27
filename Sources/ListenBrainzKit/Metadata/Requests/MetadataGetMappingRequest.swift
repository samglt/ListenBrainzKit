// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct MetadataGetMappingRequest: APIRequest {
    typealias Result = LBManualMapping
    let data: APIRequestData<NoBody>

    init(msid: UUID) {
        self.data = .init(path: "/1/metadata/get_manual_mapping/",
                          method: .get,
                          queryItems: ["recording_msid": [msid.uuidString]],
                          statusErrors: [404: .notFound])
    }
}
