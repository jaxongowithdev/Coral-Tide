# 🐠 Aquarium Master

**Collect • Build • Discover • Complete**

A beautiful aquarium simulation game where you catch fish, build your aquarium, and create the perfect underwater world!

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.32.0-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)

---

## 🎮 Features

- 🐠 **52 Unique Fish Species** - Collect them all!
- 🏊‍♂️ **Animated Swimming** - Fish move naturally in the aquarium
- 🎴 **Playing Cards as Food** - Use 52 SVG cards to feed your fish
- 🌿 **6 Decoration Types** - Build your dream aquarium
- 🎣 **4 Exploration Zones** - Discover fish in different habitats
- 📚 **Collection Album** - Track your progress
- 🏗️ **5 Tank Types** - Upgrade to hold more fish
- 💰 **Coin Economy** - Strategic resource management

---

## 🚀 Quick Start

```bash
# Get dependencies
fvm flutter pub get

# Run the app
cd example && fvm flutter run
```

---

## 📱 Game Overview

### Main Aquarium
- Beautiful ocean-themed interface
- Fish swimming with smooth animations
- Water waves and bubble effects
- Decorations at the bottom

### Exploration
- 4 unique zones (Coral Reef, Deep Ocean, Ice Sea, Hidden Cave)
- Catch fish with search animation
- Discover new species

### Collection
- Album of 52 species
- Organized by habitat (♥♠♦♣)
- Progress tracking

---

## 🎯 Game Loop

1. **Explore** → Go to different zones
2. **Catch Fish** → Discover new species (displayed as emoji 🐠)
3. **Watch Them Swim** → Enjoy the animations
4. **Feed Them** → Use playing card food items (SVG cards)
5. **Decorate** → Buy decorations to increase happiness
6. **Earn Coins** → Feed happy fish for rewards
7. **Unlock Tanks** → Expand your collection

---

## 🏗️ Project Structure

```
lib/
├── src/
│   ├── models/          # Data models (fish, food, tank, decoration)
│   ├── widgets/         # Reusable UI components
│   ├── screens/         # 7 main screens
│   ├── providers/       # State management (Provider)
│   └── data/            # Fish catalog (52 species)
└── aquarium_master.dart # Public API

assets/
└── cards/               # 52 SVG playing cards (used as food)
```

---

## 🎨 Tech Stack

- **Framework:** Flutter 3.32.0
- **State Management:** Provider
- **Assets:** flutter_svg (for card SVGs)
- **Platform:** iOS (iPhone, iPad)
- **Mode:** Offline-first

---

## 🌟 Key Features

- ✅ Aquarium simulation with real-time fish behavior
- ✅ 52 unique fish species to collect
- ✅ Dynamic feeding and growth system
- ✅ Strategic resource management
- ✅ Collection & progression system
- ✅ Multiple tank types and decorations

---

## 📖 Documentation

- [FINAL_SUMMARY.md](FINAL_SUMMARY.md) - Complete feature overview
- [FOOD_SYSTEM_GUIDE.md](FOOD_SYSTEM_GUIDE.md) - Food & feeding mechanics
- [ANIMATED_AQUARIUM_GUIDE.md](ANIMATED_AQUARIUM_GUIDE.md) - Swimming & decorations
- [AQUARIUM_MASTER_GUIDE.md](AQUARIUM_MASTER_GUIDE.md) - Initial transformation guide

---

## 🎯 Status

✅ **Complete & Running** on iPhone 14 Simulator

**Version:** 1.0.0
**Last Updated:** 2026-07-01

---

## 📄 License

Private project for MMO Aquarium Master.

---

**Made with ❤️ for fish lovers** 🐠🐟🐡🦈🐋
