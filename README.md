# Tesla Lightshow 3D Visualizer

A high-fidelity 3D visualizer for custom Tesla Lightshows (`.fseq` files). Built with Qt 6 and Quick 3D.

> **Warning**
> This project is currently in an **experimental** stage. Not all lights on all models are mapped or implemented correctly. Some behaviors may differ from actual vehicle hardware.

## Features
- **Accurate Model Segmentation**: 
  - **Tesla Model S**: 18 independent light segments.
  - **Tesla Cybertruck**: Segmented front light bar (Main Beams + Signature), offroad bar, rear bar, and reverse/turn signals.
- **Custom Shaders**: Features a procedural **Brushed Stainless Steel shader** for the Cybertruck with Fresnel reflections and anisotropic highlights.
- **Night Show Visuals**: Real-time light casting, volumetric rays, atmospheric fog, and cinematic glow.
- **Interactive Controls**: Dynamic camera rotation/zoom, car selection (Model S vs. Cybertruck), playback seeker, and Day/Night toggles.
- **Native Ramping**: Implements the exact 500ms, 1000ms, and 2000ms light ramping profiles as defined in the official Tesla Light Show specification.
- **Dynamic Loading**: Select any `.fseq` file and the app auto-matches the corresponding audio.

## Installation & Build

### 1. Requirements
- Qt 6.10+ (with Quick 3D and Multimedia modules)
- Python 3 (for asset patching)

### 2. Setup Assets
This repository does not include the raw Tesla 3D models due to size and licensing. You must download them separately:
1. Download the **Tesla Model S or Cybertruck xLights model** from the community (e.g., from the official [Tesla xLights repository](https://github.com/teslamotors/light-show)).
2. Create a folder named `source_assets` in the project root.
3. Place your `.obj` and `.mtl` files into `source_assets/` (e.g., `source_assets/ModelS.obj` or `source_assets/Cybertruck/Cybertruck.obj`).
4. Run the appropriate patching tool to segment the lights:
   ```bash
   # For Model S
   python3 tools/patch_obj.py
   
   # For Cybertruck
   python3 tools/patch_ct.py
   ```
5. Convert the patched OBJ to native Qt meshes using `balsam`:
   ```bash
   # For Model S
   /usr/lib64/qt6/bin/balsam -o qml/meshes/ModelS assets/ModelS_patched.obj
   
   # For Cybertruck
   /usr/lib64/qt6/bin/balsam -o qml/meshes/Cybertruck assets/Cybertruck_patched.obj
   ```

### 3. Build
```bash
qmake6
make -j$(nproc)
```

## Usage
- Run the executable: `./tesla-lightshow-visualizer`
- Click **Load Show** to select an `.fseq` file.
- Use **[D]** to toggle Debug Mode (view channel IDs and use manual test keys).
- Use **[F11]** or the UI button for Fullscreen.

## Credits & License
- **Visualizer**: Developed as an AI-powered engineering tool.
- **3D Assets**: Based on the xLights community models for Tesla. Special thanks to the contributors of the [Tesla Light Show](https://github.com/teslamotors/light-show) repository.
- **License**: MIT License. See `LICENSE` file for details.
- **Disclaimer**: This is an unofficial community tool and is not affiliated with Tesla, Inc.
