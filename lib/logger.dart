import 'package:logger/logger.dart';
import 'dart:developer' as developer;

const bool _debug = true;

final Logger logger = Logger(printer: Printer(), filter: Filter(), output: Output());

void info(String message) => logger.i(message);
void warning(String message) => logger.w(message);
void fatal(String message) => logger.f(message);
void error(String message) => logger.e(message);
void debug(String message) => logger.d(message);
void trace(String message) => logger.t(message);

class Printer extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return ["[${event.time.toLocal()} | ${event.level.name.toUpperCase()}]", "${event.message}", ""];
  }
}

class Filter extends LogFilter {
  final List<Level> levels = [Level.info, Level.warning, Level.error, Level.fatal];
  @override
  bool shouldLog(LogEvent event) {
    if (_debug) {
      return true;
    } else if (levels.contains(event.level)) {
      return true;
    }
    return false;
  }
}

class Output extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(developer.log);
  }
}
