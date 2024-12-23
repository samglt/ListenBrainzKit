// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// Metadata for a ListenBrainz playlist
public struct LBPlaylistMetadata {
    /// Title of the playlist
    let title: String

    /// Optional description
    let annotation: String?

    /// Username of the creator
    let creator: String

    /// Link to this playlist on ListenBrainz
    let identifier: String

    /// Date this was created
    let date: Date?
    let duration: Int?

    // Extended:

    /// Is this playlist public on ListenBrainz
    let isPublic: Bool

    /// When this playlist was last modified
    let lastModifiedAt: Date

    /// The user this playlist was created for
    let createdFor: String?

    /// The usernames of the collaborators
    let collaborators: [String]?

    /// Where this playlist was imported from
    let copiedFrom: String?
    let copiedFromDeleted: Bool?

    init(raw: RawPlaylist) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withDashSeparatorInDate,
            .withFullTime,
            .withFractionalSeconds,
        ]

        self.title = raw.title
        self.annotation = raw.annotation
        self.creator = raw.creator
        self.identifier = raw.identifier
        self.date = dateFormatter.date(from: raw.date)
        self.duration = raw.duration
        self.isPublic = raw.ext.listenbrainz.isPublic
        self.lastModifiedAt = dateFormatter.date(from: raw.ext.listenbrainz.lastModifiedAt) ?? .distantPast
        self.createdFor = raw.ext.listenbrainz.createdFor
        self.collaborators = raw.ext.listenbrainz.collaborators
        self.copiedFrom = raw.ext.listenbrainz.copiedFrom
        self.copiedFromDeleted = raw.ext.listenbrainz.copiedFromDeleted
    }
}

private extension ISO8601DateFormatter {
    func date(from str: String?) -> Date? {
        guard let str else { return nil }
        return date(from: str)
    }
}
