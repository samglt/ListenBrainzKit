// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBTrackMetadata: Codable, Equatable {
    var artist: String
    var track: String
    var release: String?
    var additionalInfo: LBAdditionalInfo?
    var mbidMapping: MbidMapping?

    init(artist: String, track: String,
         release: String? = nil, additionalInfo: LBAdditionalInfo? = nil) {
        self.artist = artist
        self.track = track
        self.release = release
        self.additionalInfo = additionalInfo
        self.mbidMapping = nil
    }

    public init(artist: String, track: String,
                release: String? = nil,
                tracknumber: Int? = nil,
                tags: [String]? = nil,
                durationMs: Int? = nil,
                duration: Int? = nil,
                artistMbids: [UUID]? = nil,
                releaseGroupMbid: UUID? = nil,
                releaseMbid: UUID? = nil,
                recordingMbid: UUID? = nil,
                trackMbid: UUID? = nil,
                workMbids: [UUID]? = nil,
                isrc: String? = nil,
                mediaPlayer: String? = nil,
                mediaPlayerVersion: String? = nil,
                submissionClient: String? = nil,
                submissionClientVersion: String? = nil,
                musicService: String? = nil,
                musicServiceName: String? = nil,
                spotifyId: String? = nil,
                originUrl: String? = nil) {
        self.init(artist: artist,
                  track: track,
                  release: release,
                  additionalInfo: .init(artistMbids: artistMbids,
                                        releaseGroupMbid: releaseGroupMbid,
                                        releaseMbid: releaseMbid,
                                        recordingMbid: recordingMbid,
                                        trackMbid: trackMbid,
                                        workMbids: workMbids,
                                        tracknumber: tracknumber,
                                        isrc: isrc,
                                        spotifyId: spotifyId,
                                        tags: tags,
                                        mediaPlayer: mediaPlayer,
                                        mediaPlayerVersion: mediaPlayerVersion,
                                        submissionClient: submissionClient,
                                        submissionClientVersion: submissionClientVersion,
                                        musicService: musicService,
                                        musicServiceName: musicServiceName,
                                        originUrl: originUrl,
                                        durationMs: durationMs,
                                        duration: duration))
    }

    enum CodingKeys: String, CodingKey {
        case artist = "artistName"
        case track = "trackName"
        case release = "releaseName"
        case additionalInfo
        case mbidMapping
    }

    public struct MbidMapping: Codable, Equatable {
        let artistMbids: [UUID]
        let artists: [MbidMappingArtist]
        let recordingMbid: UUID
        let releaseMbid: UUID
        let caaId: Int?
        let caaReleaseMbid: UUID?
    }

    public struct MbidMappingArtist: Codable, Equatable {
        let name: String
        let mbid: UUID
        let joinPhrase: String

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case name = "artistCreditName"
            case mbid = "artistMbid"
            case joinPhrase
        }
    }
}
