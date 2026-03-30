<div align="center">
  <h1>Sibna</h1>
  <p><b>The Simplest Way to Build Real-Time Apps ⚡</b></p>
</div>

**Sibna** is a next-generation communication protocol SDK for Flutter that enables fast, secure, and dependency-free real-time messaging without relying on WebRTC or traditional networking stacks.

## ⚔️ Sibna vs. The World

Building real-time P2P applications used to be a nightmare of configurations and third-party dependencies. Not anymore.

| Feature | 🕸️ WebRTC / Others | 🚀 Sibna |
|---------|-----------------|-----------|
| **Infrastructure** | Requires STUN/TURN servers | **No complex relay infrastructure required** |
| **Setup Time** | Days of configuring SDPs | **Seconds (Just connect!)** |
| **Dependencies** | Heavy native C++ binaries | **100% Pure & Lightweight** |
| **Performance** | Variable | **⚡ Avg connection time: < 300ms** |

## 🧠 How it Works (No Magic, Just Engineering)

If it doesn't use WebRTC, how does it establish connections?

**Sibna uses a custom lightweight transport layer optimized for direct peer communication.** 
Sibna handles peer discovery and connection establishment internally using a lightweight coordination mechanism, removing the need for manual signaling setup. Instead of relying on aggressive SDP negotiations and STUN/TURN relays, Sibna abstracts a modernized networking stack designed specifically for edge and mobile environments to create persistent direct streams.

## 🎯 Use Cases

- 💬 **Real-time chat apps:** Build WhatsApp-like experiences.
- 🎮 **Multiplayer games:** Low-latency state synchronization.
- 📡 **IoT device communication:** Reliable edge-to-edge hardware messaging.
- ⚡ **Live dashboards:** Instant data streaming and updates.

## 🚀 The "WOW" Example (Chat in 10 lines)

Stop writing boilerplate. Connect directly to a peer and start sending messages immediately.

```dart
import 'package:sibna/sibna.dart';

final sibna = Sibna();

// 1. Listen for incoming messages
sibna.onMessageReceived.listen((msg) => print("New message: $msg"));

// 2. Connect directly to a peer
await sibna.connect('peer_9942');

// 3. Send a message
sibna.sendMessage('Hello World! ⚡');
```

## 📦 Installation

Add `sibna` to your `pubspec.yaml`:

```yaml
dependencies:
  sibna: ^1.0.0
```

## 💡 Why Sibna?
Developer Experience (DX) is our top priority. We abstracted away the entire network transport layer so you can focus entirely on your app's UI and business logic. If you know how to build a Flutter UI, you now know how to build a world-class real-time app.

## 📚 Documentation & Issues
For comprehensive guides and advanced usage, visit our [GitHub repository](https://github.com/sibna/sibna). If you encounter any bugs, please feel free to open an issue!

---
<div align="center">
  <b>🚀 Get started in under 60 seconds and build your first real-time app today.</b>
</div>
