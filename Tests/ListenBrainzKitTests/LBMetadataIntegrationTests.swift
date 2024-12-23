// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
import Testing

@testable import ListenBrainzKit

@Suite(.serialized)
struct LBMetadataIntegrationTests {
    let username: String
    let client: LBClient

    init() async throws {
        let token = ProcessInfo.processInfo.environment["LISTENBRAINZ_TOKEN"] ?? ""
        let client = LBClient(token: token)

        let validation = !token.isEmpty ? try await client.core.isTokenValid() : .init(valid: false)

        self.client = client
        self.username = validation.userName ?? ""
    }

    @Test func getRecordingFullMetadata() async throws {
        let result = try #require(
            try await client.metadata.recording(
                mbid: UUID(uuidString: "e2ce530f-c710-4376-91dd-9940ac902254")!,
                including: [.tag, .release, .artist]
            ))

        #expect(result.recording.name == "Here With Me")
        #expect(result.recording.length != nil)

        #expect(
            !result.tags!.artist[UUID(uuidString: "d1353a0c-26fb-4318-a116-defde9c7c9ad")!]!.isEmpty
        )
        #expect(!result.tags!.recording.isEmpty)
        #expect(!result.tags!.releaseGroup.isEmpty)

        #expect(result.release!.year == 1999)

        #expect(result.artist!.name == "Dido")
        #expect(result.artist!.artists[0].type == .person)
    }

    @Test("Nonexistant recording UUID returns nil")
    func getRecordingMetadataBadID() async throws {
        let result =
            try await client
                .metadata
                .recording(
                    mbid: UUID(uuidString: "abcdeabc-abcd-abcd-abcd-abcabcabcabc")!,
                    including: [.tag, .release, .artist]
                )

        #expect(result == nil)
    }

    @Test("Nonsense lookup data gets no result")
    func lookupNonexistant() async throws {
        let result =
            try await client
                .metadata
                .lookup(artist: "abcdefghi", recording: "xyz12345", release: "zyxwvut")

        #expect(result == nil)
    }

    @Test func lookup() async throws {
        let result = try #require(
            try await client
                .metadata
                .lookup(
                    artist: "dido", recording: "thank you", release: "no angel", metadata: true,
                    including: [.tag, .release, .artist]
                ))

        #expect(result.artistCreditName == "Dido")
        #expect(result.recordingName == "Thankyou")
        #expect(result.releaseName == "No Angel")

        #expect(result.metadata!.recording.name == "Thankyou")
        #expect(result.metadata!.recording.length != nil)

        #expect(
            !result.metadata!.tags!.artist[
                UUID(uuidString: "d1353a0c-26fb-4318-a116-defde9c7c9ad")!
            ]!.isEmpty)
        #expect(!result.metadata!.tags!.recording.isEmpty)
        #expect(!result.metadata!.tags!.releaseGroup.isEmpty)

        #expect(result.metadata!.release!.year == 1999)

        #expect(result.metadata!.artist!.name == "Dido")
        #expect(result.metadata!.artist!.artists[0].type == .person)
    }

    @Test func multipleLookups() async throws {
        let result =
            try await client
                .metadata
                .lookup(lookups: [
                    .init(artist: "Dido", recording: "Thankyou", release: "No Angel"),
                    .init(artist: "Dido", recording: "abcabcabc", release: "No Angel"),
                ])
        let first = try #require(result[0])

        #expect(first.artistCreditName == "Dido")
        #expect(first.recordingName == "Thankyou")
        #expect(first.releaseName == "No Angel")

        #expect(result[1] == nil)
    }

    @Test func releaseGroup() async throws {
        let result = try #require(
            try await client
                .metadata
                .releaseGroup(
                    mbid: UUID(uuidString: "65e2f5a8-aa88-321b-852c-a900773ec300")!,
                    including: [.artist, .tag, .release]
                ))

        #expect(result.artist!.name == "Dido")
    }

    @Test func artists() async throws {
        let nonexistant = UUID(uuidString: "0f6bd1e4-fbe1-4f50-aa9b-94c450ec0f11")!
        let existant = UUID(uuidString: "5adcb9d9-5ea2-428d-af46-ef626966e106")!
        let result = try #require(
            try await client
                .metadata
                .artists(mbids: [nonexistant, existant], includeTags: true))

        #expect(result[nonexistant] == nil)
        let existantRes = try #require(result[existant])
        #expect(existantRes.tags.count > 0)
        #expect(existantRes.name == "Beth Gibbons")
    }
}
