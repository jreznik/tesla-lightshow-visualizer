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
                if avg_x > 300:
                    sum_y = sum(vertices[vi][1] for vi in v_indices)
                    sum_z = sum(vertices[vi][2] for vi in v_indices)
                    avg_y = sum_y / len(v_indices)
                    avg_z = sum_z / len(v_indices)
                    faces.append({ 'mtl': current_mtl, 'pos': (avg_x, avg_y, avg_z) })

# Simple clustering by rounding positions
clusters = {}
for f in faces:
    # Round to nearest 10cm for rough grouping
    key = (f['mtl'], round(f['pos'][0], -1), round(f['pos'][1], -1), round(f['pos'][2], -1))
    if key not in clusters: clusters[key] = 0
    clusters[key] += 1

sorted_keys = sorted(clusters.keys(), key=lambda x: (x[0], x[3]))
for k in sorted_keys:
    print(f"Mtl: {k[0]}, X: {k[1]}, Y: {k[2]}, Z: {k[3]}, Count: {clusters[k]} faces")
