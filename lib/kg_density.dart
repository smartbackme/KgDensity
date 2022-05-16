library kg_density;
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';




mixin KgFlutterBinding on WidgetsFlutterBinding{

  @override
  ViewConfiguration createViewConfiguration() {
    if(KgDensity._screenStandard!=null){
      return ViewConfiguration(
        size: KgDensity._getSize(),
        devicePixelRatio: KgDensity._getDevicePixelRatio(),
      );
    }else{
      return super.createViewConfiguration();
    }

  }

  /// 因为修改了 devicePixelRatio ，得适配点击事件  GestureBinding
  @override
  void initInstances() {
    super.initInstances();
    if(KgDensity._screenStandard!=null){
      window.onPointerDataPacket = _handlePointerDataPacket;
    }
  }

  @override
  void unlocked() {
    super.unlocked();
    if(KgDensity._screenStandard!=null){
      _flushPointerEventQueue();
    }

  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(PointerDataPacket packet) {
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用我们修改的
        KgDensity._getDevicePixelRatio()));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if(KgDensity._screenStandard!=null){
      if (_pendingPointerEvents.isEmpty && !locked)
        scheduleMicrotask(_flushPointerEventQueue);
      _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
    }else{
      super.cancelPointer(pointer);
    }


  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty)
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer)!;
    } else if (event.down) {
      result = _hitTests[event.pointer]!;
    } else {
      return; // We currently ignore add, remove, and hover move events.
    }
    if (result != null) dispatchEvent(event, result);
  }
}

class KgDensity{

  static double _devicePixelRatio = 3.0;

  static double _screenWidth = 300;

  static double _screenHeight = 800;

  static double? _screenStandard;

  static Size _screenSize = Size.zero;

  static bool _autoTextSize = true;

  // static Size? designSize;
  // static double? ratio;

  // static void _updateDensityInfo(){
  //   ratio = max(1.0, window.physicalSize.width / designWidth);
  // }

  static TransitionBuilder initSize({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, _appBuilder(context,child));
      } else {
        return _appBuilder(context,child);
      }
    };
  }

  static Widget _appBuilder(BuildContext context, Widget? widget) {
    //viewInsets: 各个边显示的内容和能显示内容的边距大小；譬如:没有键盘的时候viewInsets.bottom为0，当有键盘的时候键盘挡住了一些区域，键盘底下无法显示内容，所以viewInsets.bottom就变成了键盘的高度。
    EdgeInsets viewInsets =  MediaQuery.of(context).viewInsets;
    //padding: 系统UI的显示区域如状态栏，这部分区域最好不要显示内容，否则有可能被覆盖了。譬如，很多iPhone顶部的刘海区域，padding.top就是其高度。
    EdgeInsets pading =  MediaQuery.of(context).padding;
    //viewPadding:viewInsets和padding的和
    EdgeInsets viewPadding =  MediaQuery.of(context).viewPadding;
    //重新计算 viewInsets 主要是需要重新计算bottom
    var adapterEdge=  EdgeInsets.fromLTRB(viewInsets.left, viewInsets.top, viewInsets.right,getRealSize(viewInsets.bottom));
    //重新计算 pading 主要是需要重新计算bottom & top
    var adapterPadding=  EdgeInsets.fromLTRB(pading.left, getRealSize(pading.top), pading.right,getRealSize(pading.bottom));
    //重新计算 viewPadding 主要是需要重新计算bottom & top
    var adapterViewPadding=  EdgeInsets.fromLTRB(viewPadding.left, getRealSize(viewPadding.top), viewPadding.right,getRealSize(viewPadding.bottom));

    return MediaQuery(
      // 这里如果设置 textScaleFactor = 1.0 ，就不会随着系统字体大小去改变了
      data: MediaQuery.of(context).copyWith(
          size: Size(KgDensity._screenWidth, KgDensity._screenHeight),
          devicePixelRatio: KgDensity._devicePixelRatio,
          textScaleFactor:
          _autoTextSize ? MediaQuery.of(context).textScaleFactor : 1.0,viewInsets:adapterEdge,padding: adapterPadding,viewPadding: adapterViewPadding),
      child: widget!,
    );
  }

  // static _adapterTheme(BuildContext context, Widget? widget) {
  //
  //   return Theme(
  //     data: Theme.of(context).copyWith(),
  //     child: widget!,
  //   );
  // }

  /// 获取真正的大小，比如 kToolbarHeight kBottomNavigationBarHeight
  static double getRealSize(double size) {
    return size / (_devicePixelRatio / window.devicePixelRatio);
  }

  // static void initKgDensity({double? designWidth,double? isAutoTextSize}){
  /// 如果是横屏 就以高度为基准
  /// 如果是竖屏 就以宽度为基准
  /// designWidth 就是手机宽度
  /// 是否随着系统的文字大小而改变，默认是改变
  static void initKgDensity({double designWidth = 375,bool isAutoTextSize = true}){
    _screenStandard = designWidth;
    _autoTextSize = isAutoTextSize;
  }


  // var originalSize = window.physicalSize / window.devicePixelRatio;
  // var originalWidth = originalSize.width;
  // var originalHeight = originalSize.height;
  // if (originalHeight > originalWidth) {
  //   // 竖屏
  //   _devicePixelRatio =
  //       window.physicalSize.width / KgDensity._screenStandard;
  // } else {
  //   // 横屏
  //   _devicePixelRatio =
  //       window.physicalSize.height / KgDensity._screenStandard;
  // }
  // return _devicePixelRatio;

  /// 根据设置 的 宽度 来得到 devicePixelRatio  根据最短边来计算 ratio
  static double _getDevicePixelRatio() => _devicePixelRatio = min(window.physicalSize.width,window.physicalSize.height)/KgDensity._screenStandard!;

  /// 根据设置的宽度，来得到对应的SIZE
  static Size _getSize() {
    // 如果是横屏就已宽度为基准


    // var originalSize = window.physicalSize / window.devicePixelRatio;
    // var originalWidth = originalSize.width;
    // var originalHeight = originalSize.height;
    if (window.physicalSize.height  > window.physicalSize.width) {
      // 竖屏
      _screenHeight = window.physicalSize.height / _getDevicePixelRatio();
      _screenWidth = _screenStandard!;
      _screenSize = Size(_screenStandard!, _screenHeight);
      return _screenSize;
    } else {
      // 横屏
      _screenWidth = window.physicalSize.width / _getDevicePixelRatio();
      _screenHeight = _screenStandard!;
      _screenSize = Size(_screenWidth, _screenStandard!);
      return _screenSize;
    }
  }

}