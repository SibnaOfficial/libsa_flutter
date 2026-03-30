import 'package:flutter_test/flutter_test.dart';
import 'package:sibna/sibna.dart';

void main() {
  test('Sibna connection setup test', () async {
    final sdk = Sibna();
    expect(sdk.isConnected, false);

    // Test the lightning fast connect method for the WOW interface
    await sdk.connect('peer_123');
    expect(sdk.isConnected, true);

    // Disconnect resources gracefully
    sdk.disconnect();
    expect(sdk.isConnected, false);
  });
}
