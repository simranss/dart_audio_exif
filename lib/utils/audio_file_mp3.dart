import 'dart:io';
import 'dart:typed_data';

import 'package:audio_exif/audio_exif.dart';

import 'ascii_to_char.dart';
import 'extension_methods.dart';

class ID3v2Extractor implements MetadataExtractor {
  final _frameHeadersKeys = {
    'TIT2': Frame.title,
    'TALB': Frame.album,
    'TOAL': Frame.originalAlbum,
    'TPE1': Frame.artist,
    'TPE2': Frame.band,
    'TYER': Frame.year,
    'TDRC': Frame.recordingTime,
    'TDRL': Frame.releaseTime,
    'TCON': Frame.genre,
    'USLT': Frame.unsynchronizedLyrics,
    'SYLT': Frame.synchronizedLyrics,
    'TRCK': Frame.trackNumberPositionInSet,
    'TPOS': Frame.partOfASet,
    'POPM': Frame.popularimeter,
    'TSSE': Frame.softwareHardwareAndSettingsUsedForEncoding,
    'TENC': Frame.encodedBy,
    'WOAS': Frame.officialAudioSourceWebpage,
    'COMM': Frame.comments,
    'TCOP': Frame.copyrightMessage,
    'APIC': Frame.attachedPicture
  };

  @override
  Future<Map<Frame, dynamic>> extractMetadataFromFile(File file) async {
    RandomAccessFile randomAccessFile = await file.open(mode: FileMode.read);

    await randomAccessFile.setPosition(0);
    final List<int> headerData = await randomAccessFile.read(11);

    if (headerData.startsWith([73, 68, 51])) {
      final tagSizeData = headerData.sublist(6, 10);
      final tagSize = _parseFrameSize(tagSizeData);

      await randomAccessFile.setPosition(0);
      final List<int> fileDataBytes = await randomAccessFile.read(tagSize + 3);

      return _extractMetadata(headerData, fileDataBytes);
    } else {
      print('not a valid ID3v2 file');
      return {};
    }
  }

  Map<Frame, dynamic> _extractMetadata(
      List<int> headerData, List<int> fileData) {
    Map<Frame, dynamic> metadata = {};

    Map<String, dynamic> headerInfo = _extractHeaderInfo(headerData);

    final frameHeaders = _getFrameHeaders(fileData);

    // Extracting specific metadata fields
    final entries = frameHeaders.entries.toList();
    final length = entries.length;
    for (int i = 0; i < length; i++) {
      var entry = entries[i];
      if (i < length - 1) {
        print(entry.key);
        var nextEntry = entries[i + 1];
        final data = _getData(fileData.sublist(entry.value, nextEntry.value),
            lyrics: entry.key == Frame.unsynchronizedLyrics ||
                entry.key == Frame.synchronizedLyrics,
            image: entry.key == Frame.attachedPicture);
        metadata[entry.key] = data;
      } else {
        print(entry.key);
        final data = _getData(fileData.sublist(entry.value),
            lyrics: entry.key == Frame.unsynchronizedLyrics ||
                entry.key == Frame.synchronizedLyrics,
            image: entry.key == Frame.attachedPicture);
        metadata[entry.key] = data;
      }
    }

    // Adding header information to metadata
    metadata[Frame.headerInfo] = headerInfo;

    return metadata;
  }

  Map<Frame, int> _getFrameHeaders(List<int> fileData) {
    Map<Frame, int> data = {};
    for (var ele in _frameHeadersKeys.entries) {
      data[ele.value] = fileData.indexOfList(ele.key.codeUnits);
    }

    return _sortMapOnValues(data);
  }

  dynamic _getData(List<int> fileData,
      {bool lyrics = false, bool image = false}) {
    int endIndex = lyrics
        ? fileData.length
        : (_parseFrameSize(fileData.sublist(4, 8)) + 10);
    print('size: $endIndex');
    print('data length: ${fileData.length}');
    endIndex = (endIndex > fileData.length) ? fileData.length : endIndex;
    String noise = 'ÿþ';
    String content = AsciiToChar.fromIntList(fileData.sublist(8, endIndex));
    String data = ' $content'.trim();
    if (image) {
      // final imageBytes = getImageBytes(fileData.sublist(8, endIndex));
      int contentStartIndex = data.indexOf('image');
      data = data.substring(contentStartIndex);
      if (data.contains(noise)) {
        int contentEndIndex = data.indexOf(noise);
        data = data.substring(0, contentEndIndex);
      }
    } else if (data.contains('http')) {
      int contentStartIndex = data.indexOf('http');
      data = data.substring(contentStartIndex);
      if (data.contains(noise)) {
        int contentEndIndex = data.indexOf(noise);
        data = data.substring(0, contentEndIndex);
      }
    } else {
      while (true) {
        if (data.contains(noise)) {
          int contentStartIndex = data.indexOf(noise) + 2;
          data = data.substring(contentStartIndex);
        } else {
          break;
        }
      }
      if (lyrics) {
        noise = 'X';
        while (true) {
          if (data.trim().startsWith(noise)) {
            data = data.substring(1);
          } else {
            break;
          }
        }
      }
    }
    noise = 'end(text)';
    if (data.contains(noise)) {
      data = data.replaceAll(RegExp(noise), '').trim();
    }
    return data;
  }

  Map<String, dynamic> _extractHeaderInfo(List<int> fileData) {
    Map<String, dynamic> headerInfo = {};

    // Extracting basic metadata from ID3v2 tags
    List<int> id3Version = fileData.sublist(3, 5);
    int majorVersion = id3Version[0];
    int revision = id3Version[1];

    headerInfo['version'] = id3Version;
    headerInfo['majorVersion'] = majorVersion;
    headerInfo['revision'] = revision;
    headerInfo['tagSize'] = _parseFrameSize(fileData.sublist(6, 10));

    return headerInfo;
  }

  Map<Frame, int> _sortMapOnValues(Map<Frame, int> frames) {
    Map<Frame, int> filteredFrames = frames
      ..removeWhere((key, value) => value < 0);

    List<MapEntry<Frame, int>> sortedEntries = filteredFrames.entries.toList();

    sortedEntries.sort((a, b) => a.value.compareTo(b.value));

    Map<Frame, int> sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }

  int _parseFrameSize(List<int> frameSizeBytes) {
    int frameSize = 0;
    for (int i = 0; i < 4; i++) {
      frameSize <<= 7;
      frameSize |= (frameSizeBytes[i] & 0x7F);
    }
    return frameSize;
  }

  List<int> getImageBytes(List<int> bytes) {
    return bytes;
  }

  @override
  Map<Frame, dynamic> extractMetadataFromBytes(Uint8List bytes) {
    final List<int> headerData = bytes.sublist(0, 11);

    if (headerData.startsWith([73, 68, 51])) {
      final tagSizeData = headerData.sublist(6, 10);
      final tagSize = _parseFrameSize(tagSizeData);

      final List<int> fileDataBytes = bytes.sublist(0, tagSize + 3);

      return _extractMetadata(headerData, fileDataBytes);
    } else {
      print('not a valid ID3v2 file');
      return {};
    }
  }

  @override
  Future<Map<Frame, dynamic>> extractMetadataFromPath(String path) {
    return extractMetadataFromFile(File(path));
  }
}
