import 'dart:io';

const regexArg = r'^--.+=.+$';
const regexVersionBuild = r'ext.versionBuild\s*=\s*[0-9]+';

void main(List<String> args) {
  Map<String, dynamic> keyExecArgs = {};
  for (var arg in args) {
    ///Kiểm tra arg hợp lệ
    if (RegExp(regexArg).hasMatch(arg)) {
      var data = arg.split('=');
      keyExecArgs[data[0].replaceAll('-', '')] = data[1];
    }
  }

  increaseVersionBuild();
  execBuildAppBundle();
}

void increaseVersionBuild() {
  File bundleFile = File('${Directory.current.path}/android/app/build.gradle');
  String dataBundleFile = bundleFile.readAsStringSync();

  String? firstMatch =
      RegExp(regexVersionBuild).firstMatch(dataBundleFile)?.group(0);

  if (firstMatch != null) {
    var _dataSplit = firstMatch.replaceAll(' ', '').split('=');

    _dataSplit[1] = (int.parse(_dataSplit[1]) + 1).toString();

    ///Replace bundle file
    bundleFile.writeAsStringSync(
        dataBundleFile.replaceFirst(firstMatch, _dataSplit.join(' = ')));
  }
}

void execBuildAppBundle() {
  stdout.writeln('Đang build android app bundle...');
  Process.run(
    'cmd',
    ['-c', 'flutter build appbundle'],
    runInShell: true,
  ).then((value) {
    stdout.writeln(value.stdout);
  }).catchError((error) {
    stdout.writeln(error);
  });
}
