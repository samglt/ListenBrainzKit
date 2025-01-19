// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

public struct LBRecordingsClient: Sendable {
    let apiClient: any APIClient

    init(_ client: some APIClient) {
        self.apiClient = client
    }

    /// Submit feedback (love/hate) about a recording to the server.
    /// Auth required.
    /// - Parameters:
    ///   - mbid:     MusicBrainz ID of recording
    ///   - msid:     MessyBrainz ID of recording (Optional)
    ///   - feedback: Love or Hate. None removes previous rating
    public func submitFeedback(mbid: UUID, msid: UUID? = nil, score: LBScore) async throws {
        let request = RecordingFeedbackRequest(score: score, recordingMbid: mbid, recordingMsid: msid)
        _ = try await apiClient.execute(request)
    }

    /// Submit feedback (love/hate) about a recording to the server.
    /// Auth required.
    /// - Parameters:
    ///   - msid:     MessyBrainz ID of recording
    ///   - mbid:     MusicBrainz ID of recording (Optional)
    ///   - feedback: Love or Hate. None removes previous rating
    public func submitFeedback(msid: UUID, mbid: UUID? = nil, score: LBScore) async throws {
        let request = RecordingFeedbackRequest(score: score, recordingMbid: mbid, recordingMsid: msid)
        _ = try await apiClient.execute(request)
    }

    /// Get feedback given by a user
    /// - Parameters:
    ///   - user:     Username to get feedback from
    ///   - score:    Type of feedback to return, eg. only loved tracks
    ///   - count:    Number of items to return
    ///   - offset:   Number of items to skip, for pagination
    ///   - metadata: Fetch basic metadata for recordings, including mbidMapping
    /// - Returns: List of feedbacks given by user
    public func getFeedback(user: String, score: LBScore? = nil,
                            count: Int? = nil, offset: Int? = nil,
                            metadata: Bool? = nil) async throws -> [LBFeedback] {
        let request = RecordingUserFeedbackRequest(username: user, score: score,
                                                   count: count, offset: offset,
                                                   metadata: metadata)
        let res = try await apiClient.execute(request)
        return res.feedback
    }

    /// Get feedback given about a recording by various users
    /// - Parameters:
    ///   - mbid:     MBID of recording to get feedback about
    ///   - score:    Type of feedback to return, eg. only loved tracks
    ///   - count:    Number of items to return
    ///   - offset:   Number of items to skip, for pagination
    /// - Returns: List of feedbacks given about the recording
    public func getFeedback(mbid: UUID, score: LBScore? = nil,
                            count: Int? = nil, offset: Int? = nil) async throws -> [LBFeedback] {
        let request = RecordingMbidFeedbackRequest(mbid: mbid, score: score,
                                                   count: count, offset: offset)
        let res = try await apiClient.execute(request)
        return res.feedback
    }

    /// Get feedback given about a recording by various users
    /// - Parameters:
    ///   - msid:   MessyBrainz ID of recording to get feedback about
    ///   - score:  Type of feedback to return, eg. only loved tracks
    ///   - count:  Number of items to return
    ///   - offset: Number of items to skip, for pagination
    /// - Returns: List of feedbacks given about the recording
    public func getFeedback(msid: UUID, score: LBScore? = nil,
                            count: Int? = nil, offset: Int? = nil) async throws -> [LBFeedback] {
        let request = RecordingMsidFeedbackRequest(msid: msid, score: score,
                                                   count: count, offset: offset)
        let res = try await apiClient.execute(request)
        return res.feedback
    }

    /// Get feedback for the given recordings by the given user
    /// - Parameters:
    ///   - mbids: IDs of the recordings to fetch
    ///   - by:    Feedback made by this user
    /// - Returns: Map from MBID to feedback
    public func getFeedbackFor(mbids: [UUID], by user: String) async throws -> [UUID: LBFeedback] {
        let request = RecordingFeedbackForRequest(mbids: mbids, username: user)
        let res = try await (apiClient.execute(request)).feedback

        return [UUID: LBFeedback](res.map { ($0.recordingMbid, $0) },
                                  uniquingKeysWith: { lhs, _ in lhs })
    }
}
