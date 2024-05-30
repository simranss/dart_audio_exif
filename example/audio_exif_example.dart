import 'dart:typed_data';

import 'package:audio_exif/audio_exif.dart';

void main() {
  // bytes of the file
  final Uint8List fileBytes = Uint8List.fromList(<int>[]);
  final fileExtension = 'mp3'; // can be mp3, ogg, wav

  // Can get the extension from the file name of file path
  // final fileExtension = fileName.split('.').last;
  // final fileExtension = filePath.split('.').last;

  // retrieve the metadata
  MetadataExtractor extractor =
      MetadataExtractorFactory.getExtractor(fileExtension);
  final metadata = extractor.extractMetadataFromBytes(fileBytes);

  print(metadata); // see the metadata
}
