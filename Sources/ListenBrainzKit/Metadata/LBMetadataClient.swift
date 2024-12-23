// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBMetadataClient: Sendable {
    let apiClient: any APIClient

    init(_ client: some APIClient) {
        self.apiClient = client
    }

    /// Get MusicBrainz metadata for the given recording and optional related metadata
    /// - Parameters:
    ///   - mbid: The MusicBrainz ID of the recording
    ///   - including: Additional metadata to include (tag, artist and/or release)
    /// - Returns: Recording metadata with requested inclusions
    public func recording(
        mbid recordingMbid: UUID,
        including: any Sequence<LBMetaInclusion> = []
    ) async throws -> LBRecording? {
        let request = MetadataRecordingRequest(
            mbids: [recordingMbid],
            including: Array(including)
        )

        // Note: https://www.fivestars.blog/articles/codable-swift-dictionaries/
        let result = try await apiClient.execute(request)

        return result.recordings[recordingMbid]
    }

    /// Get MusicBrainz metadata for the given recordings and optional related metadata
    /// - Parameters:
    ///   - mbids: Array of MusicBrainz recording IDs
    ///   - including: Additional metadata to include (tag, artist and/or release)
    /// - Returns: Map from recording ID to metadata with requested inclusions
    public func recordings(
        mbids recordingMbids: [UUID],
        including: any Sequence<LBMetaInclusion> = []
    ) async throws -> [UUID: LBRecording] {
        let request = MetadataRecordingRequest(
            mbids: recordingMbids,
            including: Array(including)
        )

        // Note: https://www.fivestars.blog/articles/codable-swift-dictionaries/
        let result = try await apiClient.execute(request)

        return result.recordings
    }

    /// Get metadata for a release group
    /// - Parameters:
    ///   - mbid:      MusicBrainz ID of group
    ///   - including: What extra metadata to fetch along with group metadata
    /// - Returns: Metadata for group, with optional meta for release, artists, etc.
    public func releaseGroup(
        mbid releaseGroupMbid: UUID,
        including: any Sequence<LBMetaInclusion> = []
    ) async throws -> LBRelease? {
        let request = MetadataReleaseGroupRequest(
            mbids: [releaseGroupMbid],
            including: Array(including)
        )

        let result = try await apiClient.execute(request)

        return result.releases[releaseGroupMbid]
    }

    /// Get metadata for release groups
    /// - Parameters:
    ///   - mbids:     MusicBrainz IDs of groups
    ///   - including: What extra metadata to fetch along with group metadata
    /// - Returns: Metadata for group, with optional meta for release, artists, etc.
    public func releaseGroups(
        mbids releaseGroupMbids: [UUID],
        including: any Sequence<LBMetaInclusion> = []
    ) async throws -> [UUID: LBRelease] {
        let request = MetadataReleaseGroupRequest(
            mbids: releaseGroupMbids,
            including: Array(including)
        )

        let result = try await apiClient.execute(request)

        return result.releases
    }

    /// Look up metadata based on the given recording information.
    /// Matching is fuzzy and will accept spelling/punctuation variations, similar to the /listen/ endpoint
    /// - Parameters:
    ///   - artist:    Artist's name
    ///   - recording: Title of the recording/track/song
    ///   - release:   Title of whatever the track was released on, (album, EP, single, etc.)
    ///   - metadata:  Whether to fetch recording metadata
    ///   - including: Related metadata to fetch with recording metadata
    /// - Returns: Title and MBID for artist(s), recording, and release, if they could be found.
    ///            Recording metadata included
    public func lookup(
        artist: String, recording: String, release: String?, metadata: Bool = false,
        including: any Sequence<LBMetaInclusion> = []
    ) async throws -> LBLookup? {
        let request = MetadataSingleLookupRequest(
            lookup: .init(
                artist: artist,
                recording: recording,
                release: release
            ),
            metadata: metadata,
            including: Array(including)
        )
        return try await (apiClient.execute(request)).wrappedRes
    }

    /// Look up name and MBIDs for multiple different tracks
    /// - Parameters:
    ///   - lookups: List of tracks to lookup
    /// - Returns: Title and MBID for artist(s), recording, and release, if they could be found
    public func lookup(lookups: [LBLookupData]) async throws -> [LBLookup?] {
        let request = MetadataMultipleLookupRequest(lookups: lookups)

        return try await (apiClient.execute(request)).map { $0.toLB() }
    }

    /// Get artist metadata from MBIDs
    /// - Parameters:
    ///   - mbids:       List of artist MusicBrainz IDs
    ///   - includeTags: Whether to include tags associated with the artist
    /// - Returns: Map from artist's MBID to metadata
    public func artists(mbids: [UUID], includeTags: Bool = false) async throws -> [UUID:
        LBArtistMeta] {
        let request = MetadataArtistRequest(mbids: mbids, incTags: includeTags)

        return try await Dictionary(
            (apiClient.execute(request))
                .map { ($0.id, $0) },
            uniquingKeysWith: { lhs, _ in lhs }
        )
    }
}
