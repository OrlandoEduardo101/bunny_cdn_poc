import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';

import 'video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final videoId = '';
  final libraryId = '';
  final pullZone = '';
  final apiToken = '';
  final tokenAuthKey = '';
  final exp = DateTime.now().add(const Duration(days: 100)).millisecondsSinceEpoch.toString();

  Future<dynamic> initVimeo() async {
    try {
      String urlGetVideo = 'https://video.bunnycdn.com/library/$libraryId/videos/$videoId';

      final headers = {'AccessKey': apiToken};
      final response = await Uno().get(urlGetVideo, headers: headers);

      final resolution = (response.data['availableResolutions'] as String).split(',').first;

      final token = generateToken();

      String urlVideoCDN = 'https://$pullZone.b-cdn.net/$videoId/play_$resolution.mp4?token=$token&expires=$exp';
      return urlVideoCDN;
    } catch (e) {
      //return VimeoError(error: e.toString());
    }
  }

  String generateToken() {

    /*
    $security_key = 'URL-TOKEN-AUTH-KEY-HERE';
    $expires = (time() + $expires_seconds);
    $hash_base = $security_key . $path . $expires;
    $token = md5($hash_base, true);
    $token = base64_encode($token);
    $token = strtr($token, '+/', '-_');
    $token = str_replace('=', '', $token);
    return "{$zone_url}{$path}?token={$token}&expires={$expires}";
     */

    final tokenPath = '/$libraryId';
    List<int> bytes = utf8.encode(tokenAuthKey + tokenPath + exp);
    final hash = sha256.convert(bytes);
    final base64Str = base64.encode(hash.bytes);
    return base64Str;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(alignment: Alignment.topCenter, children: [
          FutureBuilder<dynamic>(
            future: initVimeo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
                    child: const AspectRatio(aspectRatio: 16 / 9, child: Center(child: CircularProgressIndicator())));
              }

              return VideoPlayerWidget.fromUrl(
                videoUrl: snapshot.data.toString(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 48,
              color: Colors.red.withOpacity(0.3),
              alignment: Alignment.center,
              child: const Text(
                'Vimeo Player Example',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ]));
  }
}
