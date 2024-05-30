import 'dart:io';
import 'dart:typed_data';

import 'package:audio_exif/audio_exif.dart';

import 'ascii_to_char.dart';
import 'extension_methods.dart';

class WAVExtractor implements MetadataExtractor {
  final bytesToRead = 10000;
  @override
  Future<Map<Frame, dynamic>> extractMetadataFromFile(File file) async {
    RandomAccessFile randomAccessFile = await file.open(mode: FileMode.read);

    final fileSize = await file.length();
    print('fileSize: $fileSize');

    await randomAccessFile.setPosition(0);
    final List<int> data = await randomAccessFile
        .read(bytesToRead <= fileSize ? bytesToRead : fileSize - 1);

    return _extractMetadata(data);
  }

  Map<Frame, dynamic> _extractMetadata(List<int> fileData) {
    Map<Frame, dynamic> metadata = {};

    int commentHeaderIndex = fileData.indexOfList([82, 73, 70, 70]);

    if (commentHeaderIndex != -1) {
      final listIndex = fileData.indexOfList([76, 73, 83, 84]);
      if (listIndex != -1) {
        final listSize =
            _parseChunkSize(fileData.sublist(listIndex + 4, listIndex + 8));
        final listStartIndex = listIndex + 8;
        metadata = _parseInfoTags(
            fileData.sublist(listStartIndex, listStartIndex + listSize));
      }
    }

    return metadata;
  }

  int _parseChunkSize(List<int> bytes) {
    int size = 0;
    for (int i = 0; i < bytes.length; i++) {
      size |= (bytes[i] & 0xFF) << (i * 8);
    }
    return size;
  }

  Map<Frame, dynamic> _parseInfoTags(List<int> bytes) {
    Map<Frame, dynamic> metadata = {};
    int index = 0;
    while (index < bytes.length) {
      String tag = AsciiToChar.fromIntList(bytes.sublist(index, index + 4));
      int size = _parseChunkSize(bytes.sublist(index + 4, index + 8));
      String value = _getData(
          AsciiToChar.fromIntList(bytes.sublist(index + 8, index + 8 + size))
              .trim());

      switch (tag) {
        case 'INAM':
          metadata[Frame.title] = value;
          break;
        case 'IART':
          metadata[Frame.artist] = value;
          break;
        case 'IPRD':
          metadata[Frame.album] = value;
          break;
        case 'ICRD':
          metadata[Frame.year] = value;
          break;
        case 'IGNR':
          metadata[Frame.genre] = value;
          break;
        case 'LYR':
          metadata[Frame.unsynchronizedLyrics] = value;
          break;
        default:
      }

      index += 8 + size;
    }
    return metadata;
  }

  String _getData(String fileData) {
    String noise = 'ÿþ';
    String content = fileData;
    String data = ' $content'.trim();
    if (data.contains('http')) {
      int contentStartIndex = data.indexOf('http');
      data = data.substring(contentStartIndex);
      if (data.contains(noise)) {
        int contentEndIndex = data.indexOf(noise);
        data = data.substring(0, contentEndIndex);
      }
    } else if (data.contains('image')) {
      int contentStartIndex = data.indexOf('image');
      data = data.substring(contentStartIndex);
      if (data.contains(noise)) {
        int contentEndIndex = data.indexOf(noise);
        data = data.substring(0, contentEndIndex);
      }
    } else {
      while (true) {
        print(data);
        if (data.contains(noise)) {
          int contentStartIndex = data.indexOf(noise) + 2;
          print(contentStartIndex);
          data = data.substring(contentStartIndex);
        } else {
          break;
        }
      }
    }
    return data;
  }

  @override
  Map<Frame, dynamic> extractMetadataFromBytes(Uint8List bytes) {
    final List<int> data =
        bytes.sublist(0, bytesToRead <= bytes.length ? bytesToRead : null);

    return _extractMetadata(data);
  }

  @override
  Future<Map<Frame, dynamic>> extractMetadataFromPath(String path) {
    return extractMetadataFromFile(File(path));
  }
}
