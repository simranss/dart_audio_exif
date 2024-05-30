import 'dart:io';
import 'dart:typed_data';

import 'package:audio_exif/audio_exif.dart';

import 'ascii_to_char.dart';

class VorbisExtractor implements MetadataExtractor {
  final bytesToRead = 10000;
  @override
  Future<Map<Frame, dynamic>> extractMetadataFromFile(File file) async {
    RandomAccessFile randomAccessFile = await file.open(mode: FileMode.read);

    final fileSize = await file.length();
    print('fileSize: $fileSize');

    await randomAccessFile.setPosition(0);
    final List<int> data = await randomAccessFile
        .read(bytesToRead <= fileSize ? bytesToRead : fileSize - 1);
    final fileData = AsciiToChar.fromIntList(data);

    return _extractMetadata(fileData);
  }

  Map<Frame, dynamic> _extractMetadata(String fileData) {
    Map<Frame, dynamic> metadata = {};
    int commentHeaderIndex = fileData.indexOf("vorbis");

    if (commentHeaderIndex != -1) {
      int commentsStartIndex = commentHeaderIndex + "vorbis".length;
      String comments = fileData.substring(commentsStartIndex);

      metadata[Frame.title] = _extractVorbisComment(comments, "TITLE");
      metadata[Frame.artist] = _extractVorbisComment(comments, "ARTIST");
      metadata[Frame.album] = _extractVorbisComment(comments, "ALBUM");
      metadata[Frame.unsynchronizedLyrics] =
          _extractVorbisComment(comments, "LYRICS");
      metadata[Frame.year] = _extractVorbisComment(comments, "DATE");
      metadata[Frame.genre] = _extractVorbisComment(comments, "GENRE");
    }

    return metadata;
  }

  String _extractVorbisComment(String comments, String field) {
    RegExp exp = RegExp("$field=(.*)", caseSensitive: false);
    final match = exp.firstMatch(comments);
    String data = match?.group(1) ?? '';
    return _getData(data);
  }

  String _getData(String data) {
    String noise = 'ÿþ';
    data = ' $data'.trim();
    if (data.contains('http')) {
      int contentStartIndex = data.indexOf('http');
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
    final fileData = AsciiToChar.fromIntList(data);

    return _extractMetadata(fileData);
  }

  @override
  Future<Map<Frame, dynamic>> extractMetadataFromPath(String path) {
    return extractMetadataFromFile(File(path));
  }
}
