// A small aggregate showing value objects, an aggregate root with an invariant,
// and a repository per root. Pure domain (no Flutter, no IO). Illustrative only.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modeling.freezed.dart'; // run build_runner

// --- Value objects (validate on creation, equality by value) ---------------

@freezed
class PlaylistId with _$PlaylistId {
  const PlaylistId._();
  const factory PlaylistId(String value) = _PlaylistId;

  factory PlaylistId.parse(String raw) {
    if (raw.trim().isEmpty) throw ArgumentError('PlaylistId cannot be empty');
    return PlaylistId(raw);
  }
}

@freezed
class Track with _$Track {
  const factory Track({required String id, required String title}) = _Track;
}

// --- Aggregate root: enforces invariants; mutations return a new instance ---

@freezed
class Playlist with _$Playlist {
  const Playlist._();

  const factory Playlist({
    required PlaylistId id,
    required String name,
    required List<Track> tracks,
  }) = _Playlist;

  static const maxTracks = 100;

  /// Invariant: a playlist holds at most [maxTracks] and no duplicate tracks.
  /// External code changes the aggregate only through the root, never by
  /// mutating [tracks] directly.
  Playlist addTrack(Track track) {
    if (tracks.length >= maxTracks) {
      throw StateError('Playlist is full');
    }
    if (tracks.any((t) => t.id == track.id)) {
      return this; // idempotent: duplicates are not allowed
    }
    return copyWith(tracks: [...tracks, track]);
  }
}

// --- Repository per aggregate root (interface lives in domain) --------------

sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final Object failure;
}

abstract interface class PlaylistRepository {
  Future<Result<Playlist>> getById(PlaylistId id);
  Future<Result<void>> save(Playlist playlist);
}
