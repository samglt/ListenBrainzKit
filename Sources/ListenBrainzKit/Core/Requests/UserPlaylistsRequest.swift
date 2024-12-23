// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct UserPlaylistsRequest: APIRequest {
    typealias Result = RawPlaylistResponse

    let data: APIRequestData<NoBody>

    init(username: String, count: Int?, offset: Int?) {
        var query = [String: [String]]()
        query.setQueryItem("count", value: count)
        query.setQueryItem("offset", value: offset)

        self.data = .init(path: "/1/user/\(username)/playlists",
                          method: .get,
                          queryItems: query,
                          statusErrors: [404: .userNotFound])
    }
}
