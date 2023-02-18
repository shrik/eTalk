

String getUserAvatarUrl(String userRoleName){
  String defaultAvatarUrl = "assets/images/artists/woman.jpeg";
  final Map<String, String> userIconMapping = {
    "A": "assets/images/artists/woman.jpeg",
    "B": "assets/images/artists/joe.jpg",
    "Lily": "assets/images/artists/woman.jpeg",
    "Tom": "assets/images/artists/joe.jpg"
  };
  if(userIconMapping.containsKey(userRoleName)){
    return userIconMapping[userRoleName]!;
  }else{
    return defaultAvatarUrl;
  }
}