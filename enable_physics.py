#!/usr/bin/env python3
import os
import glob

# Hardcoded directory path - change this to your actual path
DIR_PATH = "./PlatformerAssetPack/Assets/gltf"

def enable_physics_for_import_file(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Extract the model name from the source_file path
    source_start = content.find('source_file="')
    if source_start == -1:
        return
    
    source_start += len('source_file="')
    source_end = content.find('"', source_start)
    source_path = content[source_start:source_end]
    model_name = os.path.basename(source_path).split('.')[0]
    
    # Check if we already have the physics enabled
    if '"generate/physics": true' in content:
        return
    
    # Replace the _subresources section
    if "_subresources={}" in content:
        modified_content = content.replace(
            '_subresources={}',
            '_subresources={\n"nodes": {\n"PATH:' + model_name + '": {\n"generate/physics": true\n}\n}\n}'
        )
        
        with open(file_path, 'w') as f:
            f.write(modified_content)
        
        print(f"Updated: {os.path.basename(file_path)}")

# Find all .import files
import_files = glob.glob(os.path.join(DIR_PATH, "**/*.import"), recursive=True)
print(f"Found {len(import_files)} .import files")

# Process each file
count = 0
for file_path in import_files:
    enable_physics_for_import_file(file_path)
    count += 1

print(f"Processed {count} files")