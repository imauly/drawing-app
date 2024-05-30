import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:drawing_app/main.dart';
import 'package:drawing_app/view/canvas/canvas.dart';
import 'package:drawing_app/view/canvas/models/drawing_mode.dart';
import 'package:drawing_app/view/canvas/models/sketch.dart';
import 'package:drawing_app/view/canvas/widgets/canvas_sidebar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/*
*
* drawing page ------------------------------
*
* */
class DrawingPage extends HookWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);

    final canvasGlobalKey = GlobalKey();

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ///
            /// container with the canvas
            Container(
              color: kCanvasColor,
              width: double.maxFinite,
              height: double.maxFinite,
              child: DrawingCanvas(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                drawingMode: drawingMode,
                selectedColor: selectedColor,
                strokeSize: strokeSize,
                eraserSize: eraserSize,
                sideBarController: animationController,
                currentSketch: currentSketch,
                allSketches: allSketches,
                canvasGlobalKey: canvasGlobalKey,
                filled: filled,
                polygonSides: polygonSides,
                backgroundImage: backgroundImage,
              ),
            ),

            ///
            /// drawer widget with animation slider
            Positioned(
              top: kToolbarHeight + 10,
              //left: 10,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(10, 10),
                  end: Offset.zero,
                ).animate(animationController),
                child: CanvasSideBar(
                  drawingMode: drawingMode,
                  selectedColor: selectedColor,
                  strokeSize: strokeSize,
                  eraserSize: eraserSize,
                  currentSketch: currentSketch,
                  allSketches: allSketches,
                  canvasGlobalKey: canvasGlobalKey,
                  filled: filled,
                  polygonSides: polygonSides,
                  backgroundImage: backgroundImage,
                ),
              ),
            ),

            ///
            /// app bar on the top
            _CustomAppBar(animationController: animationController),
          ],
        ),
      ),
    );
  }
}

/*
*
* app bar containing drawer icon ------------------------------
*
* */
class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Lets Draw!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 71, 144),
                fontSize: 19,
              ),
            ),
            SizedBox.fromSize(),
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.palette),
              color: Color.fromARGB(255, 19, 71, 144),
            ),
          ],
        ),
      ),
    );
  }
}
