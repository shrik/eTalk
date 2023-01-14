import 'package:myartist/src/shared/classes/classes.dart';

class Sentence{
  final String speaker;
  final String text;
  final double start;
  final double end;
  String _translation="";
  set translation(String s){
    _translation = s;
  }
  String get translation => _translation;

  Sentence({
    required this.speaker,
    required this.text,
    required this.start,
    required this.end,
  });
}

double toDouble(Object inp){
  double res = 0.0;
  if(inp.runtimeType == int){
    res = (inp as int).toDouble();
  }else{
    res = (inp as double);
  }
  return res;
}

class Conversation{
  Conversation({
    required this.id,
    required this.audio_path,
    required this.title,
    required this.description,
    required List<dynamic> sentences,
  }){
    for(var sentence in sentences){
      Sentence sentenceObj = Sentence(speaker: sentence["speaker"], 
          text: sentence["text"], 
          start: toDouble(sentence["start"]), 
          end: toDouble(sentence["end"]));
      sentenceObj.translation = sentence["translation"];
      this.sentences.add(sentenceObj);
    }
  }

  final String id;
  final String title;
  final String description;
  final String audio_path;
  final List<Sentence> sentences = [];
  String local_audio_path = "";

  static fromMap(Map item){
    print(item);
    if(item.containsKey("sentences")){
      return Conversation(id: item["id"].toString(), audio_path: item["audio_file"],
          title: item["title"], description: "Not implemented", sentences:item["sentences"]);
    }else{
      return Conversation(id: item["id"].toString(), audio_path: item["audio_file"],
          title: item["title"], description: "Not implemented", sentences:[]);
    }
  }

  // filepath that is stored on mobile phone
  void setLocalAudioPath(String filePath){
    local_audio_path = filePath;
  }
}