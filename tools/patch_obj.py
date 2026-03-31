import sys
import re
import os

# Relative paths for portable build
base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
obj_path = os.path.join(base_dir, "assets/ModelS_patched.obj")
mtl_path = os.path.join(base_dir, "assets/ModelS_patched.mtl")
src_path = os.path.join(base_dir, "source_assets/ModelS.obj")

if not os.path.exists(src_path):
    print(f"Error: Source asset not found at {src_path}")
    print("Please download the Tesla Model S xLights assets and place ModelS.obj in the source_assets folder.")
    sys.exit(1)

# 1. Restore original
with open(src_path, 'r') as f:
    obj_content = f.read()
with open(obj_path, 'w') as f:
    f.write(obj_content)

# 2. Read vertices
vertices = []
with open(obj_path, 'r') as f:
    for line in f:
        if line.startswith('v '):
            parts = line.split()
            vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))

# 3. Patch OBJ by splitting faces
with open(obj_path, 'r') as f:
    lines = f.readlines()

def get_segment_name(face_line, mtl):
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
    
    side = "R" if az > 0 else "L"
    a_az = abs(az)

    if mtl == 'BodySG2' and 250 < ax < 275 and 150 < ay < 170 and a_az > 190:
        return f"Side_Repeater_{side}"

    if mtl == 'LightsSG':
        if ax > 300: # FRONT
            if ay < 80: return f"Front_Fog_{side}"
            if ay < 120: return f"Front_Turn_{side}"
            if a_az > 160: return f"Front_Outer_{side}"
            if a_az > 100: return f"Front_Inner_{side}"
            return f"Front_Sig_{side}"
        else: # REAR
            if ay > 180: return f"Rear_Tail_{side}"
            if ay > 140: return f"Rear_Brake_{side}"
            if abs(az) < 50: return "Rear_Reverse"
            return f"Rear_Other_{side}"
    return None

face_buckets = {}
current_mtl = None
for line in lines:
    if line.startswith('usemtl '):
        current_mtl = line.split()[1]
    elif line.startswith('f '):
        seg = get_segment_name(line, current_mtl)
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
        seg = get_segment_name(line, current_mtl)
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

# 4. Patch MTL
# Create a fresh patched MTL from the source (if it exists)
src_mtl = src_path.replace(".obj", ".mtl")
if os.path.exists(src_mtl):
    with open(src_mtl, 'r') as f:
        mtl_content = f.read()
    with open(mtl_path, 'w') as f:
        f.write(mtl_content)
        for seg in face_buckets.keys():
            f.write(f"\nnewmtl {seg}_Mtl\nKd 0.0 0.0 0.0\nKa 0.0 0.0 0.0\nKs 0.5 0.5 0.5\nNs 20\n")

print(f"Patched OBJ created at {obj_path}")
