# Boxes For The Big Man 🎅

Get Santa's deliveries ready for the big night with another Sokoban!

A 3D puzzle game made as a submission for [Micro Jam 52: Winter](https://itch.io/jam/micro-jam-052) with the theme "constantly overworked".

## 🎮 Game Overview

Help Santa prepare for Christmas by organizing present deliveries in this 3D Sokoban puzzle game. Push crates of presents to their delivery locations while navigating through various obstacles and interactive floor tiles that add complexity to the classic Sokoban formula.

### Goal
Fill each delivery tile (white plate with red arrow) with a crate of presents (block with red bow tie).

### How to Play
- **Movement**: Use WASD keys to move your character
- **Pushing**: Walk into crate blocks to push them in the direction you're moving
- **Strategy**: Push crates one tile at a time until they reach their delivery destinations

## 🧩 Game Mechanics

### Tile Types
- **Generic Obstacles** (trees, barrels, desks): Block movement from all directions
- **Floater Obstacles**: Block the player but allow crates to be pushed both under and through them
  - Stacked blocks function as floaters, allowing the bottom block to be pushed out from under others
- **Conveyor Tiles**: Push blocks one tile in the arrow direction (only affect blocks)
  - Player has strength to push blocks against opposing conveyor belts
- **Ice Tiles**: Push one tile in the direction of movement (affects both blocks and player)
  - ⚠️ Caution: Blocks dropped from height will break through ice tiles and sink (ice is only one block deep)
- **Lift Tiles**: Propel blocks up and forward in the arrow direction, useful for accessing raised conveyor tiles

## 🛠️ Development

### Built With
- **Game Engine**: [Godot Engine 4.6](https://godotengine.org/)
- **3D Modeling**: Blender
- **Audio**: FL Studio
- **Code Editor**: VS Code

### Project Structure
```
├── assets/          # Game assets (audio, models, images)
├── scenes/          # Game scenes and UI
├── scripts/         # Game logic and state management
├── autoloads/       # Global singletons and controllers
├── resources/       # Themes and resources
└── addons/          # Third-party plugins (Maaack's Game Template)
```

### Key Features
- 3D grid-based discrete movement with smooth position interpolation
- Multiple interactive tile types for complex puzzle mechanics
- Game state management system
- Integrated game template with menus, credits, and loading screens

## 🎯 Installation & Setup

### Playing the Game
1. Download the latest release from the releases page
2. Extract the files
3. Run the executable

### Development Setup
1. **Prerequisites**: Download [Godot Engine 4.6+](https://godotengine.org/download)
2. **Clone**: `git clone [repository-url]`
3. **Open**: Launch Godot and import the `project.godot` file
4. **Run**: Press F5 or click the Play button in Godot

### Web Export
A web version is available in the `webexport/` directory. Host the files on a web server to play in browser.

## 👥 Credits

### Squirrel Team
- **Ciph3rzer0** ([itch.io profile](https://itch.io/profile/ciph3rzer0)) - Programming and game logic
- **FRKatona** - 3D art and visual design

### Third-Party Assets
- **[Maaack's Game Template](https://github.com/Maaack/Godot-Game-Template)** - UI framework and project structure
- **Godot Engine Logo** - Andrea Calabró ([CC BY 4.0](https://github.com/godotengine/godot/blob/master/LOGO_LICENSE.txt))

## 📄 License

See [ATTRIBUTION.md](ATTRIBUTION.md) for detailed attribution and licensing information.

---

*Made with ❄️ for Micro Jam 52: Winter*