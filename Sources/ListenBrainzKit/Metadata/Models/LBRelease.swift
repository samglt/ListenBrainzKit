/// Contains metadata for a release group, with other related metadata if requested
public struct LBRelease: Decodable {
    /// The single artist credit, and the artists involved in this release group
    let artist: LBArtist?
    /// Tags for the artist(s) and release group
    let tag: LBTags?
    /// Metadata for a particular release of this group
    let release: LBReleaseGroupMeta?
    /// Metadata for this release group
    let releaseGroup: LBReleaseGroupMeta
}
