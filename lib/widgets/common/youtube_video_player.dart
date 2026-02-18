import 'package:flutter/material.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final bool? isYoutube;
  const VideoPlayerScreen({
    super.key,
    required this.url,
    this.isYoutube = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(initialVideoId: videoId);
    } else {
      // Fallback to a default video if conversion fails
      _controller = YoutubePlayerController(initialVideoId: 'IL-72PQszxg');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(
          'Watch Video',
          style: TextStyle(fontFamily: 'aBeeZee'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          widget.isYoutube!
              ? IconButton(
                  icon: Icon(Icons.open_in_new),
                  onPressed: () async {
                    try {
                      await launchUrl(Uri.parse(widget.url));
                    } catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        AppSnackbar.error(context, 'Could not open video: $e');
                      }
                    }
                  },
                )
              : SizedBox(),
        ],
      ),
      body: YoutubePlayer(controller: _controller),
    );
  }
}
