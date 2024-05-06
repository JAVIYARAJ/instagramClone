
import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class LocalImageHelper {
  static Future<List<File>> getLocalImages() async {
    final media = await PhotoManager.getAssetPathList(
        hasAll: true, type: RequestType.image);
    List<File> allImages = [];
    int currentPage = 0;
    for (var i = 0; i < media.length; i++) {
      final files =
          await media[i].getAssetListPaged(page: currentPage, size: 10);
      if (files.isEmpty) break;

      for (int j = 0; j < files.length; j++) {
        final image = await files[j].fileWithSubtype;
        if (image != null) {
          allImages.add(image);
        }
      }

      currentPage++;
    }
    return allImages;
  }
}
