import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/tflite/recognition.dart';
import 'package:object_detection/tflite/stats.dart';
import 'package:object_detection/ui/box_widget.dart';
import 'package:object_detection/ui/camera_view_singleton.dart';

import 'camera_view.dart';

/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats

var pointHeight;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Results to draw bounding boxes
  List<Recognition> results;

  /// Realtime stats
  Stats stats;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(resultsCallback, statsCallback),

          // Bounding boxes
          boundingBoxes(results),

          // Heading
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 30.0),
              child: Text(
                'Blind',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent.withOpacity(0.6),
                ),
              ),
            ),
          ),

          // Bottom Sheet

          Align(
            //   alignment: Alignment.bottomCenter,
            // ClipPath(
            //   clipper: MyClipper(),
            // child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: deviceHeight / 3,
              // margin: const EdgeInsets.only(top: 100.0),
              decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  // 沒有狀態
                  color: Colors.white.withOpacity(0.9),
                  // 不能過
                  // color: Colors.red.withOpacity(0.9),
                  // 可以過
                  // color: Colors.green.withOpacity(0.9),
                  // 趕快過
                  // color: Colors.yellowAccent.withOpacity(0.9),
                  borderRadius: BORDER_RADIUS_BOTTOM_SHEET),
              child: Container(
                // controller: scrollController,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(Icons.keyboard_arrow_up,
                      //     size: 48, color: Colors.orange),
                      (stats != null)
                          ? Padding(
                              padding: const EdgeInsets.all(45.0),
                              child: Column(
                                children: [
                                  StatsRow(
                                      '目前燈號：', '${stats.inferenceTime} ms'),
                                  StatsRow(
                                      '剩餘秒數：', '${stats.inferenceTime} ms'),
                                  // StatsRow('Inference time:',
                                  //     '${stats.inferenceTime} ms'),
                                  // StatsRow('Total prediction time:',
                                  //     '${stats.totalElapsedTime} ms'),
                                  // StatsRow('Pre-processing time:',
                                  //     '${stats.preProcessingTime} ms'),
                                  // StatsRow('Frame',
                                  //     '${CameraViewSingleton.inputImageSize?.width} X ${CameraViewSingleton.inputImageSize?.height}'),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }

  static const BOTTOM_SHEET_RADIUS = Radius.circular(38.0);
  static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
      topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.moveTo(0, 0);
//     path.quadraticBezierTo(size.width / 2, size.height / 5, size.width, 0);
//     // path.lineTo(0, size.height - 80);
//     // path.quadraticBezierTo(
//     //     size.width / 2, size.height, size.width, size.height - 80);
//     // path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
