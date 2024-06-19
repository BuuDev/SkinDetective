import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/screens/app/face_analysis/face_analysis.dart';
import 'package:skin_detective/screens/app/face_stream/screens/face_result_screen.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/widgets/home/home.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({Key? key}) : super(key: key);

  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> get pages {
    return const [
      HomeAnalyzePage(),
      FaceResultScreen(),
      FaceAnalysis(),
      HomeAnalyzePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<AcneAnalyzeVM, int>(
      selector: (_, state) => state.status.index,
      builder: (_, index, __) {
        return pages[index];
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
