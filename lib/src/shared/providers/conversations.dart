import '../classes/classes.dart';
import 'api_req.dart';

class ConversationProvider{

  static Future<Conversation> getConversation(String conversationId) async {
    Map resp = await ApiReq.get("/api/conversation/" + conversationId.toString());
    Conversation conversation = Conversation.fromMap(resp["result"]);
    return conversation;
  }

}