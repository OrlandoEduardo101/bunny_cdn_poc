import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final Uint8List? bytes;
  final double? aspectRatio;
  final bool? isAutoPlay;
  final bool? isControlsEnabled;
  final BetterPlayerControlsConfiguration? playerControlsConfiguration;
  final bool? isLooping;

  const VideoPlayerWidget.fromUrl({
    super.key,
    required this.videoUrl,
    this.isAutoPlay = false,
    this.isControlsEnabled = true,
    this.aspectRatio = 16 / 9,
    this.playerControlsConfiguration,
    this.isLooping = false,
  }) : bytes = null;
  const VideoPlayerWidget.fromBytes({
    super.key,
    required this.bytes,
    this.isAutoPlay = false,
    this.isControlsEnabled = true,
    this.aspectRatio = 16 / 9,
    this.playerControlsConfiguration,
    this.isLooping = false,
  }) : videoUrl = null;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final BetterPlayerController controller;

  late BetterPlayerDataSource dataSource;
  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      dataSource = BetterPlayerDataSource.network(
        widget.videoUrl!,
      );
    }

    if (widget.bytes != null) {
      dataSource = BetterPlayerDataSource.memory(
        widget.bytes!,
      );
    }

    controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: widget.isAutoPlay!,
        aspectRatio: widget.aspectRatio,
        fit: BoxFit.cover,
        fullScreenAspectRatio: widget.aspectRatio,
        autoDetectFullscreenAspectRatio: true,
        useRootNavigator: true,
        looping: widget.isLooping!,
        
      ),
      betterPlayerDataSource: dataSource,
    );

    if (widget.playerControlsConfiguration != null) {
      controller.setBetterPlayerControlsConfiguration(widget.playerControlsConfiguration!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: BetterPlayer(controller: controller),
      ),
    );
  }
}