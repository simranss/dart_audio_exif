<!--
This README describes the package. If you publish this package to pub.dev, this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Audio Exif

A package that helps you get the necessary metadata out of audio files

## Features

Gets metadata from audio files.
The list of supported audio file formats:

1. .mp3
2. .ogg
3. .wav

## Getting started

Add the package to your `pubspec.yaml` file and get started.

## Usage

For getting metadata from file path

```dart
// file path
final path = 'path_to_file/file.mp3';
final fileExtension = 'mp3'; // can be mp3, wav, ogg

MetadataExtractor extractor = MetadataExtractorFactory.getExtractor(fileExtension);
final metadata = await extractor.extractMetadataFromPath(path);
```

For getting metadata from file bytes

```dart
// bytes
final Uint8List bytes;
final fileExtension = 'mp3'; // can be mp3, wav, ogg

MetadataExtractor extractor = MetadataExtractorFactory.getExtractor(fileExtension);
final metadata = await extractor.extractMetadataFromBytes(bytes);
```

For getting metadata from file

```dart
// file object
final File file;
final fileExtension = 'mp3'; // can be mp3, wav, ogg

MetadataExtractor extractor = MetadataExtractorFactory.getExtractor(fileExtension);
final metadata = await extractor.extractMetadataFromFile(file);
```

## Additional information

[GitHub Repository](https://github.com/simranss/dart_audio_exif)
