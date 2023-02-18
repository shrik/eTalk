import 'package:myartist/src/shared/classes/classes.dart';
import '../../lib/settings.dart';

class Lesson{
  static String host="http://" + IMAGE_HOST;
  Lesson({
    required this.id,
    required this.cover_path,
    required this.name,
    required this.name_zh
  });

  final int id;
  final String name;
  final String name_zh;
  final String cover_path;
  final String description = "包含两接课程： 1.包含两接课程含两接课程含两接课程含两接课程含两接课程含两接课程含两接课程";
  List<Conversation> conversations = [];

  static Lesson fromMap(Map item){
    Lesson lesson = Lesson(id: item["id"], cover_path: item["cover_path"],
        name: item["name"], name_zh: item["name_zh"]);
    if(item.containsKey("conversations")){
      (item["conversations"] as List).forEach((e) =>
          lesson.conversations.add(Conversation.fromMap(e)));
    }
    return lesson;
  }

  String coverUrl(){
    return host + "/upload" + cover_path;
  }
}