Chess app that can connect two devices on a shared wifi connection.


https://forum.godotengine.org/t/project-files-that-can-safely-be-put-in-gitignore/127748

yes ignore .godot don't ignore .import.


An IP address starting with 172.19.80.1 (such as vEthernet (WSL)) is a virtual internal network adapter created by WSL (Windows Subsystem for Linux), Hyper-V, or a VPN. 
Because it is a virtual host-only adapter, Windows firewall and routing rules prevent physical devices (like your Android phone or other PCs on your actual Wi-Fi router) from routing broadcast or UDP packets through it.
Why it wasn't working & How it's fixed:
1. Virtual Adapter Filtering: The app was previously picking up 172.19.x.x as your primary local address or filtering it out because physical router clients cannot reach WSL virtual bridges.
2. Code Updates: I have updated wifi_scanner.gd and network_manager.gd to prioritize physical network adapters (avoiding WSL/VPN virtual subnets like 172.19.) so that your PC correctly binds and broadcasts using your physical Wi-Fi or Ethernet local IP address (192.168.x.x or 10.x.x.x), allowing your phone and other clients to successfully discover and connect to you.