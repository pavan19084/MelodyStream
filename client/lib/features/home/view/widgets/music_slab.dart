// ignore_for_file: avoid_print, collection_methods_unrelated_type

import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref.watch(
      currentUserNotifierProvider.select((data) => data!.favorites),
    );

    if (currentSong == null) {
      return const SizedBox();
    }

    Color backgroundColor;
    try {
      backgroundColor = hexToColor(currentSong.hex_code);
    } catch (e) {
      print(e.toString());
      backgroundColor = Pallete.transparentColor;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryanimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryanimation, child) {
              final tween =
                  Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeIn),
              );
              final offset = animation.drive(tween);

              return SlideTransition(
                position: offset,
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(microseconds: 500),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Pallete.subtitleText,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: currentSong.id);
                      },
                      icon: Icon(
                        userFavorites
                                .where((fav) => fav.song_id == currentSong.id)
                                .toList()
                                .isNotEmpty
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Pallete.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          songNotifier.playPause(currentSong.song_url),
                      icon: Icon(
                        songNotifier.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: StreamBuilder<Duration>(
              stream: songNotifier.audioPlayer?.onPositionChanged,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final totalDuration = songNotifier.totalDuration;
                final progressWidth = totalDuration > Duration.zero
                    ? (position.inMilliseconds / totalDuration.inMilliseconds) *
                        (MediaQuery.of(context).size.width - 32)
                    : 0.0;

                return Container(
                  height: 2,
                  width: progressWidth,
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
