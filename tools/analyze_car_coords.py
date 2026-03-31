import sys

obj_path = "tesla_xlights_show_folder/Model_S/ModelS.obj"

vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

current_group = None
group_verts = {}

with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('g '):
            current_group = line.split()[1]
            if current_group not in group_verts: group_verts[current_group] = []
        elif line.startswith('f ') and current_group:
            parts = line.split()[1:]
            for p in parts:
                try:
                    v_idx = int(p.split('/')[0]) - 1
                    group_verts[current_group].append(vertices[v_idx])
                except: pass

for g, vs in group_verts.items():
    if not vs: continue
    avg_x = sum(v[0] for v in vs) / len(vs)
    avg_y = sum(v[1] for v in vs) / len(vs)
    avg_z = sum(v[2] for v in vs) / len(vs)
    if "Rear_Other" in g or "Front" in g:
        print(f"Group {g}: AvgX={avg_x:.1f}, AvgY={avg_y:.1f}, AvgZ={avg_z:.1f}")
