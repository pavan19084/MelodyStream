// ignore_for_file: avoid_public_notifier_properties
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/home/model/song_model.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  Duration currentDuration = Duration.zero;  
  Duration totalDuration = Duration.zero;
  StreamSubscription<Duration>? positionSubscription;
  StreamSubscription<Duration>? durationSubscription;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    // Dispose previous resources
    positionSubscription?.cancel();
    durationSubscription?.cancel();
    audioPlayer?.dispose();
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer = AudioPlayer();
    audioPlayer!.play(UrlSource(song.song_url));
    isPlaying = true;
    state = song;

    audioPlayer!.onPlayerStateChanged.listen((PlayerState playerState) {
      if (playerState == PlayerState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        state = state?.copyWith(hex_code: state?.hex_code);
      }
    });

    // Listen to the position and duration streams
    positionSubscription = audioPlayer!.onPositionChanged.listen((position) {
      currentDuration = position;
      state = state?.copyWith(hex_code: state?.hex_code);
    });

    durationSubscription = audioPlayer!.onDurationChanged.listen((duration) {
      totalDuration = duration;
      state = state?.copyWith(hex_code: state?.hex_code);
    });
  }

  void playPause(String url) {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play(UrlSource(url));
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seekTo(Duration position) {
    audioPlayer?.seek(position);
  }
}
