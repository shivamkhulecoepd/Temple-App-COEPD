import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class InlineVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const InlineVideoPlayer({super.key, required this.videoUrl});

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;

  void _videoListener() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _initializeFuture = _controller.initialize();

    // ✅ IMPORTANT: listen to controller changes
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    VideoPlaybackManager().pause(_controller);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        // height: 220.h,
        width: double.infinity,
        child: FutureBuilder(
          future: _initializeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              /// 🔹 SHIMMER WHILE VIDEO LOADS
              return Shimmer.fromColors(
                baseColor: theme.colorScheme.surfaceVariant,
                highlightColor: theme.colorScheme.surface,
                child: Container(
                  width: double.infinity,
                  height: 220.h,
                  color: Colors.white,
                ),
              );
            }

            /// 🔹 VIDEO READY
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

                // ✅ Icon reacts to real-time video state
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                        if (value.isPlaying) {
                          VideoPlaybackManager().pause(_controller);
                        } else {
                          VideoPlaybackManager().play(_controller);
                        }
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: value.isPlaying ? 0.0 : 1.0, // 👈 KEY FIX
                        child: CircleAvatar(
                          radius: 28.r,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VideoPlaybackManager {
  static final VideoPlaybackManager _instance =
      VideoPlaybackManager._internal();

  factory VideoPlaybackManager() => _instance;

  VideoPlaybackManager._internal();

  VideoPlayerController? _activeController;

  void play(VideoPlayerController controller) {
    if (_activeController != controller) {
      _activeController?.pause();
      _activeController = controller;
    }
    controller.play();
  }

  void pause(VideoPlayerController controller) {
    if (_activeController == controller) {
      controller.pause();
      _activeController = null;
    }
  }
}
