# No Items Level Requirements mod for Cyberpunk 2077
A mod to Cyberpunk 2077 that removes items level requirements.

## Description

Thanks to this mod you can equip items that the game would not allow you to equip due to too low player level.

## Dependencies

### Cyberpunk 2077

The mod was tested on Cyberpunk 2077 v1.3.

### Cyber Engine Tweaks

This mod depends on [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107?tab=description), v1.16.1.

## Installation

1. Ensure that you have [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107?tab=description) installed.
2. Copy `src/init.lua` into `<Cyberpunk2077-installation-directory>/bin/x64/plugins/cyber_engine_tweaks/mods/no_item_level_req/init.lua`, create missing directories.

## How it works

When the game is loaded the mod iterates over inventory items and removes `Level` modifier on them.

The mod also registers for an event about adding item to inventory and removes the level requirements from them.

## Mod development

To support code completion, type resolving and contextual suggestions for Cyber Engine Tweaks symbols in Visual Studio Code use [Cyber Engine Tweaks Lua lib](https://wiki.redmodding.org/cyber-engine-tweaks/vs-code).