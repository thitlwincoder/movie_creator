# movie_creator

[![Uploaded By][badge]][github]
[![License][license_badge]][license]

`movie_creator` is a flutter package for short video editing with just use scenes and layers like other video editing softwares.

## Getting Started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  movie_creator: latest
```
Next, we need to install this

```sh
# Dart
dart pub get

# Flutter
flutter pub get
```

Finally, you can import and create awesome videos.

```dart
import 'package:movie_creator/movie_creator.dart';
```

## Example

```dart
const width = 576;
const height = 1024;

// create Creator
final creator = MovieCreator(height: height, width: width);

// create Scene
final scene = MovieScene(duration: 5, bgColor: Colors.black);
// add Scene to Creator
creator.addScene(scene);

// create TextLayer with x,y positions and color
final text = TextLayer(
  'Flutter is Awesome',
  x: width / 2,
  y: height / 2,
  color: Colors.white,
);
// add TextLayer to scene
scene.addLayer(text);

// export video
await creator.export(file.path);
```

## Usage

### MovieCreator

```dart
final creator = MovieCreator(
  height: height, // height of the video
  width: width,   // width of the video
  fps: fps,       // fps of the video
);
```

### MovieScene

```dart
final scene = MovieScene(
  duration: 6,
  bgColor: Color(0x0fffcc22),
);
```

### TextLayer

`x` and `y` are start from top left.

```dart
final text = TextLayer(
  'Hello',
  x: width / 2,         // x position
  y: height / 2,        // y position
  bgColor: Colors.red,  // background color
  color: Colors.black,  // text color
  rotate: 10,           // rotate 10 degree
  fontSize: 20,         // font size
  start: 10,            // start from 10 sec
  end: 20,              // end in 20 sec
);
```

### ImageLayer

```dart
// Create ImageLayer with image from asset
final image = ImageLayer.asset('path');

// Create ImageLayer with image from file path
final image = ImageLayer.file('path');

ImageLayer.asset(
  'path',
  x: width / 2,   // x position
  y: height / 2,  // y position
  height: 100     // image height
  width: 200      // image width
  opacity: .5     // opacity of image
  rotate: 10      // rotate 10 degree
);
```

### AlbumLayer

```dart
// Create AlbumLayer with image from asset
final album = AlbumLayer.asset('path');

// Create AlbumLayer with image from file path
final album = AlbumLayer.file('path');

AlbumLayer.asset(
  'path',
  x: width / 2,   // x position
  y: height / 2,  // y position
  height: 100     // image height
  width: 200      // image width
  duration: 10     // duration of album
);
```

### VideoLayer

```dart
// Create ImageLayer with image from asset
final video = VideoLayer.asset('path');

// Create ImageLayer with image from file path
final video = VideoLayer.file('path');

VideoLayer.asset(
  'path',
  x: width / 2,   // x position
  y: height / 2,  // y position
  height: 100     // image height
  width: 200      // image width
  isMute: false   // mute audio of the video
);
```

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue][issue].
If you fixed a bug or implemented a feature, please send a [pull request][pr].

<!-- Links -->

[badge]: https://img.shields.io/badge/uploaded%20by-thitlwincoder-blue
[github]: https://github.com/thitlwincoder
[issue]: https://github.com/thitlwincoder/movie_creator/issues
[pr]: https://github.com/thitlwincoder/movie_creator/pulls
[license_badge]: https://img.shields.io/github/license/thitlwincoder/movie_creator?logo=open-source-initiative&logoColor=green
[license]: https://github.com/thitlwincoder/movie_creator/blob/main/LICENSE