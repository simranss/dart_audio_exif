import 'package:audio_exif/utils/audio_file_mp3.dart';

import 'metadata_extractor.dart';
import 'package:audio_exif/utils/audio_file_ogg.dart';
import 'package:audio_exif/utils/audio_file_wav.dart';

class MetadataExtractorFactory {
  static MetadataExtractor getExtractor(String extension) {
    switch (extension) {
      case 'mp3':
        return ID3v2Extractor();
      case 'ogg':
        return VorbisExtractor();
      case 'wav':
        return WAVExtractor();
      default:
        throw UnsupportedError("File type not supported: $extension");
    }
  }
}
