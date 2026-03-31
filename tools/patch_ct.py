import sys
import re
import os

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
obj_path = os.path.join(base_dir, "assets/Cybertruck_patched.obj")
mtl_path = os.path.join(base_dir, "assets/Cybertruck_patched.mtl")
src_path = os.path.join(base_dir, "source_assets/Cybertruck/Cybertruck.obj")

if not os.path.exists(src_path):
    print(f"Error: Source asset not found at {src_path}")
    sys.exit(1)

# 1. Read vertices
vertices = []
with open(src_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

# 2. Patch OBJ by splitting faces
with open(src_path, 'r') as f:
    lines = f.readlines()

def get_ct_segment(face_line, mtl):
    sum_x = sum_y = sum_z = 0
    count = 0
    parts = face_line.split()[1:]
    for p in parts:
        try:
            v_idx = int(p.split('/')[0]) - 1
            sum_x += vertices[v_idx][0]
            sum_y += vertices[v_idx][1]
            sum_z += vertices[v_idx][2]
            count += 1
        except: continue
    if count == 0: return None
    ax, ay, az = sum_x/count, sum_y/count, sum_z/count
    
    # blinn5SG: Lights_AO.png (Front / Offroad)
    # blinn6SG: Lights_AO_Red.png (Rear)
    
    if mtl == 'blinn5SG':
        if ay > 120: return "CT_Offroad_Bar"
        if az > 80 or az < -80: return "CT_Main_Beams" # Outer edges are headlights
        return "CT_Front_Bar"
    elif mtl == 'blinn6SG':
        return "CT_Rear_Bar"
    
    return None

face_buckets = {}
current_mtl = None
for line in lines:
    if line.startswith('usemtl '):
        current_mtl = line.split()[1]
    elif line.startswith('f '):
        seg = get_ct_segment(line, current_mtl)
        if seg:
            if seg not in face_buckets: face_buckets[seg] = []
            face_buckets[seg].append(line)

final_lines = []
current_mtl = None
for line in lines:
    if line.startswith('usemtl '):
        current_mtl = line.split()[1]
        final_lines.append(line)
    elif line.startswith('f '):
        seg = get_ct_segment(line, current_mtl)
        if seg: continue 
        final_lines.append(line)
    else:
        final_lines.append(line)

for seg, faces in face_buckets.items():
    final_lines.append(f"g {seg}\n")
    final_lines.append(f"usemtl {seg}_Mtl\n")
    final_lines.extend(faces)

with open(obj_path, 'w') as f:
    f.writelines(final_lines)

# 3. Patch MTL
src_mtl = src_path.replace(".obj", ".mtl")
if os.path.exists(src_mtl):
    with open(src_mtl, 'r') as f:
        mtl_content = f.read()
    with open(mtl_path, 'w') as f:
        f.write(mtl_content)
        for seg in face_buckets.keys():
            # Use original light texture properties
            f.write(f"\nnewmtl {seg}_Mtl\nKd 1.0 1.0 1.0\nKa 0.0 0.0 0.0\nKs 0.5 0.5 0.5\nNs 20\n")

print(f"Patched Cybertruck OBJ created at {obj_path}")
