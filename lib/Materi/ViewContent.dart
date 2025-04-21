import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:skilltopia/constants.dart';

class ViewContent extends StatefulWidget {
  final String subJudul;
  final String content;
  final String? audio;
  final String? video;

  const ViewContent({
    Key? key,
    required this.subJudul,
    required this.content,
    this.audio,
    this.video,
  }) : super(key: key);

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  bool _isLoading = true;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  late AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _isAudioInitialized = false;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize loading state
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // Initialize AudioPlayer
    _audioPlayer = AudioPlayer();

    if (widget.video != null && widget.video!.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(
          Uri.parse("${AppConstants.baseUrlVideo}${widget.video}"))
        ..initialize().then((_) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: false,
            );
          });
        }).catchError((e) {
          print('Error initializing video player: $e');
        });
    }

    // Listen to player position changes
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to player duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
        });
      }
    });

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing;
          
          // Handle processing state
          if (playerState.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _currentPosition = Duration.zero;
            _audioPlayer.seek(Duration.zero);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // Initialize and play audio
  Future<void> _initAudio(String url) async {
    if (!_isAudioInitialized) {
      setState(() {
        _isAudioLoading = true;
      });
      
      try {
        await _audioPlayer.setUrl(url);
        setState(() {
          _isAudioInitialized = true;
          _isAudioLoading = false;
        });
        await _audioPlayer.play();
      } catch (e) {
        print("Error initializing audio: $e");
        setState(() {
          _isAudioLoading = false;
        });
      }
    } else {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    }
  }

  // Format duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Construct audio URL, making sure to handle null cases
    String audioUrl = "${AppConstants.baseUrlAudio}${widget.audio}";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subJudul),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      widget.content,
                      // HTML widget configuration remains the same
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      customWidgetBuilder: (element) {
                        // Existing HTML widget code remains the same
                        if (element.localName == 'iframe') {
                          final src = element.attributes['src'];
                          if (src != null) {
                            if (src.contains('youtube.com/embed/')) {
                              final videoId = YoutubePlayer.convertUrlToId(src) ??
                                  src.split('/').last;

                              return Column(
                                children: [
                                  const SizedBox(height: 16),
                                  YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId: videoId,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: false,
                                        mute: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            } else if (src.contains('soundcloud.com')) {
                              return Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.audio_file, size: 40),
                                        const SizedBox(height: 8),
                                        const Text('SoundCloud Audio'),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final uri = Uri.parse(src);
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(
                                                uri,
                                                mode: LaunchMode.externalApplication,
                                              );
                                            }
                                          },
                                          child: const Text('Listen on SoundCloud'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }
                          }
                        }
                        return null;
                      },
                      renderMode: RenderMode.column,
                      onErrorBuilder: (context, element, error) => Text(
                        'Error rendering element: $element',
                        style: const TextStyle(color: Colors.red),
                      ),
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          const Center(child: CircularProgressIndicator()),
                      onTapUrl: (url) async {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          return true;
                        }
                        return false;
                      },
                      customStylesBuilder: (element) {
                        if (element.localName == 'h1') {
                          return {
                            'margin': '16px 0 8px 0',
                            'font-size': '24px',
                            'font-weight': 'bold',
                          };
                        }
                        if (element.localName == 'h2') {
                          return {
                            'margin': '14px 0 7px 0',
                            'font-size': '22px',
                            'font-weight': 'bold',
                          };
                        }
                        if (element.localName == 'img') {
                          return {
                            'max-width': '100%',
                            'height': 'auto',
                            'margin': '8px 0',
                          };
                        }
                        if (element.localName == 'p') {
                          return {
                            'margin': '8px 0',
                          };
                        }
                        if (element.localName == 'ul' || element.localName == 'ol') {
                          return {
                            'margin': '8px 0',
                            'padding-left': '20px',
                          };
                        }
                        if (element.localName == 'li') {
                          return {
                            'margin': '4px 0',
                          };
                        }
                        return null;
                      },
                    ),
                    
                    // Conditionally display the video (remains unchanged)
                    if (widget.video != null && widget.video!.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
                                  child: Chewie(controller: _chewieController!),
                                )
                              : const Center(child: CircularProgressIndicator()),
                          const SizedBox(height: 16),
                          if (_chewieController != null)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_chewieController!.videoPlayerController.value.isPlaying) {
                                    _chewieController!.videoPlayerController.pause();
                                  } else {
                                    _chewieController!.videoPlayerController.play();
                                  }
                                });
                              },
                              child: Icon(
                                _chewieController!.videoPlayerController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      
                    // Improved Audio Player Section
                    if (widget.audio != null && audioUrl.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade800, Colors.blue.shade500],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: _isAudioLoading 
                                        ? const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              _isPlaying ? Icons.pause : Icons.play_arrow,
                                              size: 36,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => _initAudio(audioUrl),
                                          ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Audio ${widget.subJudul}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Tap to play audio content',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                      pressedElevation: 8,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                    thumbColor: Colors.white,
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                                    overlayColor: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Slider(
                                    value: _totalDuration.inSeconds > 0
                                        ? _currentPosition.inSeconds.toDouble().clamp(0, _totalDuration.inSeconds.toDouble())
                                        : 0,
                                    min: 0,
                                    max: _totalDuration.inSeconds > 0
                                        ? _totalDuration.inSeconds.toDouble()
                                        : 1.0,
                                    onChanged: (value) {
                                      if (_isAudioInitialized) {
                                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_currentPosition),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_totalDuration),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.replay_10,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      onPressed: _isAudioInitialized
                                          ? () {
                                              final newPosition = Duration(
                                                  seconds: (_currentPosition.inSeconds - 10)
                                                      .clamp(0, _totalDuration.inSeconds));
                                              _audioPlayer.seek(newPosition);
                                            }
                                          : null,
                                    ),
                                    const SizedBox(width: 24),
                                    IconButton(
                                      icon: Icon(
                                        Icons.forward_30,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 28,
                                      ),
                                      onPressed: _isAudioInitialized
                                          ? () {
                                              final newPosition = Duration(
                                                  seconds: (_currentPosition.inSeconds + 30)
                                                      .clamp(0, _totalDuration.inSeconds));
                                              _audioPlayer.seek(newPosition);
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}