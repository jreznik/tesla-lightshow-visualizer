import sys

obj_path = "/home/jreznik/Test/tesla_xlights_show_folder/Model_S/ModelS.obj"

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

current_mtl = None
fender_faces = []

with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('usemtl '):
            current_mtl = line.split()[1]
        elif line.startswith('f '):
            parts = line.split()[1:]
            v_indices = []
            for p in parts:
                try: v_indices.append(int(p.split('/')[0]) - 1)
                except: pass
            if v_indices:
                avg_x = sum(vertices[vi][0] for vi in v_indices) / len(v_indices)
                avg_y = sum(vertices[vi][1] for vi in v_indices) / len(v_indices)
                avg_z = sum(vertices[vi][2] for vi in v_indices) / len(v_indices)
                if 240 < avg_x < 280 and 140 < avg_y < 180 and abs(avg_z) > 180:
                    fender_faces.append((current_mtl, avg_x, avg_y, avg_z))

# Group by material
mtl_counts = {}
for f in fender_faces:
    m = f[0]
    mtl_counts[m] = mtl_counts.get(m, 0) + 1

for m, count in mtl_counts.items():
    print(f"Material {m}: {count} faces in repeater area")
