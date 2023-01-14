import '../../shared/classes/classes.dart';

//1. 提示整个句子 2. 提示中文 3. 提示关键单词（中、英文） 3. 跟读模式 4.
// 对台词专用软件
// 个人英语老师的AI助教
// 背诵神器
class ConversationInfo {
  // example: don't delete
  // Map<String, Object> info_none = {
  //   "file": "BuyingTextBooks.mp3",
  //   "speakers": ["Tom", "Lily"],
  //   "conversation":
  //   [
  //     {"speaker": "Lily", "text": "Hey, you're in my English class!", "start": 1, "end": 5.5 },
  //     {"speaker": "Tom", "text": "Yes, I am.", "start": 5.2, "end": 6.7},
  //     {"speaker": "Lily", "text": "Did you buy the textbook yet?", "start": 7, "end": 9.3 },
  //     {"speaker": "Tom", "text": "No, it's really expensive.", "start": 10, "end": 12},
  //     {"speaker": "Lily", "text": "How much is it?", "start": 12, "end": 13.9 },
  //     {"speaker": "Tom", "text": "The original price is over two hundred dollars.", "start": 13.6, "end": 17.2},
  //     //correct subtitle
  //     {"speaker": "Lily", "text": "We could buy it from a former student.", "start": 17.3, "end": 20.5},
  //     {"speaker": "Tom", "text": "We could also buy the used version.", "start": 20.3, "end": 23},
  //     {"speaker": "Lily", "text": "That is a great idea!", "start": 23, "end": 25.5},
  //     {"speaker": "Tom", "text": "I will give you the website to buy used books.", "start": 25.4, "end": 29},
  //     {"speaker": "Lily", "text": "Thank you so much.", "start": 29, "end": 31 },
  //     {"speaker": "Tom", "text": "No problem at all.", "start": 31, "end": 33},
  //   ]
  // };

  int index = -1;
  List<Sentence> sentences = [];
  List<String> speakers = [];
  List<String> get Speakers => speakers;

  ConversationInfo(Conversation conversation){
    Set<String> speakers_set = Set();
    for(var sentence in conversation.sentences){
      speakers_set.add(sentence.speaker);
    }
    sentences = conversation.sentences;
    speakers = speakers_set.toList();
  }

  Sentence? next(){
    if(index >= sentences.length - 1){
      index += 1;
      return null;
    }else{
      index += 1;
      return sentences[index];
    }
  }

  Sentence? current(){
    if(index == -1 || index == sentences.length){
      return null;
    }
      return sentences[index];
  }

  int currentIndex(){
    return index;
  }

  void reset(){
    index = -1;
  }

}