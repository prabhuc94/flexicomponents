import 'package:process_run/shell.dart';
import 'dart:io';

// This process will work only with Windows
// Main process is used to kill lastInstance
class SystemUtils {
  final String appName;

  SystemUtils({required this.appName});


  Future<Iterable<ProcessResult>> _listApp() async {
    final shell = Shell();

    // Get list of running processes
    // final result = await shell.run('TASKLIST /FI "IMAGENAME eq $_APPNAME"');
    final result = await shell.run('tasklist /fo csv /nh');
    // return result.where((element) => element.exitCode == 0);
    final lines = result.single.stdout.toString().split("\n");
    List<ProcessResult> processes = [];
    for (final line in lines.reversed) {
      final fields = line.split(',');
      final imageName = fields[0].replaceAll('"', '');
      if (imageName == appName) {
        final pid = int.tryParse(fields[1].replaceAll('"', ''));
        processes.add(ProcessResult(pid ?? 0, 0, imageName, ""));
      }
    }
    return processes;
  }

  // KILL THE LAST INSTANCE WITH FINDING GIVEN [APPNAME]
  Future<void> killLastInstance() async {
    // Get list of running processes
    final processes = await _listApp();

    // If the processes list is more than one one kill last pid from the list!
    if (processes.length > 1) {
      await killAppId(processes.lastOrNull?.pid);
    }
  }

  // USING PROCESS ID CAN ABLE TO KILL THE APP
  Future<void> killAppId(int? pid) async {
    final shell = Shell();
    await shell.run('taskkill /PID "$pid" /F /T');
  }

}