// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// Contains metadata for a given recording, along with related items if requested
public struct LBRecording: Decodable {
    /// Metadata for this recording
    let recording: LBRecordingMeta
    /// Metadata for this recording's artist(s) if requested
    let artist: LBArtist?
    /// Metadata for this recording's associated release if requested
    let release: LBReleaseMeta?
    /// MusicBrainz tags related to this recording
    let tags: LBTags?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recording = try container.decode(LBRecordingMeta.self, forKey: .recording)
        self.artist = try container.decodeIfPresent(LBArtist.self, forKey: .artist)
        self.release = try container.decodeIfPresent(LBReleaseMeta.self, forKey: .release)
        self.tags = try container.decodeIfPresent(LBTags.self, forKey: .tags)
    }

    enum CodingKeys: String, CodingKey {
        case recording
        case artist
        case release
        case tags = "tag"
    }
}
