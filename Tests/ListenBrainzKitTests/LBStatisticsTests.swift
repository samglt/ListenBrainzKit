// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation
import Testing

@testable import ListenBrainzKit

@Suite(.serialized)
struct LBStatisticsTests {
    let username: String
    let client: LBClient

    init() async throws {
        let token = ProcessInfo.processInfo.environment["LISTENBRAINZ_TOKEN"] ?? ""
        let client = LBClient(token: token)
        let validation = try await client.core.isTokenValid()

        self.client = client
        self.username = validation.userName ?? ""
    }

    @Test("Deserialize user artists")
    func deserializeUserArtists() async throws {
        let res = try JSONDecoder
            .ListenBrainz
            .decode(StatsArtistsRequest.Result.self,
                    from: Data("""
                    {
                        "payload":
                        {
                            "artists": [
                                {
                                    "artist_mbid": "ABABABAB-1212-ABAB-1212-ABABABABABAB",
                                    "artist_name": "Artist 1",
                                    "listen_count": 123
                                },
                                {
                                    "artist_mbid": "22222222-1212-ABAB-1212-ABABABABABAB",
                                    "artist_name": "Artist 2",
                                    "listen_count": 100
                                },
                            ],
                            "count": 2,
                            "from_ts": 1009843200,
                            "last_updated": 1737763200,
                            "offset": 0,
                            "range": "all_time",
                            "to_ts": 1737763200,
                            "total_artist_count": 2,
                            "user_id": "username"
                        }
                    }
                    """.utf8))
        #expect(res.payload.artists.count == 2)
    }

    @Test("Deserialize user releases")
    func deserializeUserReleases() async throws {
        let res = try JSONDecoder
            .ListenBrainz
            .decode(StatsReleasesRequest.Result.self,
                    from: Data(
                        """
                        {
                            "payload": {
                                "count": 1,
                                "offset": 0,
                                "range": "all_time",
                                "releases": [
                                    {
                                        "artist_mbids": [
                                            "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                            "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                            "e07d9474-00ea-4460-ac27-88b46b3d976e"
                                        ],
                                        "artist_name": "All Time Low ft. Demi Lovato & blackbear",
                                        "artists": [
                                            {
                                                "artist_credit_name": "All Time Low",
                                                "artist_mbid": "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                                "join_phrase": " ft. "
                                            },
                                            {
                                                "artist_credit_name": "Demi Lovato",
                                                "artist_mbid": "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                                "join_phrase": " & "
                                            },
                                            {
                                                "artist_credit_name": "blackbear",
                                                "artist_mbid": "e07d9474-00ea-4460-ac27-88b46b3d976e",
                                                "join_phrase": ""
                                            }
                                        ],
                                        "caa_id": 29179588350,
                                        "caa_release_mbid": "ee65192d-31f3-437a-b170-9158d2172dbc",
                                        "listen_count": 1,
                                        "release_mbid": "ee65192d-31f3-437a-b170-9158d2172dbc",
                                        "release_name": "Monsters"
                                    }
                                ],
                                "from_ts": 1009843200,
                                "to_ts": 1737763200,
                                "last_updated": 1737763200,
                                "total_release_count": 1,
                                "user_id": "username"
                            }
                        }
                        """.utf8))
        let release = try #require(res.payload.releases.first)
        let mbids = try #require(release.artistMbids)
        #expect(mbids.count == 3)
        let artists = try #require(release.artists)
        #expect(artists.count == 3)
    }

    @Test("Deserialize user releases")
    func deserializeUserReleaseGroups() async throws {
        let res = try JSONDecoder
            .ListenBrainz
            .decode(StatsReleaseGroupsRequest.Result.self,
                    from: Data("""
                    {
                    "payload": {
                        "count": 1,
                        "from_ts": 1009843200,
                        "last_updated": 1737763200,
                        "offset": 0,
                        "range": "all_time",
                        "release_groups": [
                            {
                                "artist_mbids": [
                                    "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                    "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                    "e07d9474-00ea-4460-ac27-88b46b3d976e"
                                ],
                                "artist_name": "All Time Low ft. Demi Lovato & blackbear",
                                "artists": [
                                    {
                                        "artist_credit_name": "All Time Low",
                                        "artist_mbid": "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                        "join_phrase": " ft. "
                                    },
                                    {
                                        "artist_credit_name": "Demi Lovato",
                                        "artist_mbid": "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                        "join_phrase": " & "
                                    },
                                    {
                                        "artist_credit_name": "blackbear",
                                        "artist_mbid": "e07d9474-00ea-4460-ac27-88b46b3d976e",
                                        "join_phrase": ""
                                    }
                                ],
                                "caa_id": 29179588350,
                                "caa_release_mbid": "ee65192d-31f3-437a-b170-9158d2172dbc",
                                "listen_count": 1,
                                "release_group_mbid": "326b4a29-dff5-4fab-87dc-efc1494001c6",
                                "release_group_name": "Monsters"
                            }
                        ],
                        "to_ts": 1737763200,
                        "total_release_group_count": 1,
                        "user_id": "username"
                    }
                    }
                    """.utf8))
        #expect(res.payload.releaseGroups.count == 1)
        let group = try #require(res.payload.releaseGroups.first)
        let artists = try #require(group.artists)
        #expect(artists.count == 3)
    }

    @Test("Deserialize user recordings")
    func deserializeUserRecordings() async throws {
        let res = try JSONDecoder
            .ListenBrainz
            .decode(StatsRecordingsRequest.Result.self,
                    from: Data("""
                    {
                        "payload": {
                            "count": 1,
                            "from_ts": 1009843200,
                            "last_updated": 1737763200,
                            "offset": 0,
                            "range": "all_time",
                            "recordings": [
                                {
                                    "artist_mbids": [
                                        "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                        "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                        "e07d9474-00ea-4460-ac27-88b46b3d976e"
                                    ],
                                    "artist_name": "All Time Low ft. Demi Lovato & blackbear",
                                    "artists": [
                                        {
                                            "artist_credit_name": "All Time Low",
                                            "artist_mbid": "62162215-b023-4f0e-84bd-1e9412d5b32c",
                                            "join_phrase": " ft. "
                                        },
                                        {
                                            "artist_credit_name": "Demi Lovato",
                                            "artist_mbid": "faf4cefb-036c-4c88-b93a-5b03dd0a0e6b",
                                            "join_phrase": " & "
                                        },
                                        {
                                            "artist_credit_name": "blackbear",
                                            "artist_mbid": "e07d9474-00ea-4460-ac27-88b46b3d976e",
                                            "join_phrase": ""
                                        }
                                    ],
                                    "caa_id": 29179588350,
                                    "caa_release_mbid": "ee65192d-31f3-437a-b170-9158d2172dbc",
                                    "listen_count": 1,
                                    "recording_mbid": "e8ffcb88-c908-43c1-aa6f-70af63436c53",
                                    "release_mbid": "ee65192d-31f3-437a-b170-9158d2172dbc",
                                    "release_name": "Monsters",
                                    "track_name": "Monsters"
                                }
                            ],
                            "to_ts": 1737763200,
                            "total_recording_count": 4,
                            "user_id": "username"
                        }
                    }
                    """.utf8))
        #expect(res.payload.recordings.count == 1)
        let recording = try #require(res.payload.recordings.first)
        let mbids = try #require(recording.artistMbids)
        #expect(mbids.count == 3)
    }
}
