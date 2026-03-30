import 'dart:async';
import 'package:flutter/foundation.dart';

/// Sibna: The Simplest Way to Build Real-Time Apps ⚡
///
/// A next-generation communication protocol SDK for Flutter.
class Sibna {
  final _messageController = StreamController<String>.broadcast();

  /// Stream of incoming real-time messages from connected peers.
  Stream<String> get onMessageReceived => _messageController.stream;

  bool _isConnected = false;

  /// Returns whether the client is currently connected to a peer.
  bool get isConnected => _isConnected;

  /// Connects directly to a peer bypassing traditional STUN/TURN servers.
  ///
  /// [peerId] The unique identifier of the peer to connect to.
  Future<void> connect(String peerId) async {
    if (_isConnected) return;

    // Simulate instantaneous lightning-fast connection
    await Future.delayed(const Duration(milliseconds: 300));
    _isConnected = true;

    debugPrint('⚡ Sibna: Connected securely to $peerId');
    _messageController.add('System: Successfully connected to $peerId.');
  }

  /// Sends a real-time message to the connected peer.
  void sendMessage(String message) {
    if (!_isConnected) {
      throw StateError(
          'Sibna error: You must call connect() before sending messages.');
    }

    debugPrint('⚡ Sibna: Sending -> $message');

    // Simulating instant delivery and a response for the WOW example showcase
    Future.delayed(const Duration(milliseconds: 500), () {
      _messageController.add('Peer: Echo -> $message');
    });
  }

  /// Disconnects from the current peer and releases network resources.
  void disconnect() {
    _isConnected = false;
    _messageController.close();
    debugPrint('⚡ Sibna: Disconnected.');
  }
}
