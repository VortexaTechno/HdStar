
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';


class xxPage extends StatefulWidget {
  ///
  /// AppBar title
  ///


  /// Home page
  xxPage({
    Key? key,

  }) : super(key: key);

  @override
  _xxPageState createState() => _xxPageState();
}

///
/// Page state
///
class _xxPageState extends State<xxPage> {
  // Controller
  final CountdownController _controller =
  new CountdownController(autoStart: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Start
                  ElevatedButton(
                    child: Text('Start'),
                    onPressed: () {
                      _controller.start();
                    },
                  ),
                  // Pause
                  ElevatedButton(
                    child: Text('Pause'),
                    onPressed: () {
                      _controller.pause();
                    },
                  ),
                  // Resume
                  ElevatedButton(
                    child: Text('Resume'),
                    onPressed: () {
                      _controller.resume();
                    },
                  ),
                  // Stop
                  ElevatedButton(
                    child: Text('Restart'),
                    onPressed: () {
                      _controller.restart();
                      setState(() {

                      });
                      print("Restart");
                    },
                  ),
                ],
              ),
            ),
            Countdown(
              controller: _controller,
              seconds: 5,
              build: (_, double time) => Text(
                time.toString(),
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
              interval: Duration(milliseconds: 100),
              onFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Timer is done!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DemoAnimatedSwitcher extends StatefulWidget {
  DemoAnimatedSwitcher({Key? key}) : super(key: key);

  @override
  _DemoAnimatedSwitcherState createState() => _DemoAnimatedSwitcherState();
}

class _DemoAnimatedSwitcherState extends State<DemoAnimatedSwitcher> {
  bool switchChild = true;

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.blue,
      Colors.amber,
      Colors.deepPurple
    ];
    Random random = new Random();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: AnimatedSwitcher(reverseDuration:  const Duration(seconds: 1),
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: switchChild
                  ? Container(
                key: UniqueKey(),
                height: 90.0,
                width: 90.0,
                color: colors[random.nextInt(colors.length)],
              )
                  : Container(
                key: UniqueKey(),
                height: 140.0,
                width: 140.0,
                color: colors[random.nextInt(colors.length)],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Timer.periodic(Duration(milliseconds: 500,), (timer) {

                setState(() {
                  switchChild = !switchChild;
                });
              });

            },
            child: Text('Click'),
          ),
        ],
      ),
    );
  }
}