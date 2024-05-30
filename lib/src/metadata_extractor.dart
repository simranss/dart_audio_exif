import 'dart:io';
import 'dart:typed_data';

import 'frame.dart';

abstract class MetadataExtractor {
  Future<Map<Frame, dynamic>> extractMetadataFromFile(File file);
  Future<Map<Frame, dynamic>> extractMetadataFromPath(String path);
  Map<Frame, dynamic> extractMetadataFromBytes(Uint8List bytes);
}
