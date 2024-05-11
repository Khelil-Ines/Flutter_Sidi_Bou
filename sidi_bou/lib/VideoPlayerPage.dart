import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidi_bou/core/Config.dart';
import 'navigation_drawer.dart';

enum Source { Asset, Network }

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late VideoPlayerController _videoPlayerController;
  Source currentSource = Source.Network;

  Uri videoUri = Uri.parse(
      "https://videos.pexels.com/video-files/13891708/13891708-hd_1920_1080_25fps.mp4");
  String assetVideoPath = "assets/videos/Les_secrets_de_Sidi_Bou.mp4";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const navigation_drawer(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            Config.Localization["discover"],
            style: GoogleFonts.robotoCondensed(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController,
                      ),
                      const SizedBox(height: 20),
                      _sourceButtons(),
                    ],
                  ),
                ),
                _bottomButton(),
              ],
            ),
    );
  }

  Widget _sourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          color: Colors.blue,
          child: Text(
            Config.Localization["network"],
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.Network;
              initializeVideoPlayer(currentSource);
            });
          },
        ),
        MaterialButton(
          color: Colors.blue,
          child: Text(
            Config.Localization["asset"],
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              currentSource = Source.Asset;
              initializeVideoPlayer(currentSource);
            });
          },
        ),
      ],
    );
  }

  Widget _bottomButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('QuizzScreen');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue[900],
        ),
        child: Text(
          Config.Localization["quizz"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void initializeVideoPlayer(Source source) {
    setState(() {
      isLoading = true;
    });

    _videoPlayerController = source == Source.Asset
        ? VideoPlayerController.asset(assetVideoPath)
        : VideoPlayerController.networkUrl(videoUri);

    _videoPlayerController.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController,
      );
    }).catchError((error) {
      print("Failed to initialize video player: $error");
      setState(() {
        isLoading = false;
      });
    });
  }
}
