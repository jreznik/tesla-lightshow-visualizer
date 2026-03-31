import sys

obj_path = "/home/jreznik/Test/tesla_xlights_show_folder/Model_S/ModelS.obj"

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

current_mtl = None
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
                # Tighten the box around the known repeater location (257, 158, 198)
                if 250 < avg_x < 275 and 150 < avg_y < 170 and abs(avg_z) > 190:
                    print(f"Face: Mtl={current_mtl}, X={avg_x:.1f}, Y={avg_y:.1f}, Z={avg_z:.1f}")
