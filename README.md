# Tesla Lightshow 3D Visualizer

A high-fidelity 3D visualizer for custom Tesla Lightshows (`.fseq` files). Built with Qt 6 and Quick 3D.

> **Warning**
> This project is currently in an **experimental** stage. Not all lights on all models are mapped or implemented correctly. Some behaviors may differ from actual vehicle hardware.

## Features
- **Accurate Model Segmentation**: 
  - **Tesla Model S**: 18 independent light segments and animated liftgate/mirrors.
  - **Tesla Cybertruck**: Segmented light bar (Main Beams + Signature), offroad bar, rear bar, and animated folding mirrors.
- **Cinematic "Show Mode"**: 
  - **AI Director**: Automatically cycles through 9+ cinematic "Hero Shots" (Front Low, Rear High, Drone Flyby, etc.).
  - **Energy-Aware**: Camera cuts and movement speed dynamically react to the intensity of the lightshow data.
  - **Randomized Starts**: Randomly picks starting car and lighting (Day/Night) for every show.
- **Animated "Theater Mode" UI**: Panels smoothly collapse during playback for a distraction-free cinematic experience.
- **Custom Shaders**: Procedural **Brushed Stainless Steel shader** for the Cybertruck with Fresnel reflections and anisotropic highlights.
- **Native Ramping**: Implements exact 500ms, 1000ms, and 2000ms light ramping profiles as defined in the official Tesla spec.
- **Smart Features**: 
  - **Autoload**: Optionally remembers and loads the last show automatically on startup.
  - **Countdown**: Animated 5-second "Showtime" countdown before playback starts.
  - **Persistence**: Remembers your car choice, rotation, zoom, and Show Mode settings.
- **Visual Quality**: Enhanced with **SSAA (Super Sample Anti-Aliasing) VeryHigh** for smooth metallic edges.

## 3D Models & Meshes

This project includes high-fidelity 3D models of the Tesla Model S and Tesla Cybertruck. 

### Origin and Attribution
The models used in this visualizer are based on the official **Tesla Light Show** assets provided by **Tesla, Inc.** These models were originally designed for use with xLights to help creators design light shows.

We would like to express our gratitude to:
- **Tesla, Inc.** for their openness in providing these assets to the community.
- The **xLights community contributors** who have refined these models over time for the [official Tesla Light Show repository](https://github.com/teslamotors/light-show).

### Pre-built Meshes
To ensure a seamless "out-of-the-box" experience and consistent visual quality across all platforms (Linux, Windows, macOS), we have included pre-built, optimized `.mesh` files directly in the repository.

- **Model S**: Segmented into 18+ independent light groups and animated components (Liftgate, Mirrors).
- **Cybertruck**: Features a detailed light bar segmentation (Signature vs Main Beams), offroad bar, and procedural stainless steel shading.

For detailed information on how these meshes were processed, patched, and converted, please refer to the [**Meshes Directory README**](meshes/README.md).

## Build Instructions

### 1. Requirements
- Qt 6.8+ (LTS) or 6.9+ (with Quick 3D, Multimedia, and Shader Tools modules)
- CMake 3.16+
- Ninja (recommended)

### 2. Build

#### **Linux (Native)**
```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

#### **Linux (Flatpak)**
```bash
flatpak-builder --user --install --force-clean build-dir org.jreznik.TeslaLightshowVisualizer.yaml
flatpak run org.jreznik.TeslaLightshowVisualizer
```

#### **macOS**
1. Install Qt 6 and CMake via Homebrew: `brew install qt6 cmake ninja`
2. Open terminal in the project root:
   ```bash
   cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
   cmake --build build
   ```
3. Run the generated app bundle: `open build/tesla-lightshow-visualizer.app`

#### **Windows (Native)**
1. Install **Qt 6.8+ or 6.9+** using the Qt Online Installer (include **MSVC** compiler).
2. Open the **"x64 Native Tools Command Prompt for VS 2022"** from the Start Menu.
3. Run:
   ```cmd
   cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
   cmake --build build
   ```
4. Run `build\tesla-lightshow-visualizer.exe`.

#### **Windows (Cross-compile from Fedora)**
If you are on Fedora Linux, you can easily cross-compile for Windows:
1. Install MinGW Qt6 packages:
   ```bash
   sudo dnf install mingw64-gcc-c++ mingw64-qt6-qtbase mingw64-qt6-qtdeclarative \
                    mingw64-qt6-qtquick3d mingw64-qt6-qtmultimedia mingw64-qt6-qtshadertools
   ```
2. Build using the Fedora MinGW wrapper:
   ```bash
   mkdir build-win64 && cd build-win64
   mingw64-qmake-qt6 ..
   make -j$(nproc)
   ```
3. The resulting `.exe` will be in the build directory.

## Usage
- Click **Load Show** to select an `.fseq` file.
- Use **[D]** to toggle Debug Mode (view channel names, IDs and use manual test keys).
- Manual Test Keys: **[L]** Liftgate, **[,]** Left Mirror, **[.]** Right Mirror.
- Use **[F11]** or the UI button for Fullscreen.

## Credits & License
- **Visualizer**: Developed as an AI-powered engineering tool.
- **3D Assets**: Based on the xLights community models. Special thanks to the [Tesla Light Show](https://github.com/teslamotors/light-show) contributors.
- **License**: MIT License. See `LICENSE` file for details.
- **Disclaimer**: This is an unofficial community tool and is not affiliated with Tesla, Inc.
