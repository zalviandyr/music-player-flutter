import 'dart:io';

class Util {
  static Future<List<String>> filterMp3(String dirPath) async {
    List<String> pathMp3 = [];
    await for (var entity in Directory(dirPath).list()) {
      // filter just mp3 ext
      List<String> fileArray = entity.path.split('.');
      if (fileArray.last == 'mp3') {
        pathMp3.add(entity.path);
      }
    }

    return pathMp3;
  }

  static String getNameSong(String path) {
    String name;
    // get name file
    List<String> array1 = path.split('/');
    name = array1.last;

    // trim .mp3
    List<String> array2 = name.split('.');
    name = array2.getRange(0, array2.length - 1).join(' ');
    return name;
  }
}
