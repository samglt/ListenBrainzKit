// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

public enum LBError: Error, Equatable {
    case unknownError

    case invalidJSON
    case invalidAuth

    case invalidParam
    case badRequest

    case noToken

    case notFound
    case forbidden

    case invalidResponse

    /// resetIn: Number of seconds until limit wears off
    case rateLimited(resetIn: Int)

    case noContent
}
