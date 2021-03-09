import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  bool get isPlaying => _controller?.isActive ?? false;
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  String _anim = "spin1";

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/flare.riv').then(
      (data) async {
        final file = RiveFile();

        if (file.import(data)) {
          final artboard = file.mainArtboard;

          artboard.addController(_controller = SimpleAnimation('Animation 1'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () {
          setState(() {
            if (_anim == "spin1")
              _anim = "spin2";
            else
              _anim = "spin2";
          });
        },
        child: Container(
          width: 200,
          height: 200,
          child: _riveArtboard == null
              ? const SizedBox()
              : Rive(artboard: _riveArtboard),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
