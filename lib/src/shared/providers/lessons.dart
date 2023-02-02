import '../classes/classes.dart';
import 'api_req.dart';

class LessonProvider {
  static Future<List<Lesson>> getEasyLearningLessons() async {
    Map resp = await ApiReq.get("/api/easy_learning");
    List<Lesson> lessons = [];
    for(Map item in (resp["result"].cast<Map>()) ){
      Lesson lesson = Lesson.fromMap(item);
      lessons.add(lesson);
    }
    return lessons;
  }

  static Future<List<Lesson>> getMyFavouriteLessons({required User user}) async {
    List lessonItems = await ApiReq.getList("/api/my_lessons", token: user.token);
    List<Lesson> lessons = [];
    for(Map item in lessonItems ){
      Lesson lesson = Lesson.fromMap(item);
      lessons.add(lesson);
    }
    return lessons;
  }

  static Future<Lesson> getLesson(String lessonId) async {
    Map resp = await ApiReq.get("/api/lesson/" + lessonId.toString());
    Lesson lesson = Lesson.fromMap(resp["result"]);
    return lesson;
  }
}