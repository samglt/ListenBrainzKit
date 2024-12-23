// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct MetadataRecordingRequest: APIRequest {
    typealias Result = RecordingsMetaMap

    let data: APIRequestData<Body>

    init(mbids: [UUID], including: [LBMetaInclusion]) {
        let inclusions = including.isEmpty ? nil : including.reduce("") { $0 + ($0.isEmpty ? "" : " ") + $1.rawValue }

        if mbids.count <= 1,
           let mbid = mbids.first {
            var query = [String: [String]]()
            query.setQueryItem("recording_mbids", value: mbid.uuidString)
            query.setQueryItem("inc", value: inclusions)

            self.data = .init(path: "/1/metadata/recording/",
                              method: .get,
                              queryItems: query,
                              statusErrors: [400: .badRequest])
        } else {
            let body = Body(recordingMbids: mbids, inc: inclusions)
            self.data = .init(path: "/1/metadata/recording/",
                              method: .post,
                              body: body,
                              statusErrors: [400: .badRequest])
        }
    }

    struct Body: Encodable {
        let recordingMbids: [UUID]
        let inc: String?
    }
}
