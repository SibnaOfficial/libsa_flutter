# sibna_flutter

Flutter/Dart SDK for the **Sibna Protocol** — real Signal Protocol E2EE backed by a Rust core.

Provides: ChaCha20-Poly1305 encryption, X3DH key agreement, Double Ratchet sessions, and identity safety numbers.

---

## Before You Start — What You Need

This SDK calls native Rust code via `dart:ffi`. It **will not work** without the compiled native library.

| Platform | Required file | Where to place it |
|---|---|---|
| Android | `libsibna_core.so` | `android/src/main/jniLibs/<ABI>/` |
| iOS | `libsibna_core.a` | linked via Xcode (static) |
| macOS | `libsibna_core.dylib` | `macos/Frameworks/` |
| Windows | `sibna_core.dll` | `windows/` |
| Linux | `libsibna_core.so` | `linux/` |
| Web | ❌ Not supported | Use the JS/WASM SDK |

**Build the library from `sibna-protc/core`:**
```bash
# Desktop (Linux/macOS/Windows)
cargo build --release --features ffi

# Android (requires NDK + cargo-ndk)
cargo ndk -t arm64-v8a -t armeabi-v7a -t x86_64 build --release --features ffi

# iOS
cargo build --release --features ffi --target aarch64-apple-ios
```

---

## Installation

```yaml
dependencies:
  sibna_flutter: ^1.0.0
```

---

## Setup

Call `SibnaFlutter.initialize()` once at app startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SibnaFlutter.initialize();
  runApp(MyApp());
}
```

---

## Usage

### Standalone encryption (no session needed)

```dart
import 'package:sibna_flutter/sibna_flutter.dart';

// Generate a 32-byte random key
final key = SibnaCrypto.generateKey();

// Encrypt (ChaCha20-Poly1305)
final ciphertext = SibnaCrypto.encrypt(
  key,
  Uint8List.fromList(utf8.encode('Hello!')),
  associatedData: Uint8List.fromList(utf8.encode('context')), // optional
);

// Decrypt
final plaintext = SibnaCrypto.decrypt(
  key,
  ciphertext,
  associatedData: Uint8List.fromList(utf8.encode('context')),
);
```

### Full E2EE session (X3DH + Double Ratchet)

```dart
// ── Device A (Alice) ────────────────────────────────────────
final alice = await SibnaContext.create(password: 'AlicePass1!');
final aliceIdentity = alice.generateIdentity();
final aliceBundle   = alice.generatePrekeyBundle();
// Upload aliceBundle to your prekey server

// ── Device B (Bob) ──────────────────────────────────────────
final bob = await SibnaContext.create(password: 'BobPass1!');
final bobIdentity = bob.generateIdentity();
final bobBundle   = bob.generatePrekeyBundle();
// Upload bobBundle to your prekey server

// ── Handshake (each side fetches the other's bundle from server) ──
alice.performHandshake(
  peerId:     bobIdentity.ed25519Public,   // Bob's identity key = session ID
  peerBundle: bobBundle,                   // fetched from prekey server
  initiator:  true,
);
bob.performHandshake(
  peerId:     aliceIdentity.ed25519Public,
  peerBundle: aliceBundle,
  initiator:  false,
);

// ── Send messages ────────────────────────────────────────────
// Alice → Bob
final ct = alice.sessionEncrypt(
  bobIdentity.ed25519Public,
  Uint8List.fromList(utf8.encode('Hello Bob!')),
);

// Bob decrypts
final pt = bob.sessionDecrypt(
  aliceIdentity.ed25519Public,
  ct,
);
print(utf8.decode(pt)); // Hello Bob!

// ── Identity verification (safety number) ───────────────────
final sn = SibnaSafetyNumber.calculate(
  aliceIdentity.x25519Public,
  bobIdentity.x25519Public,
);
print(sn.formatted); // show to both users for out-of-band verification

// ── Cleanup ──────────────────────────────────────────────────
alice.dispose();
bob.dispose();
```

---

## API Reference

### `SibnaFlutter`
| Method | Description |
|--------|-------------|
| `initialize({libraryPath?})` | Load the native library. Call once in `main()`. |
| `isInitialized` | Whether the library is loaded. |
| `nativeVersion` | Protocol version string from the Rust core. |

### `SibnaCrypto`
| Method | Description |
|--------|-------------|
| `generateKey()` | Random 32-byte key. |
| `randomBytes(n)` | Random n bytes. |
| `encrypt(key, plaintext, {associatedData})` | ChaCha20-Poly1305 encrypt. |
| `decrypt(key, ciphertext, {associatedData})` | Decrypt + verify tag. |

### `SibnaContext`
| Method | Description |
|--------|-------------|
| `create({password?})` | Create a context with an encrypted keystore. |
| `generateIdentity()` | Generate Ed25519 + X25519 keypair. Returns `SibnaIdentity`. |
| `generatePrekeyBundle()` | Generate a PreKey Bundle for the server. |
| `performHandshake(peerId, peerBundle, initiator)` | X3DH handshake → creates Double Ratchet session. |
| `sessionEncrypt(peerId, plaintext, {associatedData})` | Encrypt over a session. |
| `sessionDecrypt(peerId, ciphertext, {associatedData})` | Decrypt over a session. |
| `dispose()` | Free native memory and zero keys. |

### `SibnaSafetyNumber`
| Method | Description |
|--------|-------------|
| `calculate(ourKey, theirKey)` | Compute a verifiable safety number from two X25519 keys. |
| `formatted` | Human-readable 80-digit string to show the user. |
| `matches(other)` | Constant-time comparison. |

---

## Error Handling

All errors throw `SibnaError` with a `SibnaErrorCode`:

```dart
try {
  final pt = SibnaCrypto.decrypt(key, tamperedCiphertext);
} on SibnaError catch (e) {
  if (e.code == SibnaErrorCode.authenticationFailed) {
    // Message was tampered with
  }
}
```

| Code | Meaning |
|------|---------|
| `authenticationFailed` | Wrong key or tampered ciphertext |
| `sessionNotFound` | `performHandshake()` not called for this peer |
| `keyNotFound` | `generateIdentity()` not called before `generatePrekeyBundle()` |
| `invalidState` | Context or session has been disposed |
| `notInitialized` | `SibnaFlutter.initialize()` not called |

---

## Platform support

| Platform | Supported |
|----------|-----------|
| Android | ✅ |
| iOS | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |
| Web | ❌ (use JS/WASM SDK) |

---

## License

Apache-2.0
