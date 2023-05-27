import 'dart:convert';

const _get = 'GET';
const _put = 'PUT';
const _http = 'http';

final String getPresets = _httpMsg(name: _http, url: '/remote/presets', verb: _get);

String getPreset(String name) => _httpMsg(name: _http, url: '/remote/preset/$name', verb: _get);

String getProperty(String presetName, String propertyName) => _httpMsg(
      name: _http,
      url: '/remote/preset/$presetName/property/$propertyName',
      verb: _get,
    );

String setProperty(String presetName, String propertyName, dynamic value) => _httpMsg(
      name: _http,
      verb: _put,
      url: '/remote/preset/$presetName/property/$propertyName',
      body: {
        'PropertyValue': value,
        'GenerateTransaction': true,
      },
    );

String callFunction(String presetName, String functionName, Map<String, dynamic> parameters) => _httpMsg(
      name: _http,
      verb: _put,
      url: '/remote/preset/$presetName/function/$functionName',
      body: {
        'Parameters': parameters,
        'GenerateTransaction': true,
      },
    );

String subscribeToPreset(String name) {
  return jsonEncode(
    {
      'MessageName': 'preset.register',
      'Parameters': {
        'PresetName': name,
      }
    },
  );
}

String unsubscribeFromPreset(String name) {
  return jsonEncode(
    {
      'MessageName': 'preset.unregister',
      'Parameters': {
        'PresetName': name,
      }
    },
  );
}

String _httpMsg({
  required String name,
  required String url,
  required String verb,
  Map<String, dynamic>? body,
  String? id,
}) {
  return jsonEncode(
    {
      'MessageName': name,
      'Parameters': {
        'Url': url,
        'Verb': verb,
        if (body != null) 'Body': body,
        if (id != null) 'Id': id,
      },
    },
  );
}
