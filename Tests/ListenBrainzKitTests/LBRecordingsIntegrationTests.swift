// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
@testable import ListenBrainzKit
import Testing

@Suite(.serialized)
struct LBRecordingsIntegrationTests {
    let username: String
    let client: LBClient

    init() async throws {
        let token = ProcessInfo.processInfo.environment["LISTENBRAINZ_TOKEN"] ?? ""
        let client = LBClient(token: token)
        let validation = try await client.core.isTokenValid()

        self.client = client
        self.username = validation.userName ?? ""
    }

    /*
     @Test("Submit Feedback")
     func searchForUser() async throws {
         let mbid = UUID(uuidString: "9d763275-0b67-4edf-8aee-3d9511068716")!
         try await client.recordings.submitFeedback(mbid: mbid, score: .love)
         let feedback = try await (client.recordings.getFeedback(user: username,
                                                                     count: 1,
                                                                     metadata: true)).first!

         #expect(feedback.recordingMbid == mbid)
         #expect(feedback.trackMetadata!.mbidMapping!.recordingMbid == mbid)
     }

     @Test("Get your feedbacks")
     func getUserFeedback() async throws {
         let feedbacks = try await client.recordings.getFeedback(user: username, metadata: true)
         print(feedbacks)

     }
     */

    @Test("Feedbacks by mbid are from different users")
    func getMbidFeedback() async throws {
        let mbid = UUID(uuidString: "9d763275-0b67-4edf-8aee-3d9511068716")!
        let feedbacks = try await client.recordings.getFeedback(mbid: mbid, count: 2)

        #expect(feedbacks[0].user != feedbacks[1].user)
    }

    @Test("Feedback by mbid scores")
    func getMbidFeedbackScores() async throws {
        let mbid = UUID(uuidString: "9d763275-0b67-4edf-8aee-3d9511068716")!
        let feedbacks = try await client.recordings.getFeedback(mbid: mbid, score: .love, count: 2, offset: 1)

        #expect(feedbacks[0].user != feedbacks[1].user)
        #expect(feedbacks[0].score == .love)
        #expect(feedbacks[1].score == .love)
    }
}
