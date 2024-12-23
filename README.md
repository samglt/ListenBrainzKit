# ListenBrainzKit

ListenBrainzKit is a Swift wrapper around the [ListenBrainz API](https://listenbrainz.readthedocs.io/en/latest/users/api/index.html) originally built for my iOS music app, [Jewelcase](https://apps.apple.com/us/app/jewelcase/id6642683626).

## Requirements
- Swift 6
- iOS 16+
- macOS 13+
- tvOS 16+
- visionOS 1+
- watchOS 9+

## Setup

Add ListenBrainzKit as a dependency in your Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/samglt/ListenBrainzKit", from: "0.1.0"),
],
```

Or add it in XCode by selecting `File > Add Package Dependencies...` and entering `https://github.com/samglt/ListenBrainzKit`

## Usage

You can initialize a client with a ListenBrainz token and an optional custom root URL if you're not using the official ListenBrainz endpoint (eg. if you're running your own instance).

```swift
import ListenBrainzKit

let client = LBClient(token: token)
// or:
let client = LBClient(token: token, customRoot: URL(string: "https://10.0.0.10:1234")!)
```

Submitting listens:

```swift
// Submit a single listen
try await client.core.submitListen(meta: .init(artist: "Kylie Minogue",
                                               track: "Come Into My World",
                                               release: "Fever",
                                               tracknumber: 7),
                                   at: time)

// Submit a batch of past listens
try await client.core.submitListens([
    .init(meta: .init(artist: "Kylie Minogue",
                      track: "Fever"),
          listenedAt: Date.now.addingTimeInterval(-180)),
    .init(meta: .init(artist: "Kylie Minogue",
                      track: "More More More"),
          listenedAt: Date.now.addingTimeInterval(-360))
])
```

## Supported Endpoints

- Core
  - [x] GET  /1/search/users/
  - [x] POST /1/submit-listens
  - [x] GET  /1/user/(user_name)/listens
  - [x] GET  /1/user/(user_name)/listen-count
  - [x] GET  /1/user/(user_name)/playing-now
  - [x] GET  /1/user/(user_name)/similar-users
  - [x] GET  /1/user/(user_name)/similar-to/(other_user_name)
  - [x] GET  /1/validate-token
  - [x] POST /1/delete-listen
  - [x] GET  /1/user/(playlist_user_name)/playlists
  - [x] GET  /1/user/(playlist_user_name)/playlists/createdfor
  - [x] GET  /1/user/(playlist_user_name)/playlists/collaborator
  - [x] GET  /1/user/(playlist_user_name)/playlists/recommendations
  - [x] GET  /1/user/(playlist_user_name)/playlists/search
  - [x] GET  /1/user/(user_name)/services
  - [x] GET  /1/lb-radio/tags
  - [x] GET  /1/lb-radio/artist/(seed_artist_mbid)
  - [x] GET  /1/latest-import
  - [x] POST /1/latest-import
- Metadata
  - [x] GET  /1/metadata/recording/
  - [x] POST /1/metadata/recording/
  - [x] GET  /1/metadata/release_group/
  - [x] GET  /1/metadata/lookup/
  - [x] POST /1/metadata/lookup/
  - [x] GET  /1/metadata/artist/
  - [ ] POST /1/metadata/submit_manual_mapping/
  - [ ] GET  /1/metadata/get_manual_mapping/
- Statistics
  - [ ] GET  /1/stats/user/(user_name)/artists
  - [ ] GET  /1/stats/user/(user_name)/releases
  - [ ] GET  /1/stats/user/(user_name)/release-groups
  - [ ] GET  /1/stats/user/(user_name)/recordings
  - [ ] GET  /1/stats/user/(user_name)/listening-activity
  - [ ] GET  /1/stats/user/(user_name)/daily-activity
  - [ ] GET  /1/stats/user/(user_name)/artist-map
  - [ ] GET  /1/stats/artist/(artist_mbid)/listeners
  - [ ] GET  /1/stats/release-group/(release_group_mbid)/listeners
  - [ ] GET  /1/stats/sitewide/artists
  - [ ] GET  /1/stats/sitewide/releases
  - [ ] GET  /1/stats/sitewide/release-groups
  - [ ] GET  /1/stats/sitewide/recordings
  - [ ] GET  /1/stats/sitewide/listening-activity
  - [ ] GET  /1/stats/sitewide/artist-map
  - [ ] GET  /1/stats/user/(user_name)/year-in-music/(int: year)
  - [ ] GET  /1/stats/user/(user_name)/year-in-music
- Popularity
  - [ ] GET  /1/popularity/top-recordings-for-artist/(artist_mbid)
  - [ ] GET  /1/popularity/top-release-groups-for-artist/(artist_mbid)
  - [ ] POST /1/popularity/recording
  - [ ] POST /1/popularity/artist
  - [ ] POST /1/popularity/release
  - [ ] POST /1/popularity/release-group
- Playlists
  - [ ] GET  /1/user/(playlist_user_name)/playlists
  - [ ] GET  /1/user/(playlist_user_name)/playlists/createdfor
  - [ ] GET  /1/user/(playlist_user_name)/playlists/collaborator
  - [ ] POST /1/playlist/create
  - [ ] GET  /1/playlist/search
  - [ ] POST /1/playlist/edit/(playlist_mbid)
  - [ ] GET  /1/playlist/(playlist_mbid)
  - [ ] GET  /1/playlist/(playlist_mbid)/xspf
  - [ ] POST /1/playlist/(playlist_mbid)/item/add
  - [ ] POST /1/playlist/(playlist_mbid)/item/add/(int: offset)
  - [ ] POST /1/playlist/(playlist_mbid)/item/move
  - [ ] POST /1/playlist/(playlist_mbid)/item/delete
  - [ ] POST /1/playlist/(playlist_mbid)/delete
  - [ ] POST /1/playlist/(playlist_mbid)/copy
  - [ ] POST /1/playlist/(playlist_mbid)/export/(service)
  - [ ] GET  /1/playlist/import/(service)
  - [ ] GET  /1/playlist/(service)/(playlist_id)/tracks
  - [ ] POST /1/playlist/export-jspf/(service)
- Recordings
  - [ ] POST /1/feedback/recording-feedback
  - [ ] GET  /1/feedback/user/(user_name)/get-feedback
  - [ ] GET  /1/feedback/recording/(recording_mbid)/get-feedback-mbid
  - [ ] GET  /1/feedback/recording/(recording_msid)/get-feedback
  - [ ] GET  /1/feedback/user/(user_name)/get-feedback-for-recordings
  - [ ] POST /1/feedback/user/(user_name)/get-feedback-for-recordings
  - [ ] POST /1/feedback/import
  - Pinned Recording API
    - [ ] POST /1/pin
    - [ ] POST /1/pin/unpin
    - [ ] POST /1/pin/delete/(row_id)
    - [ ] GET  /1/(user_name)/pins
    - [ ] GET  /1/(user_name)/pins/following
    - [ ] GET  /1/(user_name)/pins/current
    - [ ] POST /1/pin/update/(row_id)
- Social
  - [ ] POST /1/user/(user_name)/timeline-event/create/recording
  - [ ] POST /1/user/(user_name)/timeline-event/create/notification
  - [ ] POST /1/user/(user_name)/timeline-event/create/review
  - [ ] GET  /1/user/(user_name)/feed/events
  - [ ] GET  /1/user/(user_name)/feed/events/listens/following
  - [ ] GET  /1/user/(user_name)/feed/events/listens/similar
  - [ ] POST /1/user/(user_name)/feed/events/delete
  - [ ] POST /1/user/(user_name)/feed/events/hide
  - [ ] POST /1/user/(user_name)/feed/events/unhide
  - [ ] POST /1/user/(user_name)/timeline-event/create/recommend-personal
  - Follow API
    - [ ] GET  /1/user/(user_name)/followers
    - [ ] GET  /1/user/(user_name)/following
    - [ ] POST /1/user/(user_name)/follow
    - [ ] POST /1/user/(user_name)/unfollow
- Recommendations
  - [ ] GET  /1/cf/recommendation/user/(user_name)/recording
  - Feedback
    - [ ] POST /1/recommendation/feedback/submit
    - [ ] POST /1/recommendation/feedback/delete
    - [ ] GET  /1/recommendation/feedback/user/(user_name)
    - [ ] GET  /1/recommendation/feedback/user/(user_name)/recordings
- Art
  - [ ] POST /1/art/grid/
  - [ ] GET  /1/art/grid-stats/(user_name)/(time_range)/(int: dimension)/(int: layout)/(int: image_size)
  - [ ] GET  /1/art/(custom_name)/(user_name)/(time_range)/(int: image_size)
  - [ ] GET  /1/art/year-in-music/(int: year)/(user_name)
- Misc
  - Explore
    - [ ] GET  /1/explore/fresh-releases/
    - [ ] GET  /1/explore/color/(color)
    - [ ] GET  /1/explore/lb-radio
  - Status
    - [ ] GET  /1/status/get-dump-info
