// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
import Testing

@testable import ListenBrainzKit

@Suite(.serialized)
struct LBCoreIntegrationTests {
    let username: String
    let client: LBClient

    init() async throws {
        let token = ProcessInfo.processInfo.environment["LISTENBRAINZ_TOKEN"] ?? ""
        let client = LBClient(token: token)
        let validation = try await client.core.isTokenValid()

        self.client = client
        self.username = validation.userName ?? ""
    }

    @Test("Search for the token's user")
    func searchForUser() async throws {
        let results = try await client.core.searchUser(term: username)
        #expect(results.count > 0)
        #expect(results.first! == username)
    }

    @Test func getListenCount() async throws {
        let count = try await client.core.userListensCount(username: username)
        #expect(count > 0)
    }

    @Test func getServicet() async throws {
        let services = try await client.core.userServices(username: username)
        #expect(services.contains { $0 == "musicbrainz-prod" })
    }

    @Test func invalidAuth() async throws {
        let invalidClient = LBClient(token: "badtoken")

        do {
            try await invalidClient.core.submitListen(
                meta: .init(artist: "Oasis", track: "Slide Away"), at: .now
            )
            assertionFailure("Submitting with invalid token should fail")
        } catch {
            let error = try #require(error as? LBError)
            #expect(error == .invalidAuth)
        }
    }

    @Test func radioRecordings() async throws {
        let recs = try await client.core.radioRecordingsFromTag(
            tag: "pop", pop: 50 ... 100, count: 2
        )

        #expect(recs.count == 2)
    }
}
