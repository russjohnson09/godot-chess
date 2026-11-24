Chess app that can connect two devices on a shared wifi connection.


https://forum.godotengine.org/t/project-files-that-can-safely-be-put-in-gitignore/127748

yes ignore .godot don't ignore .import.


An IP address starting with 172.19.80.1 (such as vEthernet (WSL)) is a virtual internal network adapter created by WSL (Windows Subsystem for Linux), Hyper-V, or a VPN. 
Because it is a virtual host-only adapter, Windows firewall and routing rules prevent physical devices (like your Android phone or other PCs on your actual Wi-Fi router) from routing broadcast or UDP packets through it.
Why it wasn't working & How it's fixed:
1. Virtual Adapter Filtering: The app was previously picking up 172.19.x.x as your primary local address or filtering it out because physical router clients cannot reach WSL virtual bridges.
2. Code Updates: I have updated wifi_scanner.gd and network_manager.gd to prioritize physical network adapters (avoiding WSL/VPN virtual subnets like 172.19.) so that your PC correctly binds and broadcasts using your physical Wi-Fi or Ethernet local IP address (192.168.x.x or 10.x.x.x), allowing your phone and other clients to successfully discover and connect to you.


It looks like a similar issue with 169.

local ips["fe80:0:0:0:a0f5:7bc4:4f44:8c8e", "172.19.80.1", "0:0:0:0:0:0:0:1", "127.0.0.1", "fe80:0:0:0:c2d3:b300:bb17:9ab5", "169.254.119.110", "fe80:0:0:0:813b:5a44:6fc1:1f81", "192.168.1.12", "fe80:0:0:0:16bd:8a0e:8e69:9417", "169.254.134.218", "fe80:0:0:0:52cd:90ac:602c:bed8", "169.254.123.121", "fe80:0:0:0:93cf:b162:90fc:82e9", "192.168.59.1", "fe80:0:0:0:7c49:3e62:b85d:1f86", "192.168.56.1", "fe80:0:0:0:3e0a:d412:106c:c086", "192.168.1.11", "2620:9b:0:0:0:0:1928:4f8e", "fe80:0:0:0:484e:40e:2bcb:5df3"]
