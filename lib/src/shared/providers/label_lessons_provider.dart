import '../classes/classes.dart';
import 'api_req.dart';

class LabelLessonsProvider{

  static Future<Map> homeLabels() async {
    Map resp = await ApiReq.get("/api/label_lessons_home");
    Map res = Map();
    List<Label> labels = (resp["result"]["labels"] as List).map((e) => Label.fromMap(e as Map)).toList();
    List<Lesson> all_lessons = (resp["result"]["all_lessons"] as List).map((e) => Lesson.fromMap(e as Map)).toList();
    res["labels"] = labels;
    res["all_lessons"] = all_lessons;
    return res;
  }
}