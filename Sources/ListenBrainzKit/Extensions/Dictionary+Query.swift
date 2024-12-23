// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

extension [String: [String]] {
    mutating func setQueryItem(_ key: String, value: String?) {
        guard let value else { return }
        self[key] = [value]
    }

    mutating func setQueryItem(_ key: String, value: Int?) {
        guard let value else { return }
        self[key] = [String(value)]
    }
}
