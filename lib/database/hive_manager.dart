import 'package:hive/hive.dart';

class SharedPreferencesManager {
  factory SharedPreferencesManager() {return _instance;}
  static final SharedPreferencesManager _instance= SharedPreferencesManager._internal();
  SharedPreferencesManager._internal();


  late Box _box;

  Future<void> init() async {

    _box = await Hive.openBox('myBox');
  }
  getString(String key){
    return _box.get(key);
  }
  read(String key){
    var jsonString=getString(key);
    return jsonString;
  }
  Future add(value,String key)async{
   await _box.put(key, value);
  }
  List<Object?> getAll(){
    return _box.values.toList();
  }
}