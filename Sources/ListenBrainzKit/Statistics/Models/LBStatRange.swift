// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// The ranges supported when fetching statistics
public enum LBStatRange: String {
    /// Past 7 days
    case thisWeek = "this_week"
    /// Past 30 days
    case thisMonth = "this_month"
    /// Past 365 days
    case thisYear = "this_year"
    /// Previous week
    case week
    /// Previous month
    case month
    /// Previous quarter
    case quarter
    /// Previous year
    case year
    case halfYearly = "half_yearly"
    case allTime = "all_time"
}
