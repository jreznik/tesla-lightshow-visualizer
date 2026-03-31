import sys
import os

base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
obj_path = os.path.join(base_dir, "assets/Cybertruck.obj")

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

clusters = {} # (mtl, x, y, z) -> face_count

current_mtl = None
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('usemtl '):
            current_mtl = line.split()[1]
        elif line.startswith('f ') and current_mtl:
            parts = line.split()[1:]
            v_indices = []
            for p in parts:
                try: v_indices.append(int(p.split('/')[0]) - 1)
                except: pass
            if v_indices:
                ax = sum(vertices[vi][0] for vi in v_indices) / len(v_indices)
                ay = sum(vertices[vi][1] for vi in v_indices) / len(v_indices)
                az = sum(vertices[vi][2] for vi in v_indices) / len(v_indices)
                # Round to nearest 5 units for fine clustering
                key = (current_mtl, round(ax/5)*5, round(ay/5)*5, round(az/5)*5)
                clusters[key] = clusters.get(key, 0) + 1

# Filter for small symmetrical clusters high on sides
for k, count in sorted(clusters.items()):
    mtl, x, y, z = k
    if y > 100 and abs(z) > 80 and count < 300:
        print(f"Cluster: Mtl {mtl}, X:{x:.0f}, Y:{y:.0f}, Z:{z:.0f}, Count:{count}")
