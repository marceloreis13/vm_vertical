import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Fake [HttpClientAdapter] recording every [RequestOptions] it receives and
/// returning responses from a caller-supplied queue, so interceptor tests can
/// assert on headers/order without hitting the network.
class RecordingHttpClientAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  /// Responses returned in order, one per call to [fetch]. When exhausted,
  /// the last entry is reused.
  List<ResponseBody Function(RequestOptions options)> responses = [
    (options) => ResponseBody.fromString('{}', 200),
  ];

  int _callCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final index = _callCount < responses.length
        ? _callCount
        : responses.length - 1;
    _callCount++;
    return responses[index](options);
  }
}
