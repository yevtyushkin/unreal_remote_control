const _info = 'INFO';
const _warn = 'WARN';
const _error = 'ERROR';

void info(dynamic msg) => _log(_info, msg);

void warn(dynamic msg) => _log(_warn, msg);

void error(dynamic msg) => _log(_error, msg);

void _log(String lvl, dynamic msg) => print('${DateTime.now()} [$lvl] $msg');
