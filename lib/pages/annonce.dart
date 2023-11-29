import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
  List<Video> videos = [];
  late List<ChewieController> _chewieControllers;

  @override
  void initState() {
    super.initState();
    _chewieControllers = [];
    fetchVideos().then((fetchedVideos) {
      setState(() {
        videos = fetchedVideos;
        _initializeChewieControllers();
      });
    });
  }

  Future<List<Video>> fetchVideos() async {
    final response =
    await http.get(Uri.parse("http://10.0.2.2:8080/keneya/annonces"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      List<Video> fetchedVideos = jsonResponse.map((data) {
        return Video(titre: data['titre'],
          image: "http://10.0.2.2/" + data['image'],
        );
      }).toList();

      return fetchedVideos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  void _initializeChewieControllers() {
    _chewieControllers = videos.map((video) {
      return ChewieController(
        videoPlayerController: VideoPlayerController.network(video.image),
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(videos[index].titre),
                        onTap: () {
                          // Pause toutes les vidéos avant de changer de vidéo
                          for (var i = 0; i < _chewieControllers.length; i++) {
                            if (i != index) {
                              _chewieControllers[i].pause();
                            }
                          }
                          // Jouer ou mettre en pause la vidéo actuelle
                          _chewieControllers[index].videoPlayerController.value.isPlaying
                              ? _chewieControllers[index].pause()
                              : _chewieControllers[index].play();
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Chewie(
                          controller: _chewieControllers[index],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
