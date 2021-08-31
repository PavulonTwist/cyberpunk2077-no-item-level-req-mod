# No Items Level Requirements mod for Cyberpunk 2077
A mod to Cyberpunk 2077 that removes items level requirements.
It can be configured to add attribute requirements instead.

## Description

Thanks to this mod you can equip items that the game would not allow you to equip due to too low player level.
The mod can be configured so that it adds attribute requirements for weapons when it removes level requirements. Attribute requirements are allowing to equip items, but may affect negatively their stats if the required attribute level is not met.

### Configuration

By default the mod is just removing level requirement. You can choose to replace level requirement with attribute requirement by editing `config.json` file in `bin\x64\plugins\cyber_engine_tweaks\mods\no_items_level_req` and changing the `"useAttributeRequirements"` value from `false` to `true`.

When using attribute requirements is on then weapons that had level requirement will get either Strength or Reflexes attribute requirement, depending on the type of the weapon. The mapping can be found in `itemTypesBasedOnStrength` and `itemTypesBasedOnReflexes` tables in `init.lua` file.

The value of an attribute requirement depends on level requirement. Formula to translate level value to attribute value can be found in `mapLevelValueToAttributeValue` function in `init.lua`.

## Dependencies

### Cyberpunk 2077

The mod was tested on Cyberpunk 2077 v1.3.

### Cyber Engine Tweaks

This mod depends on [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107?tab=description), v1.16.1.

## Installation

1. Ensure that you have [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107?tab=description) installed.
2. Copy `bin` directory into Cyberpunk 2077 installation directory.

## How it works

When the game is loaded the mod iterates over inventory items and removes `Level` modifier on them.

The mod also registers for an event about adding item to inventory and removes the level requirements from them.

## Mod development

To support code completion, type resolving and contextual suggestions for Cyber Engine Tweaks symbols in Visual Studio Code use [Cyber Engine Tweaks Lua lib](https://wiki.redmodding.org/cyber-engine-tweaks/vs-code).

To develop the mod and test it in the game it's best to make a directory hardlink from `<Cyberpunk-2077-installation-directory>\bin\x64\plugins\cyber_engine_tweaks\mods\no_items_level_req` to `<git-repository-directory\bin\x64\plugins\cyber_engine_tweaks\mods`. Hard and soft links in the inversed direction is causing that the game does not start.