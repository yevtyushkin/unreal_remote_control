import 'dart:convert';

import 'package:http/http.dart';
import 'package:unreal_remote_control/project/client/response/get_presets_response.dart';

/// A client for interacting with Unreal Engine Remote Control (https://docs.unrealengine.com/4.26/en-US/ProductionPipelines/ScriptingAndAutomation/WebControl/).
class RemoteControlHttpClient {
  /// An Http [Client] used by this client.
  final Client _client;

  /// Returns a new instance of the [RemoteControlHttpClient] with the given
  /// [Client].
  const RemoteControlHttpClient(this._client);

  /// Fetches the available remote presets using the /remote/presets endpoint
  /// of the Remote Control API.
  Future<GetPresetsResponse> getPresets(String baseUrl) async {
    return _getAndParse(
      baseUrl,
      '/remote/presets',
      GetPresetsResponse.fromJson,
    );
  }

  /// Sends the get request to the given [baseUrl], [path] and returns the
  /// parsed response using the given [fromJson]
  Future<T> _getAndParse<T>(
    String baseUrl,
    String path,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final correctedPath = baseUrl.endsWith('/') ? path.substring(1) : path;
    final rawUrl = '$baseUrl$correctedPath';
    final url = Uri.parse(rawUrl);

    final response = await _client.get(url);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return fromJson(json);
  }
}
