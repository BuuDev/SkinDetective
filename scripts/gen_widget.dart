import 'dart:async';
import 'dart:io';

void main() {
  dirContents(Directory('${Directory.current.path}/lib/widgets')).then((value) {
    List<String> widgets = [];
    List<String> importFiles = [];

    for (var widget in value) {
      try {
        File file = File('${widget.path}/${widget.name}.dart');

        var component = RegExp(
          r'\/\/\/\s*Example:\s*([a-zA-Z0-9_]+\([a-zA-Z0-9,\n\s:\/]*\))',
          multiLine: true,
        ).allMatches(file.readAsStringSync());

        String? codeString = component.last.group(component.last.groupCount);

        if (codeString != null) {
          codeString = codeString.replaceAll(RegExp(r'\n|\s|\/'), '');

          importFiles.add(
            "import 'package:${Directory.current.name}/widgets/${widget.name}/${widget.name}.dart';",
          );
          widgets.add(codeString);
        }
      } catch (error) {
        // ignore: avoid_print
        print('$error');
      }
    }

    if (widgets.isNotEmpty) {
      String generated = _widgetGen;

      generated = generated.replaceFirst('{import}', importFiles.join('\n'));
      generated = generated.replaceFirst('{widgets}', widgets.join(',\n'));

      File fileGenerated = File(
        '${Directory.current.path}/lib/screens/widgets_custom.dart',
      );

      fileGenerated.writeAsString(generated);
    }
  });
}

extension FileExtension on FileSystemEntity {
  String get name {
    return path.split("/").last;
  }
}

extension DirectorExtension on Directory {
  String get name {
    return path.split("/").last;
  }
}

Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file),
      // should also register onError
      onDone: () => completer.complete(files));
  return completer.future;
}

const _widgetGen = """
import 'package:flutter/material.dart';
{import}

class WidgetsCustom extends StatelessWidget {
  const WidgetsCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets custom'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          {widgets}
        ],
      ),
    );
  }
}
""";
