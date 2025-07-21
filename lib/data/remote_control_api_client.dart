import 'dart:convert';

import 'package:http/http.dart';
import 'package:unreal_remote_control/data/get_preset_response.dart';
import 'package:unreal_remote_control/data/get_presets_response.dart';
import 'package:unreal_remote_control/data/get_property_value_response.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';
import 'package:unreal_remote_control/util/color_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine.
class RemoteControlApiClient {
  RemoteControlApiClient() : _client = Client();

  final Client _client;

  Future<GetPresetsResponse> getPresets(
    String url,
  ) async {
    if (url.startsWith('ws://')) {
      final uri = Uri.parse(url);
      return _wsRequest(
        uri,
        '/remote/presets',
        verb: 'GET',
        andThen: _parseWsResponse(GetPresetsResponse.fromJson),
      );
    }

    final endpointUrl = Uri.parse('$url/remote/presets');
    final response = await get(endpointUrl);
    final body = utf8.decode(response.bodyBytes);
    final json = jsonDecode(body) as Map<String, dynamic>;
    return GetPresetsResponse.fromJson(json);
  }

  Future<GetPresetResponse> getPreset(
    String url,
    String presetName,
  ) async {
    if (url.startsWith('ws://')) {
      final uri = Uri.parse(url);
      return _wsRequest(
        uri,
        '/remote/preset/$presetName',
        verb: 'GET',
        andThen: _parseWsResponse(GetPresetResponse.fromJson),
      );
    }

    final endpointUrl = Uri.parse('$url/remote/preset/$presetName');
    final response = await get(endpointUrl);
    final body = utf8.decode(response.bodyBytes);
    final json = jsonDecode(body) as Map<String, dynamic>;
    return GetPresetResponse.fromJson(json);
  }

  Future<GetPropertyValueResponse> getPropertyValue(
    String url,
    String presetName,
    String propertyName,
  ) async {
    if (url.startsWith('ws://')) {
      final uri = Uri.parse(url);
      return _wsRequest<GetPropertyValueResponse>(
        uri,
        '/remote/preset/$presetName/property/$propertyName',
        verb: 'GET',
        andThen: _parseWsResponse(GetPropertyValueResponse.fromJson),
      );
    }

    final endpointUrl = Uri.parse(
      '$url/remote/preset/$presetName/property/$propertyName',
    );
    final response = await get(endpointUrl);
    final body = utf8.decode(response.bodyBytes);
    final json = jsonDecode(body) as Map<String, dynamic>;
    return GetPropertyValueResponse.fromJson(json);
  }

  Future<void> sendPropertyValue(
    String url,
    String presetName,
    String propertyName,
    PropertyValueWithMetaData propertyValue,
  ) async {
    final propertyValueEncoded = switch (propertyValue) {
      Loading() => throw Exception(
          'PropertyValueWithMetaData.Loading is not an expected '
          'PropertyValueWithMetaData to send',
        ),
      Color(:final color, :final isLinear) => isLinear
          ? {
              'R': color.redLinear,
              'G': color.greenLinear,
              'B': color.blueLinear,
              'A': color.alphaDouble,
            }
          : {
              'R': color.redInt,
              'G': color.greenInt,
              'B': color.blueInt,
              'A': color.alphaInt,
            },
      FloatOrDouble(:final value) => value,
      Dynamic(:final value) => value,
    };

    final body = {
      'PropertyValue': propertyValueEncoded,
      'GenerateTransaction': true,
    };

    if (url.startsWith('ws://')) {
      return _wsRequest<void>(
        Uri.parse(url),
        '/remote/preset/$presetName/property/$propertyName',
        verb: 'PUT',
        body: body,
        andThen: (json) {
          if (json['ResponseCode'] != 200) {
            throw Exception('Failed to apply property value: $json');
          }
        },
      );
    }

    final endpointUrl = Uri.parse(
      '$url/remote/preset/$presetName/property/$propertyName',
    );
    final req = Request('PUT', endpointUrl)
      ..body = jsonEncode(body)
      ..headers['Content-Type'] = 'application/json';

    final response = await _client.send(req);
    if (response.statusCode != 200) {
      throw Exception('Failed to apply property value: $json');
    }
  }

  Future<void> callFunction(
    String url,
    String presetName,
    String functionName,
  ) async {
    final body = {
      'Parameters': const <String, dynamic>{},
      'GenerateTransaction': true,
    };

    if (url.startsWith('ws://')) {
      return _wsRequest<void>(
        Uri.parse(url),
        '/remote/preset/$presetName/function/$functionName',
        verb: 'PUT',
        body: body,
        andThen: (json) {
          if (json['ResponseCode'] != 200) {
            throw Exception('Failed to call function');
          }
        },
      );
    }

    final endpointUrl = Uri.parse(
      '$url/remote/preset/$presetName/function/$functionName',
    );
    final req = Request('PUT', endpointUrl)
      ..body = jsonEncode(body)
      ..headers['Content-Type'] = 'application/json';

    final response = await _client.send(req);
    if (response.statusCode != 200) {
      throw Exception('Failed to call function');
    }
  }

  /// For WS based apps.
  Future<T> _wsRequest<T>(
    Uri uri,
    String endpoint, {
    required T Function(Map<String, dynamic>) andThen,
    required String verb,
    Map<String, dynamic> body = const {},
  }) async {
    final req = {
      'MessageName': 'http',
      'Parameters': {
        'Url': endpoint,
        'Verb': verb,
        'Body': body,
      },
    };

    final ws = WebSocketChannel.connect(uri);
    await ws.ready;

    ws.sink.add(jsonEncode(req));

    final responseBytes = await ws.stream.firstWhere((a) {
      return a is List<int>;
    }) as List<int>;
    final responseBody = utf8.decode(responseBytes);
    final responseJson = jsonDecode(responseBody) as Map<String, dynamic>;
    final result = andThen(responseJson);

    await ws.sink.close();

    return result;
  }

  T Function(Map<String, dynamic>) _parseWsResponse<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return (json) => fromJson(json['ResponseBody'] as Map<String, dynamic>);
  }
}
