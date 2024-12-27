// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct MetadataSubmitMappingRequest: APIRequest {
    typealias Result = NoResult
    let data: APIRequestData<Body>

    init(msid: UUID, mbid: UUID) {
        self.data = .init(path: "/1/metadata/submit_manual_mapping/",
                          method: .post,
                          body: Body(recordingMsid: msid, recordingMbid: mbid),
                          statusErrors: [400: .invalidJSON,
                                         401: .invalidAuth])
    }

    struct Body: Encodable {
        let recordingMsid: UUID
        let recordingMbid: UUID
    }
}
