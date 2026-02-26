import 'package:flutter/material.dart';

class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final double endScale;
  const BreathingWidget({
    Key? key,
    required this.child,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 3000),
    this.endScale = 1.3,
  }) : super(key: key);

  @override
  _BreathingWidgetState createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: widget.endScale).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
        ),
      ),
      child: widget.child,
    );
  }
}
// PlasmaRenderer(
//               type: PlasmaType.infinity,
//               particles: 7,
//               color: Theme.of(context).brightness == Brightness.light
//                   ? Color(0x28B4B4B4)
//                   : Color(0x44B6B6B6),
//               blur: 0.4,
//               size: 0.8,
//               speed: Theme.of(context).brightness == Brightness.light ? 4 : 3,
//               offset: 0,
//               blendMode: BlendMode.plus,
//               particleType: ParticleType.atlas,
//               variation1: 0,
//               variation2: 0,
//               variation3: 0,
//               rotation: 0,
//             ),


// breathing animation
//  SizedBox(height: 32.v),
//                 SizedBox(
//                   height: 200,
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             tileMode: TileMode.mirror,
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Colors.red, Colors.yellow, Colors.green],
//                             stops: [
//                               0,
//                               0.3,
//                               1.3,
//                             ],
//                           ),
//                           backgroundBlendMode: BlendMode.srcOver,
//                         ),
//                         child: PlasmaRenderer(
//                           type: PlasmaType.infinity,
//                           particles: 7,
//                           color:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? const Color(0x28B4B4B4)
//                                   : const Color(0x44B6B6B6),
//                           blur: 0.4,
//                           size: 0.8,
//                           speed:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? 4
//                                   : 3,
//                           offset: 0,
//                           blendMode: BlendMode.plus,
//                           particleType: ParticleType.atlas,
//                           variation1: 0,
//                           variation2: 0,
//                           variation3: 0,
//                           rotation: 0,
//                           child: Container(
//                             child: const Text("hdhhdhd"),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),


