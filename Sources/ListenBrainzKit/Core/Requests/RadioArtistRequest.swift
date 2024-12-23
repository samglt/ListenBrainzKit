// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

struct RadioArtistRequest: APIRequest {
    typealias Result = [String: [RadioSimilarArtistResult]]
    let data: APIRequestData<NoBody>

    init(artistMbid: UUID, mode: LBRadioMode,
         maxSimilarArtists: Int, maxRecordingsPerArtist: Int,
         minPop: Int, maxPop: Int) {
        var query = [String: [String]]()
        query["mode"] = [mode.rawValue]
        query.setQueryItem("max_similar_artists", value: maxSimilarArtists)
        query.setQueryItem("max_recordings_per_artist", value: maxRecordingsPerArtist)
        query.setQueryItem("pop_begin", value: max(min(minPop, 100), 0))
        query.setQueryItem("pop_end", value: max(min(maxPop, 100), 0))

        self.data = .init(path: "/1/lb-radio/artist/\(artistMbid)",
                          method: .get,
                          queryItems: query,
                          statusErrors: [400: .invalidParam])
    }

    struct RadioSimilarArtistResult: Decodable {
        let recordingMbid: UUID

        let similarArtistMbid: UUID
        let similarArtistName: String
        let totalListenCount: Int
    }
}
