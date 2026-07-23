/// The OS-reported connection type. Mirrors what `connectivity_plus` can
/// report without leaking its enum through the barrel. [none] always maps to
/// `ConnectivityState.offline()` — every other value maps to
/// `ConnectivityState.online(type)`.
enum ConnectionType { wifi, cellular, ethernet, bluetooth, vpn, other, none }
