# Tesla Lightshow 3D Visualizer

A high-fidelity 3D visualizer for custom Tesla Lightshows (`.fseq` files). Built with Qt 6 and Quick 3D.

## Features
- **Accurate Model Segmentation**: 18 independent light segments for the Tesla Model S.
- **Night Show Visuals**: Real-time light casting, volumetric rays, atmospheric fog, and cinematic glow.
- **Interactive Controls**: Dynamic camera rotation/zoom, playback seeker, and Day/Night toggles.
- **Ramping Support**: Faithful simulation of the 500ms/1000ms/2000ms Tesla light ramps.
- **Dynamic Loading**: Select any `.fseq` file and the app auto-matches the audio.

## Installation & Build

### 1. Requirements
- Qt 6.10+ (with Quick 3D and Multimedia modules)
- ImageMagick (for icon generation)
- Python 3 (for asset patching)

### 2. Setup Assets
This repository does not include the raw Tesla 3D models due to size and licensing. You must download them separately:
1. Download the **Tesla Model S xLights model** from the community (e.g., from the official [Tesla xLights repository](https://github.com/teslamotors/light-show)).
2. Create a folder named `source_assets` in the project root.
3. Place `ModelS.obj` and `ModelS.mtl` into `source_assets/`.
4. Run the patching tool to segment the lights:
   ```bash
   python3 tools/patch_obj.py
   ```
5. Convert the patched OBJ to native Qt meshes:
   ```bash
   /usr/lib64/qt6/bin/balsam -o assets source_assets/ModelS.obj
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
- **3D Assets**: Based on the xLights community models for Tesla Model S. Special thanks to the contributors of the [Tesla Light Show](https://github.com/teslamotors/light-show) repository.
- **License**: MIT License. See `LICENSE` file for details.
- **Disclaimer**: This is an unofficial community tool and is not affiliated with Tesla, Inc.
