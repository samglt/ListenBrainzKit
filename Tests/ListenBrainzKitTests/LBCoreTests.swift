// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
@testable import ListenBrainzKit
import Testing

@Suite struct LBCoreTests {
    @Test("searchUser gets a list of users")
    func searchUser() async throws {
        let mockRes = SearchUserRequest
            .Result(users: [.init(userName: "abc"),
                            .init(userName: "def")])
        let client = LBCoreClient(MockAPIClient(result: .success(mockRes)))

        #expect(try await client.searchUser(term: "") == ["abc", "def"])
    }

    @Test("Submit multiple listens")
    func submitListens() async throws {
        let date1 = Date.now.addingTimeInterval(-300)
        let submission1 = LBListenSubmission(meta: .init(artist: "Artist",
                                                         track: "Track",
                                                         release: "Release",
                                                         additionalInfo: .init(tracknumber: 12)),
                                             listenedAt: date1)

        let date2 = Date.now.addingTimeInterval(-600)
        let submission2 = LBListenSubmission(meta: .init(artist: "Another Artist",
                                                         track: "Track 2",
                                                         release: "Another Release",
                                                         additionalInfo: .init(tracknumber: 2)),
                                             listenedAt: date2)

        let client = LBCoreClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitListens([submission1, submission2])

        let request = try #require(((client.apiClient
                as? MockAPIClient)?.request
            as? SubmitListensRequest)?.data.body)

        #expect(request.listenType == "import")
        #expect(request.payload.count == 2)
        let firstPayload = try #require(request.payload.first)
        #expect(firstPayload.listenedAt == date1)
        #expect(firstPayload.trackMetadata == submission1.meta)
        let secondPayload = try #require(request.payload.last)
        #expect(secondPayload.listenedAt == date2)
        #expect(secondPayload.trackMetadata == submission2.meta)
    }

    @Test("Single listen is labeled as such")
    func submitSingleListen() async throws {
        let listenDate = Date.now.addingTimeInterval(-300)
        let listenMeta: LBTrackMetadata = .init(artist: "Artist",
                                                track: "Track",
                                                release: "Release",
                                                additionalInfo: .init(tracknumber: 12))
        let client = LBCoreClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitListen(meta: listenMeta, at: listenDate)

        let request = try #require(((client.apiClient
                as? MockAPIClient)?.request
            as? SubmitListensRequest)?.data.body)

        #expect(request.listenType == "single")
        #expect(request.payload.count == 1)
        let onlyPayload = try #require(request.payload.first)
        #expect(onlyPayload.listenedAt == listenDate)
        #expect(onlyPayload.trackMetadata == listenMeta)
    }

    @Test("Now playing submission is labeled as such")
    func submitNowPlaying() async throws {
        let listenMeta: LBTrackMetadata = .init(artist: "Artist",
                                                track: "Track",
                                                release: "Release",
                                                additionalInfo: .init(tracknumber: 12))
        let client = LBCoreClient(MockAPIClient(result: .success(NoResult())))
        _ = try await client.submitPlayingNow(meta: listenMeta)

        let request = try #require(((client.apiClient
                as? MockAPIClient)?.request
            as? SubmitListensRequest)?.data.body)

        #expect(request.listenType == "playing_now")
        #expect(request.payload.count == 1)
        let onlyPayload = try #require(request.payload.first)
        #expect(onlyPayload.listenedAt == nil)
        #expect(onlyPayload.trackMetadata == listenMeta)
    }

    @Test("radioRecordingsByArtist results")
    func radioByArtist() async throws {
        let artistMbid = UUID(uuidString: "38f59974-2f4d-4bfa-b2e3-d2696de1b675")!
        let recordingMbid = UUID(uuidString: "f7788ef4-641f-4303-a7d5-ea786b2258df")!
        let artistName = "Lille Mix"

        let mockRes = [artistMbid.uuidString:
            [RadioArtistRequest.RadioSimilarArtistResult(
                recordingMbid: recordingMbid,
                similarArtistMbid: artistMbid,
                similarArtistName: artistName, totalListenCount: 1234
            )]]
        let client = LBCoreClient(MockAPIClient(result: .success(mockRes)))

        let result = try await client
            .radioRecordingsFromArtist(artistMbid: artistMbid,
                                       mode: .easy, maxSimilarArtists: 1,
                                       maxRecordingsPerArtist: 2, pop: 12 ... 99)

        let onlyResult = try #require(result.first)
        #expect(onlyResult.artistMbid == artistMbid)
        #expect(onlyResult.artistName == artistName)
        let onlyRecording = try #require(onlyResult.recordings.first)
        #expect(onlyRecording.recordingMbid == recordingMbid)
        #expect(onlyRecording.totalListenCount == 1234)
    }

    @Test("radioRecordings popularity range")
    func radioPopRange() async throws {
        let mockRes = [String: RadioArtistRequest.RadioSimilarArtistResult]()
        let client = LBCoreClient(MockAPIClient(result: .success(mockRes)))

        let result = try await client
            .radioRecordingsFromArtist(artistMbid: UUID(uuidString: "38f59974-2f4d-4bfa-b2e3-d2696de1b675")!,
                                       mode: .hard, maxSimilarArtists: 123,
                                       maxRecordingsPerArtist: 345, pop: -323 ... 8462)
        #expect(result.isEmpty)

        let request = try #require((client.apiClient as? MockAPIClient)?.request as? RadioArtistRequest)
        #expect(request.data.queryItems["mode"] == ["hard"])
        #expect(request.data.queryItems["max_similar_artists"] == ["123"])
        #expect(request.data.queryItems["max_recordings_per_artist"] == ["345"])
        #expect(request.data.queryItems["pop_begin"] == ["0"])
        #expect(request.data.queryItems["pop_end"] == ["100"])
    }
}
