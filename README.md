


## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.


## kg_density

Is a minimalist screen adaptation scheme, which can quickly help the developed project to adapt the screen

### Getting started

```dart
dependencies:
  kg_density: ^0.0.1
```

The following models are from the iPhone 5S

Before login adaptation

![](https://github.com/smartbackme/KgDensity/blob/main/art/img5.jpg)

After login adaptation

![](https://github.com/smartbackme/KgDensity/blob/main/art/img4.jpg)

Before chart page adaptation

![](https://github.com/smartbackme/KgDensity/blob/main/art/img6.jpg)

After chart page adaptation

![](https://github.com/smartbackme/KgDensity/blob/main/art/img2.jpg)

Before other pages fit

![](https://github.com/smartbackme/KgDensity/blob/main/art/img1.jpg)

After other pages are adapted

![](https://github.com/smartbackme/KgDensity/blob/main/art/img3.jpg)


### Usage

1. Create flutterbinding

```dart

class MyFlutterBinding extends WidgetsFlutterBinding with KgFlutterBinding {

  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) MyFlutterBinding();
    return WidgetsBinding.instance!;
  }
}

```

2. MaterialApp configuration

```dart

MaterialApp(
              theme: ThemeData(),
              builder: KgDensity.initSize(),

            );

```


3. Configuration before startup

```dart

    void main() {
      ///初始化
      KgDensity.initKgDensity(375);
      MyFlutterBinding.ensureInitialized();
      ///运行
      runApp(App());
    }

```

Note:

1. KgDensity.initSize(builder: ??)

In order to facilitate the configuration of other builders, other builders are specially added to the code

usage method

```dart
    builder: KgDensity.initSize(builder: EasyLoading.init()),

```

2. KgDensity.initKgDensity(375)

Digital configuration is configured according to the narrowest side of the design manuscript

> If you do not use kgdensity for adaptation, do not use init

3. Get size correctly

```dart
    MediaQuery.of(context).size

```

Please do not use window physicalSize，MediaQueryData. fromWindow(window)

### Additional information

This code base is reconstructed with reference to its principle and part of the code. Thank you https://github.com/niezhiyang/flutter_autosize_screen