// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct MetadataArtistRequest: APIRequest {
    typealias Result = [LBArtistMeta]
    let data: APIRequestData<NoBody>

    init(mbids: [UUID], incTags: Bool) {
        self.data = .init(path: "/1/metadata/artist/",
                          method: .get,
                          queryItems: [
                              "artist_mbids": [mbids.map(\.uuidString).joined(separator: ",")],
                              "inc": incTags ? ["tag"] : [],
                          ],
                          statusErrors: [400: .invalidParam])
    }
}
