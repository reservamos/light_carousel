import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// list of [DotPosition]
enum DotPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// main [library]
class LightCarousel extends StatefulWidget {
  /// All list of images on this Carousel
  /// Provide The Image whether it's from [Netowrk] or local [Assets].
  /// Implement [NetworkImage('imageUrl')], [AssetImage('assets/image.png')]
  final List? images;

  /// All Images on this Carousel
  final dynamic defaultImage;

  /// Transtition animation timing curver. The default is [Curves.ease]
  /// `Watch out!` some Curves transition caused stuck failed to animate
  /// Do not use [Curves.easeInBack] and some of unknown animation.
  final Curve animationCurve;

  /// Transmition [Duration] 300ms is default value
  final Duration animationDuration;

  /// Base [dotSize] 8.0 is default
  final double dotSize;

  /// Increase size of the selected [DOT] default value is 2.0
  final double dotIncreaseSize;

  /// The distance between each DOT default value is 25.0
  final double dotSpacing;

  /// Color of each [DOT] [Colors.white] is default
  final Color dotColor;

  /// he background Color of the dots. Default is [Colors.grey[800].withOpacity(0.5)]
  final Color? dotBgColor;

  /// The Color of each increased dot. Default is [Colors.white]
  final Color dotIncreasedColor;

  /// The Color of each increased dot. Default is [Colors.white]
  final bool showIndicator;

  /// Padding Size of the background [Indicator]. Default is 20.0
  final double indicatorBgPadding;

  /// How to show the [images] in the box. Default is [BoxFit.cover]
  final BoxFit boxFit;

  /// Enable or Disable radius Border for the images. Default is [false]
  final bool borderRadius;

  /// [Border] [Radius] of the [images]. Default is [Radius.circular(8.0)]
  final Radius? radius;

  /// Indicator position. Default [DotPosition.bottomCenter]
  final DotPosition dotPosition;

  /// Move the Indicator Horizontally relative to the dot [position]
  final double dotHorizontalPadding;

  /// Move the Indicator Vertically relative to the dot [position]
  final double dotVerticalPadding;

  /// Move the [Indicator] From the [Bottom]
  final double moveIndicatorFromBottom;

  /// Remove the radius bottom from the indicator background. Default false
  final bool noRadiusForIndicator;

  /// Enable/Disable Image Overlay Shadow. Default false
  final bool overlayShadow;

  /// Choose the color of the overlay Shadow color. Default [Colors.grey[800]]
  final Color? overlayShadowColors;

  /// Choose the size of the Overlay Shadow, from 0.0 to 1.0. Default 0.5
  final double overlayShadowSize;

  /// Enable/Disable the auto play of the slider. Default true
  final bool autoPlay;

  /// [Duration] of the Auto play slider by seconds. Default [Duration(seconds: 3)]
  final Duration autoPlayDuration;

  /// [Duration] of the Auto play slider by seconds. Default 3 seconds
  final void Function(int)? onImageTap;

  /// On image change event, passes previous image index and current image index as arguments
  final void Function(int, int)? onImageChange;

  /// On image change event, passes previous image index and current image index as arguments
  final PageController? controller;

  const LightCarousel({
    Key? key,
    this.images,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 300),
    this.dotSize = 8.0,
    this.dotSpacing = 25.0,
    this.dotIncreaseSize = 2.0,
    this.dotColor = Colors.white,
    this.dotBgColor,
    this.dotIncreasedColor = Colors.white,
    this.showIndicator = true,
    this.indicatorBgPadding = 20.0,
    this.boxFit = BoxFit.cover,
    this.borderRadius = false,
    this.radius,
    this.dotPosition = DotPosition.bottomCenter,
    this.dotHorizontalPadding = 0.0,
    this.dotVerticalPadding = 0.0,
    this.moveIndicatorFromBottom = 0.0,
    this.noRadiusForIndicator = false,
    this.overlayShadow = false,
    this.overlayShadowColors,
    this.overlayShadowSize = 0.5,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.onImageTap,
    this.onImageChange,
    this.defaultImage,
    this.controller,
  })  : assert(animationCurve != Curves.easeInBack,
            'Do not use Curves.easeInBack it caused animate failed!'),
        super(key: key);

  @override
  State<LightCarousel> createState() => _LightCarouselState();
}

class _LightCarouselState extends State<LightCarousel> {
  Timer? timer;
  int _currentImageIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _pageController = widget.controller!;
    }

    if (widget.images != null && widget.images!.isNotEmpty) {
      if (widget.autoPlay) {
        timer = Timer.periodic(widget.autoPlayDuration, (timer) {
          if (_pageController.page?.round() == widget.images!.length - 1) {
            _pageController.animateToPage(
              0,
              duration: widget.animationDuration,
              curve: widget.animationCurve,
            );
          } else {
            _pageController.nextPage(
              duration: widget.animationDuration,
              curve: widget.animationCurve,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget>? listImages = ((widget.images != null &&
                widget.images!.isNotEmpty)
            ? widget.images?.map(
                (networkImage) {
                  if (networkImage is ImageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius
                            ? BorderRadius.all(
                                widget.radius ?? const Radius.circular(8.0))
                            : null,
                        image: DecorationImage(
                          //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: networkImage,
                          fit: widget.boxFit,
                        ),
                      ),
                      child: widget.overlayShadow
                          ? Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      stops: [
                                    0.0,
                                    widget.overlayShadowSize
                                  ],
                                      colors: [
                                    widget.overlayShadowColors != null
                                        ? widget.overlayShadowColors!
                                            .withOpacity(1.0)
                                        : Colors.grey[800]!.withOpacity(1.0),
                                    widget.overlayShadowColors != null
                                        ? widget.overlayShadowColors!
                                            .withOpacity(0.0)
                                        : Colors.grey[800]!.withOpacity(0.0),
                                  ])),
                            )
                          : const SizedBox(),
                    );
                  } else if (networkImage is FadeInImage) {
                    return ClipRRect(
                      borderRadius: widget.borderRadius
                          ? BorderRadius.all(
                              widget.radius ?? const Radius.circular(8.0))
                          : BorderRadius.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            stops: [0.0, widget.overlayShadowSize],
                            colors: [
                              widget.overlayShadowColors != null
                                  ? widget.overlayShadowColors!.withOpacity(1.0)
                                  : Colors.grey[800]!.withOpacity(1.0),
                              widget.overlayShadowColors != null
                                  ? widget.overlayShadowColors!.withOpacity(0.0)
                                  : Colors.grey[800]!.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: networkImage,
                      ),
                    );
                  } else {
                    return networkImage;
                  }
                },
              ).toList()
            : [
                widget.defaultImage is ImageProvider
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius
                              ? BorderRadius.all(
                                  widget.radius ?? const Radius.circular(8.0))
                              : null,
                          image: DecorationImage(
                            // colorFilter: ColorFilter.mode(
                            //     Colors.black.withOpacity(0.2),
                            //     BlendMode.dstATop),
                            image: widget.defaultImage,
                            fit: widget.boxFit,
                          ),
                        ),
                        child: widget.overlayShadow
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    stops: [0.0, widget.overlayShadowSize],
                                    colors: [
                                      widget.overlayShadowColors != null
                                          ? widget.overlayShadowColors!
                                              .withOpacity(1.0)
                                          : Colors.grey[800]!.withOpacity(1.0),
                                      widget.overlayShadowColors != null
                                          ? widget.overlayShadowColors!
                                              .withOpacity(0.0)
                                          : Colors.grey[800]!.withOpacity(0.0)
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      )
                    : widget.defaultImage,
              ])
        ?.cast<Widget>(); // Widget casting here

    final bottom = [
      DotPosition.bottomLeft,
      DotPosition.bottomCenter,
      DotPosition.bottomRight
    ].contains(widget.dotPosition)
        ? widget.dotVerticalPadding
        : null;
    final top = [
      DotPosition.topLeft,
      DotPosition.topCenter,
      DotPosition.topRight
    ].contains(widget.dotPosition)
        ? widget.dotVerticalPadding
        : null;
    double? left = [DotPosition.topLeft, DotPosition.bottomLeft]
            .contains(widget.dotPosition)
        ? widget.dotHorizontalPadding
        : null;
    double? right = [DotPosition.topRight, DotPosition.bottomRight]
            .contains(widget.dotPosition)
        ? widget.dotHorizontalPadding
        : null;

    if (left == null && right == null) {
      left = right = 0.0;
    }

    return Stack(
      children: <Widget>[
        Builder(
          builder: (_) {
            Widget pageView = PageView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _pageController,
              children: listImages!,
              onPageChanged: (currentPage) {
                if (widget.onImageChange != null) {
                  widget.onImageChange!(_currentImageIndex, currentPage);
                }

                _currentImageIndex = currentPage;
              },
            );

            if (widget.onImageTap == null) {
              return pageView;
            }

            return GestureDetector(
              child: pageView,
              onTap: () => widget.onImageTap!(_currentImageIndex),
            );
          },
        ),
        widget.showIndicator
            ? Positioned(
                bottom: bottom,
                top: top,
                left: left,
                right: right,
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
                                bottomRight: widget.radius ??
                                    const Radius.circular(8.0)))
                        : null,
                  ),
                  padding: EdgeInsets.all(widget.indicatorBgPadding),
                  child: Center(
                    child: DotsIndicator(
                      controller: _pageController,
                      itemCount: listImages!.length,
                      color: widget.dotColor,
                      increasedColor: widget.dotIncreasedColor,
                      dotSize: widget.dotSize,
                      dotSpacing: widget.dotSpacing,
                      dotIncreaseSize: widget.dotIncreaseSize,
                      onPageSelected: (int page) {
                        _pageController.animateToPage(
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
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    Key? key,
    this.controller,
    required this.itemCount,
    this.onPageSelected,
    this.color,
    this.increasedColor,
    required this.dotSize,
    this.dotIncreaseSize,
    this.dotSpacing,
  }) : super(key: key, listenable: controller!);

  /// The [PageController] that this [DotsIndicator] is representing.
  final PageController? controller;

  /// The number of items managed by the [PageController]
  final int itemCount;

  /// Called when a dot is [tapped]
  final ValueChanged<int>? onPageSelected;

  /// The color of the dots.
  final Color? color;

  /// The color of the increased dot.
  final Color? increasedColor;

  /// The base size of the dots
  final double dotSize;

  /// The increase in the size of the selected dot
  final double? dotIncreaseSize;

  /// The distance between the center of each dot
  final double? dotSpacing;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller?.page ?? controller!.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (dotIncreaseSize! - 1.0) * selectedness;
    final dotColor = zoom > 1.0 ? increasedColor : color;
    return SizedBox(
      width: dotSpacing,
      child: Center(
        child: Material(
          color: dotColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize * zoom,
            height: dotSize * zoom,
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
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
