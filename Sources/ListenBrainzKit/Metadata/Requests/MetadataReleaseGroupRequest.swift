// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct MetadataReleaseGroupRequest: APIRequest {
    typealias Result = ReleasesMetaMap

    let data: APIRequestData<NoBody>

    init(mbids: [UUID], including: [LBMetaInclusion]) {
        let inclusions = including.isEmpty ? nil : including.map(\.rawValue).joined(separator: " ")

        var query = [String: [String]]()
        query.setQueryItem("release_group_mbids", value: mbids.map(\.uuidString).joined(separator: ","))
        query.setQueryItem("inc", value: inclusions)

        self.data = .init(path: "/1/metadata/release_group",
                          method: .get,
                          queryItems: query,
                          statusErrors: [400: .badRequest])
    }
}
