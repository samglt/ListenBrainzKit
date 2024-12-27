// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
@testable import ListenBrainzKit
import Testing

@Suite struct LBMetadataTests {
    @Test("Manual mapping submission")
    func manualMap() async throws {
        let messyId = UUID(uuidString: "12121212-1212-1212-1212-121212121212")!
        let musicbrainzId = UUID(uuidString: "abababab-abab-abab-abab-abababababab")!

        let client = LBMetadataClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitManualMapping(msid: messyId, mbid: musicbrainzId)
        let request = try #require(((client.apiClient as? MockAPIClient)?.request as? MetadataSubmitMappingRequest)?.data)

        #expect(request.body?.recordingMsid == messyId)
        #expect(request.body?.recordingMbid == musicbrainzId)
    }

    @Test("LBManualMapping Decode")
    func decodeManualMap() async throws {
        let raw = """
        {"mapping": {"created": "Wed, 1 Jan 2025 00:00:00 GMT",
        "recording_msid": "12121212-1212-1212-1212-121212121212",
        "recording_mbid": "abababab-abab-abab-abab-abababababab",
         "user_id": 36427},
         "status": "ok"}
        """

        let mapping = try JSONDecoder.ListenBrainz.decode(LBManualMapping.self, from: raw.data(using: .utf8)!)
        #expect(mapping.msid.uuidString == "12121212-1212-1212-1212-121212121212")
        #expect(mapping.mbid.uuidString == "ABABABAB-ABAB-ABAB-ABAB-ABABABABABAB")
    }
}
