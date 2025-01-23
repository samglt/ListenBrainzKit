// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// The ranges supported when fetching statistics
public enum LBStatRange: String {
    case thisWeek = "this_week"
    case thisMonth = "this_month"
    case thisYear = "this_year"
    case week
    case month
    case quarter
    case year
    case halfYearly = "half_yearly"
    case allTime = "all_time"
}
