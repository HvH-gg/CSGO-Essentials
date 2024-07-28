![Copyright ev0lve Digital](https://img.shields.io/badge/Copyright-ev0lve%20Digital-blue) ![GitHub License](https://img.shields.io/github/license/HvH-gg/CSGO-Essentials) ![Issues](https://img.shields.io/github/issues/HvH-gg/CSGO-Essentials) ![Stars](https://img.shields.io/github/stars/HvH-gg/CSGO-Essentials)

# [HvH.gg](https://hvh.gg) CS:GO Essentials (1.0.0)

Our CS:GO Essentials plugin is the only plugin you need to run a successful HvH server. It includes basic features like **reset score** and **rage quit** as well as optional restrictions for **untrusted angles**, **body lean/roll**, **extended angles**, **fake duck** and **ax**.

# Features
- Reset score `!rs`
- Rage quit `!rq`
- Restrict untrusted angles
- Restrict body lean/roll
- Restrict extended angles
- Restrict fake duck
- Restrict AX

# Requirements
- [Metamod:Source](https://www.sourcemm.net/downloads.php/?branch=stable)
- [Sourcemod](https://www.sourcemod.net/downloads.php?branch=stable)

# Install
1. Download the latest release from the [releases](https://github.com/HvH-gg/CSGO-Essentials/releases) page
2. Extract the `addons` folder in your servers `csgo` directory
![extract](https://du.hurenso.hn/r/63EGKE.png)
3. Type `sm plugins load hvhgg_csgo_essentials` in your server console

# Basic Setup
- `hvh_reset_score 0/1 (default: 1)` - If enabled, players will be able to reset their score with `!rs`
- `hvh_rage_quit 0/1 (default: 1)` - If enabled, players will be able to rage quit with `!rq`
# Restriction Setup
- `hvh_restrict_untrusted_angles 0/1 (default: 1)` - If enabled, players will be restricted from using untrusted angles.
- `hvh_restrict_body_lean 0/1 (default: 1)` - If enabled, players will be restricted from using body lean/roll.
- `hvh_restrict_extended_angles 0/1 (default: 1)` - If enabled, players will be restricted from using extended angles.
- `hvh_restrict_fake_duck 0/1 (default: 0)` - If enabled, players will be restricted from using fake duck.
- `hvh_restrict_ax 0/1 (default: 1)` - If enabled, players will be restricted from using AX.

# Credits
- [HvH.gg](https://hvh.gg)
- [Metamod:Source](https://www.sourcemm.net/)
- [Sourcemod](https://www.sourcemod.net/)
- Others as mentioned in the source code
