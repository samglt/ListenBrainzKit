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

        return try await (execNoContent(request))?.payload
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

        return try await (execNoContent(request))?.payload
    }

    /// Get a user's top releases by listen count
    ///   - user: The user to get top releases from
    ///   - count: Number of releases to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top releases for the given user. nil means LB hasn't calculated statistics yet
    public func topReleases(user: String,
                            count: Int? = nil, offset: Int? = nil,
                            range: LBStatRange? = nil) async throws -> LBTopReleases? {
        let request = StatsReleasesRequest(user: user, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    /// Get ListenBrainz' top releases by listen count
    /// - Parameters:
    ///   - count: Number of releases to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top releases across the site. nil means LB hasn't calculated statistics yet
    public func topReleasesSitewide(count: Int? = nil, offset: Int? = nil,
                                    range: LBStatRange? = nil) async throws -> LBTopReleases? {
        let request = StatsReleasesRequest(user: nil, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    /// Get a user's top release groups by listen count
    ///   - user: The user to get top groups from
    ///   - count: Number of groups to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to allTime
    /// - Returns: The top groups for the given user. nil means LB hasn't calculated statistics yet
    public func topReleaseGroups(user: String,
                                 count: Int? = nil, offset: Int? = nil,
                                 range: LBStatRange? = nil) async throws -> LBTopReleaseGroups? {
        let request = StatsReleaseGroupsRequest(user: user, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    /// Get ListenBrainz' top release groups by listen count
    /// - Parameters:
    ///   - count: Number of groups to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top groups across the site. nil means LB hasn't calculated statistics yet
    public func topReleaseGroupsSitewide(count: Int? = nil, offset: Int? = nil,
                                         range: LBStatRange? = nil) async throws -> LBTopReleaseGroups? {
        let request = StatsReleaseGroupsRequest(user: nil, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    /// Get a user's top recordings by listen count
    ///   - user: The user to get top recordings from
    ///   - count: Number of recordings to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top recordings for the given user. nil means LB hasn't calculated statistics yet
    public func topRecordings(user: String,
                              count: Int? = nil, offset: Int? = nil,
                              range: LBStatRange? = nil) async throws -> LBTopRecordings? {
        let request = StatsRecordingsRequest(user: user, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    /// Get ListenBrainz' top recordings by listen count
    /// - Parameters:
    ///   - count: Number of recordings to get
    ///   - offset: Offset for pagination
    ///   - range: Timeframe to get stats from. Defaults to All Time
    /// - Returns: The top recordings across the site. nil means LB hasn't calculated statistics yet
    public func topRecordingsSitewide(count: Int? = nil, offset: Int? = nil,
                                      range: LBStatRange? = nil) async throws -> LBTopRecordings? {
        let request = StatsRecordingsRequest(user: nil, count: count, offset: offset, range: range)

        return try await (execNoContent(request))?.payload
    }

    // Get a result which might get a 204: No Content response and treat it as a nil result
    private func execNoContent<T: APIRequest>(_ request: T) async throws -> T.Result? {
        do {
            return try await apiClient.execute(request)
        } catch LBError.noContent {
            return nil
        } catch {
            throw error
        }
    }
}
