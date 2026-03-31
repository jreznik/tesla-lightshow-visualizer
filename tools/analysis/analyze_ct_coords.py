import sys

obj_path = "tesla-lightshow-visualizer/source_assets/Cybertruck/Cybertruck.obj"

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

current_mtl = None
mtl_faces = {}

with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('usemtl '):
            current_mtl = line.split()[1]
            if current_mtl not in mtl_faces: mtl_faces[current_mtl] = []
        elif line.startswith('f ') and current_mtl:
            parts = line.split()[1:]
            v_indices = []
            for p in parts:
                try: v_idx = int(p.split('/')[0]) - 1; v = vertices[v_idx]; mtl_faces[current_mtl].append(v)
                except: pass

for mtl, vs in mtl_faces.items():
    if not vs: continue
    min_x = min(v[0] for v in vs); max_x = max(v[0] for v in vs)
    min_y = min(v[1] for v in vs); max_y = max(v[1] for v in vs)
    min_z = min(v[2] for v in vs); max_z = max(v[2] for v in vs)
    print(f"Mtl {mtl}: X[{min_x:.1f}, {max_x:.1f}], Y[{min_y:.1f}, {max_y:.1f}], Z[{min_z:.1f}, {max_z:.1f}]")
