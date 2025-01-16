// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
@testable import ListenBrainzKit
import Testing

@Suite struct LBRecordingsTests {
    @Test("submitFeedback with mbid")
    func submitFeedbackMbid() async throws {
        let mbid = UUID(uuidString: "abababab-abab-abab-abab-abababababab")!

        let client = LBRecordingsClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitFeedback(mbid: mbid, score: .love)
        let request = try #require(((client.apiClient as? MockAPIClient)?.request as? RecordingFeedbackRequest)?.data)

        #expect(request.body?.recordingMbid == mbid)
        #expect(request.body?.recordingMsid == nil)
        #expect(request.body?.score == 1)
    }

    @Test("submitFeedback with msid")
    func submitFeedbackMsid() async throws {
        let msid = UUID(uuidString: "12121212-1212-1212-1212-121212121212")!

        let client = LBRecordingsClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitFeedback(msid: msid, score: .hate)
        let request = try #require(((client.apiClient as? MockAPIClient)?.request as? RecordingFeedbackRequest)?.data)

        #expect(request.body?.recordingMbid == nil)
        #expect(request.body?.recordingMsid == msid)
        #expect(request.body?.score == -1)
    }

    @Test("LBFeedback deserialization")
    func decodeFeedback() async throws {
        let raw = """
        {"created": 1736100000,
           "recording_mbid": "9d763275-0b67-4edf-8aee-3d9511068716",
           "recording_msid": null,
           "score": 1,
           "track_metadata": {"artist_name": "Kylie Minogue",
                              "mbid_mapping": {"artist_mbids": ["2fddb92d-24b2-46a5-bf28-3aed46f4684c"],
                                               "artists": [{"artist_credit_name": "Kylie Minogue",
                                                            "artist_mbid": "2fddb92d-24b2-46a5-bf28-3aed46f4684c",
                                                            "join_phrase": ""}],
                                               "caa_id": 13226700705,
                                               "caa_release_mbid": "8d3e2f07-e3f4-4c41-942a-54b59a812b1b",
                                               "recording_mbid": "9d763275-0b67-4edf-8aee-3d9511068716",
                                               "release_mbid": "7421153c-1740-471e-ad2d-e3741b9a3b96"},
                              "release_name": "Fever",
                              "track_name": "Can’t Get You Out of My Head"},
           "user_id": "a_user"}
        """

        let feedback = try JSONDecoder.ListenBrainz.decode(LBFeedback.self, from: raw.data(using: .utf8)!)
        #expect(feedback.score == .love)
        #expect(feedback.trackMetadata?.mbidMapping?.releaseMbid == UUID(uuidString: "7421153c-1740-471e-ad2d-e3741b9a3b96")!)
    }
}
