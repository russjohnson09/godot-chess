What is this limitation?
On Android, UDPServer relies on POSIX server socket connection paradigms and OS multicast/broadcast filtering that often fail or return connection/binding errors inside Godot's Android export runtime. 
By replacing it with PacketPeerUDP and using .bind(PORT) directly on the packet peer:
1. Raw Datagram Sockets: It binds directly to a UDP datagram socket rather than attempting a connection-oriented server abstraction.
2. Reliable Broadcast/Multicast Reception: Android's networking stack handles raw broadcast packets much more reliably via PacketPeerUDP, allowing seamless local network peer discovery across your Wi-Fi router without permission or socket state rejections.



https://forum.godotengine.org/t/title-udp-works-on-desktop-but-fails-on-android-export/130822


https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html