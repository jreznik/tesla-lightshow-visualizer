import sys

obj_path = "/home/jreznik/Test/tesla_xlights_show_folder/Model_S/ModelS.obj"

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
            for p in parts:
                try:
                    v_idx = int(p.split('/')[0]) - 1
                    mtl_faces[current_mtl].append(vertices[v_idx])
                except: pass

for mtl, vs in mtl_faces.items():
    if not vs: continue
    avg_x = sum(v[0] for v in vs) / len(vs)
    avg_y = sum(v[1] for v in vs) / len(vs)
    avg_z = sum(v[2] for v in vs) / len(vs)
    print(f"Mtl {mtl}: AvgX={avg_x:.1f}, AvgY={avg_y:.1f}, AvgZ={avg_z:.1f}")
