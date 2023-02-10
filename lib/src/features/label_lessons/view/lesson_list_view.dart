import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quiver/iterables.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/api_req.dart';

class LessonListView extends StatefulWidget {
  final int labelId;
  LessonListView({required this.labelId, super.key});

  @override
  _LessonListViewState createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  static const _pageSize = 4;

  final PagingController<int, List<Lesson>> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    {
      const row_size = 3;
      List<Lesson> newItems;
      if(this.widget.labelId == 0){
        // All Lessons
        newItems = await ApiReq.getAllLessons(pageKey, _pageSize * row_size);
      }else{
        // Label Lessons
        newItems = await ApiReq.getLabelLessons(this.widget.labelId.toString(),
            pageKey, _pageSize * row_size);
      }
      List<List<Lesson>> groupedItems = partition(newItems, row_size).toList();
      final isLastPage = groupedItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(groupedItems);
      } else {
        final int nextPageKey = pageKey + 1;
        _pagingController.appendPage(groupedItems, nextPageKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      PagedListView<int, List<Lesson>>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<List<Lesson>>(
          itemBuilder: (context, lessons_item, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lessons_item
                  .map((e) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: buildLessonCard(context, e)))
                  .toList()),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

final double cardWidth = 100;
Widget buildLessonCard(BuildContext context, Lesson lesson) {
  return InkWell(child: SizedBox(
    width: cardWidth,
    // height: 250,
    child: Card(
      child: Column(
        children: [
          Image.network(lesson.coverUrl(), width: cardWidth),
          SizedBox(
            width: cardWidth,
            child: Text(
              lesson.name,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: Text(
              "初级",
              maxLines: 1,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),

      // media: AssetImage(artist.image.image);
    ),
  ),
    onTap: (){
      GoRouter.of(context).push("/lessons/" + lesson.id.toString());
    },);
}