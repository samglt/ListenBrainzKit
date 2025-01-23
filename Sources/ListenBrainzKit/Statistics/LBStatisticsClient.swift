// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBStatisticsClient: Sendable {
    let apiClient: any APIClient

    init(_ client: some APIClient) {
        self.apiClient = client
    }

    /// Get a user's top artists by listen count
    /// - Parameters:
    ///   - user: The user to get top artists from
    ///   - count: Number of artists to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top artists for the given user. nil means LB hasn't calculated statistics yet
    public func topArtists(user: String,
                           count: Int? = nil, offset: Int? = nil,
                           range: LBStatRange? = nil) async throws -> LBTopArtists? {
        let request = StatsArtistsRequest(user: user, count: count, offset: offset, range: range)

        do {
            let res = try await apiClient.execute(request)
            return res.payload
        } catch LBError.noContent {
            return nil
        } catch {
            throw error
        }
    }

    /// Get ListenBrainz' top artists by listen count
    /// - Parameters:
    ///   - count: Number of artists to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top artists across the site. nil means LB hasn't calculated statistics yet
    public func topArtistsSitewide(count: Int? = nil, offset: Int? = nil,
                                   range: LBStatRange? = nil) async throws -> LBTopArtists? {
        let request = StatsArtistsRequest(user: nil, count: count, offset: offset, range: range)
        let res = try await apiClient.execute(request)

        return res.payload
    }
}
