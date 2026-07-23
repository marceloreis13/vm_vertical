import 'dart:async';

/// Small hand-rolled debounce so the module doesn't take an `rxdart`
/// dependency just for `VmConnectivityConfig.debounce`: only re-emits an
/// event once [duration] has passed with no further event.
extension DebouncedStream<T> on Stream<T> {
  Stream<T> debounced(Duration duration) {
    Timer? timer;
    late final StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        final subscription = listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () => controller.add(event));
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            unawaited(controller.close());
          },
        );
        controller.onCancel = () {
          timer?.cancel();
          return subscription.cancel();
        };
      },
    );
    return controller.stream;
  }
}
