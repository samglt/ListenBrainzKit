// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

public struct LBTokenInfo: Decodable {
    /// Is this a valid token?
    public var valid: Bool
    /// The user this token was created for
    public var userName: String?
}
