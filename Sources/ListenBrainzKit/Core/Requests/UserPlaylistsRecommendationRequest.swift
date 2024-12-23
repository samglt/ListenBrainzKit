// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct UserPlaylistsRecommendationRequest: APIRequest {
    typealias Result = RawPlaylistResponse

    let data: APIRequestData<NoBody>

    init(username: String) {
        self.data = .init(path: "/1/user/\(username)/playlists/recommendations",
                          method: .get,
                          statusErrors: [404: .userNotFound])
    }
}
