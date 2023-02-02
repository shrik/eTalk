import './classes.dart';
import '../providers/providers.dart';

class Label {
  Label({
    required this.id,
    required this.name,
    required this.priority,
    required this.is_activate,
  });

  final int id;
  final String name;
  final int priority;
  final bool is_activate;
  List<Lesson> _lessons = [];
  List<Lesson> get lessons => _lessons;

  static Label fromMap(Map item){
    if(item.containsKey("lessons")){
      Label label = Label(id: item["id"], name: item["name"], priority: item["priority"], is_activate: item["is_activate"]);
      label._lessons = (item["lessons"] as List).map((e) => Lesson.fromMap(e)).toList();
      return label;
    }else{
      return Label(id: item["id"], name: item["name"], priority: item["priority"], is_activate: item["is_activate"]);
    }
  }
}
