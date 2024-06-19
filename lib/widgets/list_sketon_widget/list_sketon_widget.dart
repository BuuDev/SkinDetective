import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListSketonWidget extends StatelessWidget {
  // late PostState state;
  final Widget child;
  // late bool? isLoading;
  // PostSketon(
  //     {Key? key, required this.state, required this.child, this.isLoading})
  //     : super(key: key);

  const ListSketonWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (state is PostStateInit) {
    //   if (isLoading ?? false) {
    //     return Container(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: const Center(
    //         child: SizedBox(
    //           child: CircularProgressIndicator(
    //             strokeWidth: 1,
    //           ),
    //           width: 10,
    //           height: 10,
    //         ),
    //       ),
    //     );
    //   }
    // }

    // if (state is PostStateSuccess) {
    //   var currentState = state as PostStateSuccess;
    //   // ignore: unnecessary_null_comparison
    //   if (currentState.posts.isEmpty) {
    //     return const Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: Center(
    //         child: Text(
    //           'Không có bài viết...',
    //         ),
    //       ),
    //     );
    //   }

    //   return child;
    // }

    return child;

    // return const Center(
    //   child: SizedBox(
    //     child: CircularProgressIndicator(
    //       strokeWidth: 1,
    //     ),
    //     width: 10,
    //     height: 10,
    //   ),
    // );
  }
}
