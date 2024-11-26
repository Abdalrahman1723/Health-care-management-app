import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
@injectable
class HiveManager {
  void inti() async {
    await Hive.initFlutter();
    _registerAdapter();
    await _openBox();
  }

  void _registerAdapter() {}

  Future<void> _openBox() async {}

  void cacheData<T>(
      {required String boxKey, List<T>? dataList, T? dataItem}) async {
    var box = Hive.box<T>(boxKey);

    if (dataList != null) {
      box.addAll(dataList);
    } else if (dataItem != null) {
      box.add(dataItem);
    }
  }

  List<T> retrieveData<T>(String boxKey) {
    var box = Hive.box<T>(boxKey);

    return box.values.toList();
  }
}
