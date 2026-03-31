import sys

obj_path = "/home/jreznik/Test/tesla_xlights_show_folder/Model_S/ModelS.obj"

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

current_mtl = None
faces = []
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
                sum_x = sum(vertices[vi][0] for vi in v_indices)
                avg_x = sum_x / len(v_indices)
                if avg_x > 300 and current_mtl == 'LightsSG':
                    sum_y = sum(vertices[vi][1] for vi in v_indices)
                    sum_z = sum(vertices[vi][2] for vi in v_indices)
                    avg_y = sum_y / len(v_indices)
                    avg_z = sum_z / len(v_indices)
                    if avg_y < 150:
                        faces.append((avg_x, avg_y, avg_z))

# Group by Y and Z
for f in faces:
    print(f"X: {f[0]:.1f}, Y: {f[1]:.1f}, Z: {f[2]:.1f}")
