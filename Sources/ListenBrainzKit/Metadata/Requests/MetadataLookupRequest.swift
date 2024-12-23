// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct MetadataSingleLookupRequest: APIRequest {
    let data: APIRequestData<NoBody>

    init(lookup: LBLookupData, metadata: Bool, including: [LBMetaInclusion]) {
        let inclusions = including.isEmpty ? nil : including.reduce("") { $0 + ($0.isEmpty ? "" : " ") + $1.rawValue }

        var query = [String: [String]]()
        query.setQueryItem("artist_name", value: lookup.artist)
        query.setQueryItem("recording_name", value: lookup.recording)
        query.setQueryItem("release_name", value: lookup.release)
        query.setQueryItem("metadata", value: metadata ? "true" : "false")
        query.setQueryItem("inc", value: inclusions)

        self.data = .init(path: "/1/metadata/lookup/",
                          method: .get,
                          queryItems: query,
                          statusErrors: [400: .badRequest])
    }

    struct Result: Decodable {
        let wrappedRes: LBLookup?

        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.wrappedRes = try? container.decode(LBLookup.self)
        }
    }
}

public struct MetadataMultipleLookupRequest: APIRequest {
    typealias Result = [OptLookup]
    let data: APIRequestData<Body>

    init(lookups: [LBLookupData]) {
        let body = Body(recordings: lookups)
        self.data = .init(path: "/1/metadata/lookup",
                          method: .post,
                          headers: ["Content-Type": "application/json"],
                          body: body,
                          statusErrors: [400: .badRequest])
    }

    struct Body: Encodable {
        let recordings: [LBLookupData]
    }
}

public struct LBLookupData: Encodable {
    let artist: String
    let recording: String
    let release: String?

    enum CodingKeys: String, CodingKey {
        case artist = "artistName"
        case recording = "recordingName"
        case release = "releaseName"
    }
}
