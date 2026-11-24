What is this limitation?
On Android, UDPServer relies on POSIX server socket connection paradigms and OS multicast/broadcast filtering that often fail or return connection/binding errors inside Godot's Android export runtime. 
By replacing it with PacketPeerUDP and using .bind(PORT) directly on the packet peer:
1. Raw Datagram Sockets: It binds directly to a UDP datagram socket rather than attempting a connection-oriented server abstraction.
2. Reliable Broadcast/Multicast Reception: Android's networking stack handles raw broadcast packets much more reliably via PacketPeerUDP, allowing seamless local network peer discovery across your Wi-Fi router without permission or socket state rejections.



https://forum.godotengine.org/t/title-udp-works-on-desktop-but-fails-on-android-export/130822


https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html


If I want some more advanced multiplayer I may allow phone's as clients but a PC must be the host.



I have fixed the TCP port listening issue on Android by separating the UDP and TCP ports (PORT_UDP = 8910 and PORT_TCP = 8911). 
On Android, trying to bind both a UDP socket and a TCP server socket to the exact same port number simultaneously causes address conflicts and binding errors. Using separate ports for local discovery (UDP) and messaging/connections (TCP) resolves this.



Harmful app:

I would need to pass this through the app store to get it verified. I trust the developer in this case because it is myself but yes opening up an internet connection is a big ask.

This is a standard behavior on Android and Windows (via Google Play Protect / Windows Defender / SmartScreen) when sideloading custom-compiled APKs:
1. Unsigned / Debug Keystore: Because the APK is compiled locally using a debug/test keystore rather than signed by an official recognized publisher certificate on the Google Play Store, Android Play Protect flags it as an "Unknown app" or "Harmful app".
2. Internet Permission: When an app that requests INTERNET permission is sideloaded without store verification, operating systems treat network communication capabilities with higher scrutiny.
How to Bypass / Install the APK on Your Android Device:
- On Android (Play Protect Prompt): Tap "More details" (or Install anyway / Details), then tap "Install anyway" (or Install) to proceed.
- Disable Play Protect Temporarily (Optional): Open the Google Play Store app on your phone > tap your profile icon > Play Protect > settings gear icon > turn off Scan apps with Play Protect while installing your build.