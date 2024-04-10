import 'package:facefinder/image_processing/repository/cpp_image_processing_repository.dart';
import 'package:facefinder/image_processing/repository/image_processing_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageProcessingRepositoryProvider = Provider<ImageProcessingRepository>(
  (ref) => CppImageProcessingRepository(),
);
