import sys

qml_path = "tesla-lightshow-visualizer/qml/ModelSCarInternal.qml"

with open(qml_path, 'r') as f:
    lines = f.readlines()

in_body = False
slots = []
for line in lines:
    if 'id: body' in line:
        in_body = True
    elif in_body and ']' in line:
        in_body = False
    elif in_body and '_material' in line:
        mtl = line.strip().replace(',', '')
        slots.append(mtl)

# Find all BodySG4 indices
for i, mtl in enumerate(slots):
    if mtl == 'bodySG4_material':
        print(f"Slot {i}: {mtl}")
