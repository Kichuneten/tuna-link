import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tunalink/src/domain/features/postdate_formatter.dart';
import 'package:tunalink/src/presentation/theme/sizes.dart';
import 'package:tunalink/src/presentation/widgets/riched_text.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  PostWidgetState createState() => PostWidgetState();
}

class PostWidgetState extends State<PostWidget> {
  late AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();


    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('test.mp3'));
    _audioPlayer.stop();

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('test.mp3'));
      // await _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("wanna see the details of this post?");
      },
      child: Card(
        key: ValueKey("postcard-unique"),
        margin: const EdgeInsets.all(10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                debugPrint("wanna see this user?");
                              },
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                              "testUser",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: MyFontSize.l,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                maxLines: 1,
                                                '@my_user',
                                                style: const TextStyle(
                                                  fontSize: MyFontSize.m,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          "-${formatTimeAgo("2024/12/26 AM 10:21:50")}",
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const RichedText(
                        "this is test post content #test ",
                        fontSize: 16,
                      ),
                      //_audioSection(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

                //右側のいいね等メニュー
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: Text("this is post menu"));
                          },
                          showDragHandle: true,
                          scrollControlDisabledMaxHeightRatio: 0.6,
                        );
                      },
                      splashColor: Colors.transparent,
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.more_horiz),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // PopupMenuButton<String>(
                    //   onSelected: (value) {
                    //     if (value == 'report') {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(content: Text('報告しました（未実装）')),
                    //       );
                    //     } else if (value == 'delete') {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(content: Text('削除しました（未実装）')),
                    //       );
                    //     } else if (value == 'mute') {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(content: Text('ミュートしました（未実装）')),
                    //       );
                    //     }
                    //   },
                    //   itemBuilder: (BuildContext context) {
                    //     return [
                    //       const PopupMenuItem<String>(
                    //         value: 'report',
                    //         child: Text('報告(未実装)'),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'delete',
                    //         child: Text('削除（未実装）'),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'mute',
                    //         child: Text('ミュート（未実装）'),
                    //       ),
                    //     ];
                    //   },
                    // ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        debugPrint("favorite icon tapped");
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                    const Text(
                      "12",
                      style: TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: () async {
                        debugPrint("Comment icon tapped!");
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: Text("this is comment sheet"));
                          },
                          showDragHandle: true,
                          scrollControlDisabledMaxHeightRatio: 0.6,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.comment_outlined),
                      ),
                    ),
                    const Text(
                      "1",
                      style: TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _audioSection() {
    return Column(
      children: [
        const Divider(),
        //audio
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300), // アニメーションの時間を設定
                  width: 60,
                  height: 60, // 同じく高さも変化
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: _isPlaying ? 3 : 0,
                        blurRadius: _isPlaying ? 15 : 0,
                        offset: const Offset(0, 0), // 光の広がりを調整
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          const Image(
                            image: AssetImage("assets/test2.jpg"),
                            fit: BoxFit.cover,
                          ),
                          Center(
                            child: AnimatedContainer(
                              duration: const Duration(
                                  milliseconds: 300), // アニメーションの時間を設定
                              width: _isPlaying
                                  ? 30
                                  : 100, // _isPlaying が true の場合は小さなサイズ
                              height: _isPlaying ? 30 : 100, // 同じく高さも変化
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(100, 0, 0, 0),
                                borderRadius: BorderRadius.circular(_isPlaying
                                    ? 30
                                    : 0), // _isPlaying が true の場合は丸い角
                              ),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: _togglePlayPause,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Untitled",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${_currentPosition.inMinutes}:${_currentPosition.inSeconds.remainder(60).toString().padLeft(2, '0')}"
                      " / "
                      "${_totalDuration.inMinutes}:${_totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          // activeTrackColor:
                          //     Colors.green, // 適用されてる領域
                          inactiveTrackColor: Colors.grey, // 適用されていない領域
                          trackHeight: 2.0, // スライダーの幅
                          // thumbColor: Colors.red, // つまみの色
                          overlayColor: Colors.blue, // つまみを掴んだ時に広がる領域の色
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5.0), // つまみの大きさ
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 0.0), // つまみを掴んだ時に広がる領域の大きさ
                        ),
                        child: Slider(
                          value: _currentPosition.inSeconds.toDouble(),
                          max: _totalDuration.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(position);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
