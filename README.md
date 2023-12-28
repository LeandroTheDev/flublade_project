# Flublade Project

Flublade is a MMORPG Sandbox turn based game, you can fight enemies, create friends (real life or not), level up your character, raid dungeons, make insane builds, be the stronger player alive and of course pvp other players, you can choose a race for your character, change you hair, color, skin type.

But obviously the most things in this description is not yet implemented... but this is the essence of the game and i am trying my best to make the things works like this, one of my inspirations is the how world of warcraft works, looking in deep code you see World of Warcraft is fully working in databases, so flublade works very like this, everthing in this games is server works, the world generation is fully managed by the server, the chunks and entitys everthing can be changed in server database, the player moviment, the battles, the calculations, the only thing the client does is the renderization.

This game is made to be very easy to create your own server, with highly configurable, actually the world creation is very difficulty... especially if your focus is on making something beautiful, but i have plans to make a another software for world creation in flublade, in the future.

The graphics of the game, is not good, seriouslys i am very bad at pixel art, if you want to contribute with pixel art, please contact me ❤️, also if you want to contribute with coding also contact me ❤️.

Features:
- > Fully customizable character
- > Multiplayer
- > Fully flexible chunk renderization
- > Player moviment and collision

Future Features:
- > Procedural Dungeons
- > Quests
- > PVP Battles
- > Co-op Battles
- > Enemy Battles
- > Inventory
- > Equipments

# Packages using in this project

> System
- provider: ^6.0.5
- shared_preferences: ^2.0.17
- http: ^0.13.5
- web_socket_channel: ^2.4.0
> Engine
- flame: ^1.8.1
- flutter_joystick: ^0.0.3
- package_info_plus: ^4.2.0

# Wiki

On the [wiki](https://github.com/LeandroTheDev/flublade_project/wiki) you will find all the information about the game to know how to deal with enemies and understand the main mechanics, else if you are a developer see the [backend wiki](https://github.com/LeandroTheDev/flublade_server/wiki).

# FAQ

How to create a server?
> See the [flublade backend](https://github.com/LeandroTheDev/flublade_server) for more informations

What i need to compile?
> Do you need the [flutter](https://docs.flutter.dev/get-started/install) in your machine, in your folder open the terminal and type "flutter create flublade_project", after that extract the flublade files to the flublade_project folder, then you start [compiling](https://docs.flutter.dev/deployment/android).

I need to change something in the code for host my own server?
> No, the client just needs to change the ip address to the server addres in authetication page.

I need compile the flublade_project to create my own server?
> Depends, if you want to change something in the client like the images, or add new features to the game, so yes you need to change what you want and then compile.

I have permissions to change the code of this project or create another project with it?
> Of course, this is a open source project, just leave the credits ❤️.
