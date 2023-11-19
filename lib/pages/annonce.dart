import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class Video {
  final String titre;
  final String image;

  Video({required this.titre, required this.image});
}

class Annonce extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnnonceState();
  }
}

class AnnonceState extends State<Annonce> {
  late CustomVideoPlayerController _customVideoPlayerController;
  List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos().then((fetchedVideos) {
      setState(() {
        videos = fetchedVideos;
      });
    });
    initializeVideoPlayer();

  }

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/annonces"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((videoData) => Video(
        titre: videoData['titre'],
        image: videoData['image'],
      )).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }


  void initializeVideoPlayer() {
    _customVideoPlayerController = CustomVideoPlayerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Image.asset(
                  "assets/images/megaphone.png",
                  width: 188,
                  height: 169,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Annonces",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(videos[index].titre),
                  onTap: () {
                    _customVideoPlayerController.play(videos[index].image);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class CustomVideoPlayerController {
  late VideoPlayerController _videoPlayerController;

  CustomVideoPlayerController();

  void play(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.network(videoUrl);

    await _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  void dispose() {
    _videoPlayerController.dispose();
  }
}
