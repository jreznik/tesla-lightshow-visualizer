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

## Installation & Build

### 1. Requirements
- Qt 6.8+ (with Quick 3D, Multimedia, and Shader Tools modules)
- Python 3 (for asset patching)

### 2. Setup Assets
This repository does not include the raw Tesla 3D models due to size and licensing.
1. Download the **Tesla Model S or Cybertruck xLights model** (e.g., from the [Official Tesla Repository](https://github.com/teslamotors/light-show)).
2. Place your `.obj` and `.mtl` files into the `assets/` folder (e.g., `assets/ModelS.obj` or `assets/Cybertruck.obj`).
3. Run the patching tool to segment moving parts and lights:
   ```bash
   python3 tools/patch_obj.py  # For Model S
   python3 tools/patch_ct.py   # For Cybertruck
   ```
4. Convert the patched OBJ to native Qt meshes using `balsam`:
   ```bash
   # For Model S
   /path/to/qt6/bin/balsam -o qml/cars/ModelS/assets assets/ModelS_patched.obj
   
   # For Cybertruck
   /path/to/qt6/bin/balsam -o qml/cars/Cybertruck/assets assets/Cybertruck_patched.obj
   ```
   *Note: Move the produced `.mesh` files from the `assets/meshes` subfolder into the respective `meshes/` folder for each car.*

### 3. Build Instructions

#### **Linux (Native)**
```bash
qmake6
make -j$(nproc)
```

#### **Linux (Flatpak)**
```bash
flatpak-builder --user --install --force-clean build-dir org.jreznik.TeslaLightshowVisualizer.yaml
flatpak run org.jreznik.TeslaLightshowVisualizer
```

#### **macOS**
1. Install Qt 6 via Homebrew: `brew install qt6`
2. Open terminal in the project root:
   ```bash
   qmake6
   make
   ```
3. Run the generated app bundle: `open tesla-lightshow-visualizer.app`

#### **Windows**
1. Install **Qt 6.8+** using the Qt Online Installer (include **MSVC** or **MinGW** compiler).
2. Open the **"Qt 6.x (MSVC/MinGW) Command Prompt"** from the Start Menu.
3. Run:
   ```cmd
   qmake
   nmake   :: If using MSVC
   :: OR
   mingw32-make  :: If using MinGW
   ```
4. Run `tesla-lightshow-visualizer.exe`.

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
