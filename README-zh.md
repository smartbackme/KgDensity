## kg_density

kg_density 是一个极简的屏幕适配方案，可以快速的帮助已经开发好的项目适配屏幕

### 开始集成

```dart
dependencies:
  kg_density: ^0.0.1
```

以下机型来自 iphone5s

登录适配之前

![](https://github.com/smartbackme/KgDensity/blob/main/art/img5.jpg)

登录适配之后

![](https://github.com/smartbackme/KgDensity/blob/main/art/img4.jpg)

图表页面适配之前

![](https://github.com/smartbackme/KgDensity/blob/main/art/img6.jpg)

图表页面适配之后

![](https://github.com/smartbackme/KgDensity/blob/main/art/img2.jpg)

其他页面适配之前

![](https://github.com/smartbackme/KgDensity/blob/main/art/img1.jpg)

其他页面适配之后

![](https://github.com/smartbackme/KgDensity/blob/main/art/img3.jpg)


### 使用方法：

1. 创建 FlutterBinding

```dart

class MyFlutterBinding extends WidgetsFlutterBinding with KgFlutterBinding {

  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) MyFlutterBinding();
    return WidgetsBinding.instance!;
  }
}

```

2. MaterialApp 配置

```dart

MaterialApp(
              ///定义主题
              theme: ThemeData(),
              builder: KgDensity.initSize(),

            );

```


3. 启动前的配置

```dart

    void main() {
      ///初始化
      KgDensity.initKgDensity(375);
      MyFlutterBinding.ensureInitialized();
      ///运行
      runApp(App());
    }

```

注意说明：

1. KgDensity.initSize(builder: ??)

为了方便其他builder配置，代码中专门增加其他builder

使用方法


```dart
    builder: KgDensity.initSize(builder: EasyLoading.init()),

```

2. KgDensity.initKgDensity(375)

数字配置的是按照设计稿件的最窄边来配置的

> 若不使用KgDensity 进行适配，请不要init

3. 正确获取size

```dart
    MediaQuery.of(context).size

```

请不要使用 window.physicalSize，MediaQueryData.fromWindow(window)


## 本代码库参考其原理与部分代码，重构而成，感谢 https://github.com/niezhiyang/flutter_autosize_screen