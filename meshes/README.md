# Tesla Lightshow 3D Meshes

This directory contains pre-built 3D mesh files (`.mesh`) for the Tesla Lightshow Visualizer.

## Origin & Attribution

These models are based on the official Tesla xLights models provided by **Tesla, Inc.** in their [Tesla Light Show GitHub repository](https://github.com/teslamotors/light-show).

Special thanks to:
- **Tesla, Inc.** for providing the original models.
- The **xLights community** for their continuous work on these models.

## How these meshes were built

These `.mesh` files were generated from the original `.obj` and `.mtl` files using the following process:

1. **Extraction**: The raw `ModelS.obj` and `Cybertruck.obj` files were extracted from the [official ZIP archive](https://github.com/teslamotors/light-show/blob/master/xlights/tesla_xlights_show_folder.zip).
2. **Patching**: 
   - `tools/patch_obj.py` was used to segment the Model S into 18+ independent light and moving parts.
   - `tools/patch_ct.py` was used to segment the Cybertruck lights and mirrors.
3. **Conversion**: The patched `.obj` files were converted to Qt Quick 3D native `.mesh` files using the `balsam` tool (part of the Qt SDK).

## Why are these included?

To simplify the build process and ensure consistency across all platforms, we now include the pre-built meshes directly in the repository. This removes the need for manual patching and `balsam` conversion during the build.
