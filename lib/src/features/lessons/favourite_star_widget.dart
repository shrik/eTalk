import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myartist/src/shared/providers/api_req.dart';
import '../../shared/classes/classes.dart';
import '../my/utility/shared_preference.dart';

class FavouriteStarWidget extends StatefulWidget {
  final bool isFavourite;
  final int objectId;
  const FavouriteStarWidget(
      {required this.isFavourite, required this.objectId, Key? key})
      : super(key: key);

  @override
  State<FavouriteStarWidget> createState() => _FavouriteStarWidgetState();
}

class _FavouriteStarWidgetState extends State<FavouriteStarWidget> {
  late bool isFavourite;

  Future<bool> checkIsFavourite(int object_id) async {
    if (await UserPreferences().userExists()) {
      User user = await UserPreferences().getUser();
      bool res =
          await ApiReq.checkIsFavourite(user: user, lesson_id: object_id);
      return res;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isFavourite = this.widget.isFavourite;
    Future(() async {
      bool res = await checkIsFavourite(this.widget.objectId);
      setState(() {
        isFavourite = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.isFavourite) {
      return InkWell(
        child: Icon(Icons.star),
        onTap: () async {
          User user = await UserPreferences().getUser();
          await ApiReq.removeFavourite(
              user: user, lesson_id: this.widget.objectId);
          bool res = await checkIsFavourite(this.widget.objectId);
          setState(() {
            this.isFavourite = res;
          });
        },
      );
    } else {
      return InkWell(
        child: Icon(Icons.star_border),
        onTap: () async {
          if (await UserPreferences().userExists()) {
            User user = await UserPreferences().getUser();
            await ApiReq.addToFavourite(
                user: user, lesson_id: this.widget.objectId);
          } else {
            GoRouter.of(context).go("/login");
          }

          bool res = await checkIsFavourite(this.widget.objectId);
          setState(() {
            this.isFavourite = res;
          });
        },
      );
    }
  }
}
