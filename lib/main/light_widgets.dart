import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

/// Main Light Widget
class LightWidget extends StatefulWidget {
  /// All the pages on this Carousel. Must Provide Widget for Pages
  final List<Widget> pages;

  /// Transtition animation timing curver. The default is [Curves.ease]
  /// `Watch out!` some Curves transition caused stuck failed to animate
  /// Do not use [Curves.easeInBack] and some of unknown animation.
  final Curve animationCurve;

  ///The transition animation duration. Default is 300ms.
  final Duration animationDuration;

  /// The base size of the dots. Default is 8.0
  final double dotSize;

  /// The increase in the size of the selected dot. Default is 2.0
  final double dotIncreaseSize;

  /// The distance between the center of each dot. Default is 25.0
  final double dotSpacing;

  /// The Color of each dot. Default is Colors.white
  final Color dotColor;

  /// The background Color of the dots. Default is [Colors.grey[800].withOpacity(0.5)]
  final Color? dotBgColor;

  /// Enable or Disable the indicator (dots). Default is true
  final bool showIndicator;

  /// Padding Size of the background Indicator. Default is 20.0
  final double indicatorBgPadding;

  /// How to show the images in the box. Default is cover
  final BoxFit boxFit;

  /// Enable/Disable radius Border for the images. Default is false
  final bool borderRadius;

  /// Border Radius of the images. Default is [Radius.circular(8.0)]
  final Radius? radius;

  /// Move the Indicator From the Bottom
  final double moveIndicatorFromBottom;

  /// Remove the radius bottom from the indicator background. Default false
  final bool noRadiusForIndicator;

  /// Enable/Disable Image Overlay Shadow. Default false
  final bool overlayShadow;

  /// Choose the color of the overlay Shadow color. Default Colors.grey[800]
  final Color? overlayShadowColors;

  /// Choose the size of the Overlay Shadow, from 0.0 to 1.0. Default 0.5
  final double overlayShadowSize;

  /// Enable/Disable the auto play of the slider. Default is [true]
  final bool autoPlay;

  /// [Duration] of the Auto play slider by seconds. Default 3 seconds
  final Duration autoPlayDuration;

  const LightWidget(
      {Key? key,
      required this.pages,
      this.animationCurve = Curves.ease,
      this.animationDuration = const Duration(milliseconds: 300),
      this.dotSize = 8.0,
      this.dotSpacing = 25.0,
      this.dotIncreaseSize = 2.0,
      this.dotColor = Colors.white,
      this.dotBgColor,
      this.showIndicator = true,
      this.indicatorBgPadding = 20.0,
      this.boxFit = BoxFit.cover,
      this.borderRadius = false,
      this.radius,
      this.moveIndicatorFromBottom = 0.0,
      this.noRadiusForIndicator = false,
      this.overlayShadow = false,
      this.overlayShadowColors,
      this.overlayShadowSize = 0.5,
      this.autoPlay = true,
      this.autoPlayDuration = const Duration(seconds: 3)})
      : assert(animationCurve != Curves.easeInBack,
            'Do not use Curves.easeInBack it caused animate failed!'),
        super(key: key);

  @override
  State createState() => LightWidgetState();
}

class LightWidgetState extends State<LightWidget> {
  PageController controller = PageController();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (widget.autoPlay) {
      timer = Timer.periodic(widget.autoPlayDuration, (_) {
        if (controller.page == widget.pages.length - 1) {
          controller.animateToPage(
            0,
            duration: widget.animationDuration,
            curve: widget.animationCurve,
          );
        } else {
          controller.nextPage(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget>? listPages = widget.pages
        .map((widget) => SizedBox(
              child: widget,
            ))
        .toList();

    return Stack(
      children: <Widget>[
        PageView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          children: listPages!,
        ),
        widget.showIndicator
            ? Positioned(
                bottom: widget.moveIndicatorFromBottom,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        widget.dotBgColor ?? Colors.grey[800]?.withOpacity(0.5),
                    borderRadius: widget.borderRadius
                        ? (widget.noRadiusForIndicator
                            ? null
                            : BorderRadius.only(
                                bottomLeft:
                                    widget.radius ?? const Radius.circular(8.0),
                                bottomRight:
                                    widget.radius ?? const Radius.circular(8.0),
                              ))
                        : null,
                  ),
                  padding: EdgeInsets.all(widget.indicatorBgPadding),
                  child: Center(
                    child: DotsIndicatorWidget(
                      controller: controller,
                      itemCount: listPages.length,
                      color: widget.dotColor,
                      dotSize: widget.dotSize,
                      dotSpacing: widget.dotSpacing,
                      dotIncreaseSize: widget.dotIncreaseSize,
                      onPageSelected: (int page) {
                        controller.animateToPage(
                          page,
                          duration: widget.animationDuration,
                          curve: widget.animationCurve,
                        );
                      },
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicatorWidget extends AnimatedWidget {
  DotsIndicatorWidget({
    Key? key,
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color,
    this.dotSize,
    this.dotIncreaseSize,
    this.dotSpacing,
  }) : super(key: key, listenable: controller ?? PageController());

  /// The [PageController] that this [DotsIndicator] is representing.
  final PageController? controller;

  /// The number of items managed by the [PageController]
  final int? itemCount;

  /// Called when a dot is [tapped]
  final ValueChanged<int>? onPageSelected;

  /// The [color] of the [dots].
  final Color? color;

  /// The base [size] of the dots
  final double? dotSize;

  /// The increase in the [size] of the selected [dot]
  final double? dotIncreaseSize;

  /// The distance between the center of each [dot]
  final double? dotSpacing;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller?.page ?? controller!.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (dotIncreaseSize! - 1.0) * selectedness;
    return SizedBox(
      width: dotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize! * zoom,
            height: dotSize! * zoom,
            child: InkWell(
              onTap: () => onPageSelected!(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount!, _buildDot),
    );
  }
}
