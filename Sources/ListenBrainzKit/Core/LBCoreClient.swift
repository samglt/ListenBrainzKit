// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBCoreClient: Sendable {
    let apiClient: any APIClient

    init(_ client: some APIClient) {
        self.apiClient = client
    }

    /// Search for users
    /// - Parameters:
    ///   - term: The search term
    /// - Returns: List of usernames
    public func searchUser(term: String) async throws -> [String] {
        let request = SearchUserRequest(term)

        let result = try await apiClient.execute(request)
        return result.users.map(\.userName)
    }

    /// Submit a single listen
    ///
    /// > Note: Dates are truncated to Int timestamps, so you cannot
    /// > rely on a Date equaling a Date that comes from ListenBrainz
    ///
    /// - Parameters:
    ///   - meta: Metadata of the listened track
    ///   - at:   When playback started for the current listen
    public func submitListen(meta: LBTrackMetadata, at listenedAt: Date) async throws {
        let request = SubmitListensRequest(type: .single,
                                           submissions: [
                                               .init(listenedAt: listenedAt,
                                                     trackMetadata: meta),
                                           ])

        _ = try await apiClient.execute(request)
    }

    /// Set what's playing now
    /// - Parameters:
    ///   - meta: Metadata of the currently plaing track
    public func submitPlayingNow(meta: LBTrackMetadata) async throws {
        let request = SubmitListensRequest(type: .playingNow,
                                           submissions: [.init(listenedAt: nil, trackMetadata: meta)])

        _ = try await apiClient.execute(request)
    }

    /// Submit a batch of listens
    ///
    /// > Note: Dates are truncated to Int timestamps, so you cannot
    /// > rely on a Date equaling a Date that comes from ListenBrainz
    ///
    /// - Parameters:
    ///   - listens: List of listens, with time of listen and track metadata
    public func submitListens(_ listens: [LBListenSubmission]) async throws {
        let request = SubmitListensRequest(type: .importMultiple,
                                           submissions: listens.map {
                                               .init(listenedAt: $0.listenedAt,
                                                     trackMetadata: $0.meta)
                                           })

        _ = try await apiClient.execute(request)
    }

    /// Get listens from the given user, with optional limits on
    /// listen date and number of listens
    ///
    /// > Note: Dates are truncated to Int timestamps, so you cannot
    /// > rely on a Date equaling a Date that comes from ListenBrainz
    ///
    /// - Parameters:
    ///   - username: The user to get listens from
    ///   - latest:   Exclusive upper bound on listen data to return
    ///   - earliest: Exclusive lower bound on listen data to return
    ///   - count:    Limit on number of results to return
    /// - Returns: Listens from the given period
    public func userListens(username: String,
                            latest: Date? = nil, earliest: Date? = nil,
                            count: Int? = nil) async throws -> LBUserListens {
        let request = UserListensRequest(username: username,
                                         latest: latest, earliest: earliest, count: count)

        return try await apiClient.execute(request)
    }

    /// Get total number of listens for the given user
    /// - Parameters:
    ///   - username: The user to get listen count from
    /// - Returns: Number of listens for the given user
    public func userListensCount(username: String) async throws -> Int {
        let request = UserListensCountRequest(username: username)

        let result = try await apiClient.execute(request)
        return result.payload.count
    }

    /// Get what a user is currently playing
    /// - Parameters:
    ///   - username: The user to get currently playing info from
    /// - Returns: Metadata of currently playing track, or nil if nothing is playing
    public func userPlayingNow(username: String) async throws -> LBPlayingNow? {
        let request = UserPlayingNowRequest(username: username)

        let result = try await apiClient.execute(request)

        if let playingNow = result.payload.listens.first?.playingNow,
           let trackMetadata = result.payload.listens.first?.trackMetadata {
            return .init(
                playingNow: playingNow,
                trackMetadata: trackMetadata
            )
        } else {
            return nil
        }
    }

    /// Get users with similar music taste to the given user
    /// - Parameters:
    ///   - username: The user to find similar users to
    /// - Returns: List of similar users with their similarity
    public func userSimilarUsers(username: String) async throws -> [LBSimilarUser] {
        let request = UserSimilarUsersRequest(username: username)

        let result = try await apiClient.execute(request)

        return result.payload
    }

    /// Get the similarity of two users' music taste
    /// - Parameters:
    ///   - username: User to compare
    ///   - other:    Other user to compare
    /// - Returns: Similarity of `other` to `username`
    public func userSimilarTo(username: String, other: String) async throws -> LBSimilarUser {
        let request = UserSimilarToRequest(username: username, other: other)

        let result = try await apiClient.execute(request)
        return result.payload
    }

    /// Check whether the token is valid
    /// - Returns: Token validity and associated username if valid
    public func isTokenValid() async throws -> LBTokenInfo {
        let request = ValidateTokenRequest()

        let result = try await apiClient.execute(request)

        return result
    }

    /// Delete a listen with the given listen time and ID
    ///
    /// > Note: Dates are truncated to Int timestamps, so you cannot
    /// > rely on a Date equaling a Date that comes from ListenBrainz
    ///
    /// - Parameters:
    ///   - listenedAt:    The time of the listen
    ///   - recordingMsid: The MessyBrainz ID of the recording
    public func deleteListen(listenedAt: Date, recordingMsid: UUID) async throws {
        let request = DeleteListenRequest(listenedAt: listenedAt, recordingMsid: recordingMsid)

        _ = try await apiClient.execute(request)
    }

    /// Delete a given listen
    ///
    /// > Note: Dates are truncated to Int timestamps, so you cannot
    /// > rely on a Date equaling a Date that comes from ListenBrainz
    ///
    /// - Parameters:
    ///   - listen: The LBListen to delete
    public func deleteListen(_ listen: LBListen) async throws {
        try await deleteListen(
            listenedAt: listen.listenedAt, recordingMsid: listen.recordingMsid
        )
    }

    /// Get a user's playlists.
    /// - Parameters:
    ///   - username: User to get playlists from
    ///   - count:    Max number of playlists to get
    ///   - offset:   Offset when getting playlists
    /// - Returns: User's playlists, with metadata only and no tracks
    public func userPlaylists(
        username: String,
        count: Int? = nil, offset: Int? = nil
    ) async throws -> [LBPlaylistMetadata] {
        let request = UserPlaylistsRequest(username: username, count: count, offset: offset)
        let result = try await apiClient.execute(request)
        return result.playlists.map {
            LBPlaylistMetadata(raw: $0.playlist)
        }
    }

    /// Get playlists created for the given user
    /// - Parameters:
    ///   - username: User the playlists are created for
    ///   - count:    Max number of playlists to get
    ///   - offset:   Offset when getting playlists
    /// - Returns: List of playlist metadata, with no tracks
    public func userPlaylistsCreatedFor(
        username: String,
        count: Int? = nil, offset: Int? = nil
    ) async throws -> [LBPlaylistMetadata] {
        let request = UserPlaylistsCreatedForRequest(
            username: username, count: count, offset: offset
        )
        let result = try await apiClient.execute(request)
        return result.playlists.map {
            LBPlaylistMetadata(raw: $0.playlist)
        }
    }

    /// Get playlists where the given user is a collaborator
    /// - Parameters:
    ///   - username: Username of the collaborator
    ///   - count:    Max number of playlists to get
    ///   - offset:   Offset when getting playlists
    /// - Returns: List of playlist metadata, with no tracks
    public func userPlaylistsCollaborator(
        username: String,
        count: Int? = nil, offset: Int? = nil
    ) async throws -> [LBPlaylistMetadata] {
        let request = UserPlaylistsCollaboratorRequest(
            username: username, count: count, offset: offset
        )
        let result = try await apiClient.execute(request)
        return result.playlists.map {
            LBPlaylistMetadata(raw: $0.playlist)
        }
    }

    /// Get recommended playlists for the given user
    /// - Parameters:
    ///   - username: Username of the collaborator
    /// - Returns: List of playlist metadata, with no tracks
    public func userPlaylistsRecommendation(username: String) async throws -> [LBPlaylistMetadata] {
        let request = UserPlaylistsRecommendationRequest(username: username)
        let result = try await apiClient.execute(request)
        return result.playlists.map {
            LBPlaylistMetadata(raw: $0.playlist)
        }
    }

    /// Get services connected to the given user
    /// - Parameters:
    ///   - username: The user to get connected services from
    /// - Returns: List of services (eg. "spotify", "musicbrainz-prod", etc.)
    public func userServices(username: String) async throws -> [String] {
        let request = UserServicesRequest(username: username)

        let result = try await apiClient.execute(request)

        return result.services
    }

    /// Get recordings for use in LB radio with the specified tags and
    /// in the given popularity range
    /// - Parameters:
    ///   - tags:      List of tags to search for
    ///   - pop:       Popularity range of recordings (0-100)
    ///   - operation: Whether to match all tags, or any tag
    ///   - count:     Limit on number of recordings to return
    /// - Returns: List of recordings
    public func radioRecordingsFromTags(
        tags: [String], pop: ClosedRange<Int>,
        operation: LBOperator, count: Int? = nil
    ) async throws -> [LBRadioTag] {
        let minPop = pop.lowerBound
        let maxPop = pop.upperBound
        let request = RadioTagsRequest(
            tags: tags, operation: operation, minPop: minPop, maxPop: maxPop, count: count
        )

        let result = try await apiClient.execute(request)

        return result
    }

    /// Get recordings for use in LB radio with the specified tag and
    /// in the given popularity range
    /// - Parameters:
    ///   - tag:      Tag to search for
    ///   - pop:      Popularity range of recordings (0-100)
    ///   - count:    Limit on number of recordings to return
    /// - Returns: List of recordings
    public func radioRecordingsFromTag(
        tag: String, pop: ClosedRange<Int>,
        count: Int? = nil
    ) async throws -> [LBRadioTag] {
        let minPop = pop.lowerBound
        let maxPop = pop.upperBound
        let request = RadioTagsRequest(
            tags: [tag], operation: nil, minPop: minPop, maxPop: maxPop, count: count
        )

        let result = try await apiClient.execute(request)

        return result
    }

    /// Get recordings for use in LB radio with the given seed artist
    /// - Parameters:
    ///   - artistMbid:             The seed artist for this radio
    ///   - mode:                   Listenbrainz radio mode (see: https://troi.readthedocs.io/en/latest/lb_radio.html)
    ///   - maxSimilarArtists:      Max number of similar artists to get
    ///   - maxRecordingsPerArtist: Max number of recordings to get per artist
    ///   - pop:                    Popularity range of recordings (0-100)
    /// - Returns: List of similar releases with their artist information
    public func radioRecordingsFromArtist(
        artistMbid: UUID, mode: LBRadioMode,
        maxSimilarArtists: Int, maxRecordingsPerArtist: Int,
        pop: ClosedRange<Int>
    ) async throws -> [LBRadioSimilarArtist] {
        let minPop = pop.lowerBound
        let maxPop = pop.upperBound
        let request = RadioArtistRequest(
            artistMbid: artistMbid, mode: mode,
            maxSimilarArtists: maxSimilarArtists,
            maxRecordingsPerArtist: maxRecordingsPerArtist,
            minPop: minPop, maxPop: maxPop
        )

        let rawResult = try await apiClient.execute(request)

        var result = [LBRadioSimilarArtist]()
        for (key, value) in rawResult {
            guard !value.isEmpty, let artistId = UUID(uuidString: key) else { continue }

            let artistName = value.first!.similarArtistName

            result.append(
                .init(
                    artistMbid: artistId, artistName: artistName,
                    recordings: value.map {
                        LBRadioSimilarArtist
                            .Recording(
                                recordingMbid: $0.recordingMbid,
                                totalListenCount: $0.totalListenCount
                            )
                    }
                ))
        }

        return result
    }

    /// Get the timestamp of the latest listen submitted by the given user
    /// - Parameters:
    ///   - username: The user to get the latest listen of
    /// - Returns: The date of the latest listen, or nil if no date is set
    public func getLatestImport(username: String) async throws -> Date? {
        let request = GetLatestImportRequest(username: username)

        let result = try await apiClient.execute(request)

        if result.latestImport.timeIntervalSince1970.isZero {
            return nil
        }

        return result.latestImport
    }

    /// Update the timestamp of the newest listen submitted by the current user
    /// - Parameters:
    ///   - date: The date to set the newest listen to
    public func setLatestImport(date: Date) async throws {
        let request = SetLatestImportRequest(date: date)

        _ = try await apiClient.execute(request)
    }
}
