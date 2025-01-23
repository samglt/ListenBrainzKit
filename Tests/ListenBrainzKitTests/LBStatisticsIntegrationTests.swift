// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
import Testing

@testable import ListenBrainzKit

@Suite(.serialized)
struct LBStatisticsIntegrationTests {
    let username: String
    let client: LBClient

    init() async throws {
        let token = ProcessInfo.processInfo.environment["LISTENBRAINZ_TOKEN"] ?? ""
        let client = LBClient(token: token)
        let validation = try await client.core.isTokenValid()

        self.client = client
        self.username = validation.userName ?? ""
    }

    @Test("Your top artists has populated total artist count")
    func topArtists() async throws {
        if let res = try await client.stats.topArtists(user: username) {
            #expect(res.totalArtistCount != nil)
        }
    }

    @Test("Top artists sitewide doesn't populate total artist count")
    func topArtistsSitewide() async throws {
        let res = try #require(try await client.stats.topArtistsSitewide())
        #expect(res.totalArtistCount == nil)
    }

    @Test("Top artists limited and offset")
    func topArtistsSitewideLimited() async throws {
        let res = try #require(try await client.stats.topArtistsSitewide(count: 4, offset: 50, range: .month))
        #expect(res.totalArtistCount == nil)
        #expect(res.artists.count == 4)
    }
}
