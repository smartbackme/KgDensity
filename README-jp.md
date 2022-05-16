## kg_density

kg_densityは、開発されたプロジェクトの適切なスクリーンを迅速に支援する、極めてシンプルなスクリーンアダプティブスキームです。

### 統合開始

```dart
dependencies:
  kg_density: ^0.0.1
```

以下の機種はiphone 5 sから

登録が適切になる前に

![](https://github.com/smartbackme/KgDensity/blob/main/art/img5.png)

ログイン後

![](https://github.com/smartbackme/KgDensity/blob/main/art/img4.png)

グラフのページが合う前に

![](https://github.com/smartbackme/KgDensity/blob/main/art/img6.png)

グラフページの適合後

![](https://github.com/smartbackme/KgDensity/blob/main/art/img2.png)

他のページが適合する前に

![](https://github.com/smartbackme/KgDensity/blob/main/art/img1.png)

その他のページの適合後

![](https://github.com/smartbackme/KgDensity/blob/main/art/img3.png)


### 使用方法：

1.  FlutterBindingの作成

```dart

class MyFlutterBinding extends WidgetsFlutterBinding with KgFlutterBinding {

  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) MyFlutterBinding();
    return WidgetsBinding.instance!;
  }
}

```

2. MaterialApp 構成

```dart

MaterialApp(

              theme: ThemeData(),
              builder: KgDensity.initSize(),

            );

```


3. 起動前の構成

```dart

    void main() {
      ///初期化
      KgDensity.initKgDensity(375);
      MyFlutterBinding.ensureInitialized();
      ///運転
      runApp(App());
    }

```

注意：

1. KgDensity.initSize(builder: ??)

他のbuilder構成を容易にするために、コードに他のbuilderを追加します。

使用方法


```dart
    builder: KgDensity.initSize(builder: EasyLoading.init()),

```

2. KgDensity.initKgDensity(375)

デジタル配置は、設計原稿の最も狭いエッジに従って配置されます。

> KgDesityを使用しないで適合する場合は、initを使用しないでください



3. sizeを正しく取得する

```dart
    MediaQuery.of(context).size

```

 window.physicalSize，MediaQueryData.fromWindow(window) を使用しないでください


## 本コードライブラリはその原理と一部のコードを参考にして、再構築しました。 https://github.com/niezhiyang/flutter_autosize_screen