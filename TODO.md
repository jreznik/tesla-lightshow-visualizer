# Project TODOs

## Urgent
- [x] **Fix Cybertruck Folding Mirrors**: Mirrors are segmented but not responding correctly to animation nodes in QML. Further coordinate analysis and pivot refinement needed. (Done: Adjusted pivots and increased rotation range to 60deg)
- [x] **Camera Framing**: Investigate rare cases where the car leaves the viewport during high-energy Show Mode transitions. May need camera frustum or dynamic zoom scaling based on model bounds. (Done: Added 1.25x zoom scaling for Cybertruck)

## Enhancement
- [ ] **Interior RGB**: Map the interior accent lights for both models.
- [ ] **Specific Model Remapping**: Implement unique remappings for Model 3 and Model Y.
- [ ] **Performance**: Investigate shader optimizations for older GPUs.
