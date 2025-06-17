import subprocess
import os
import sys
import platform

# Define paths
proto_file = 'grpc-proto/expense.proto'
proto_path = 'grpc-proto'

output_dirs = {
    'python': 'lib/backend/python',
    'dart_frontend': 'lib/services',
}

# Create output directories if they don't exist
for path in output_dirs.values():
    os.makedirs(path, exist_ok=True)

# Determine well-known protos include path (adjust if protoc is installed differently)
def get_well_known_protos_path():
    if platform.system() == 'Windows':
        # Example default path; update if needed
        return r'C:\Users\ariqs\local\protoc-29.1-win64\include'

    else:
        # Unix/macOS
        try:
            protoc_path = subprocess.check_output(['which', 'protoc'], text=True).strip()
            return os.path.join(os.path.dirname(protoc_path), '../include')
        except subprocess.CalledProcessError:
            return '/usr/local/include'  # fallback

well_known_path = get_well_known_protos_path()

# Generate Python files
try:
    print("🔄 Generating Python gRPC files...")
    subprocess.check_call([
        'python', '-m', 'grpc_tools.protoc',
        f'-I={proto_path}',
        f'-I={well_known_path}',
        f'--python_out={output_dirs["python"]}',
        f'--pyi_out={output_dirs["python"]}',
        f'--grpc_python_out={output_dirs["python"]}',
        proto_file
    ])
    print("✅ Python gRPC files generated successfully.")
except subprocess.CalledProcessError as e:
    print("❌ Failed to generate Python gRPC files:")
    print(e)

# Generate Dart files
try:
    print("🔄 Generating Dart frontend gRPC files (including well-known types)...")
    subprocess.check_call([
        'protoc',
        f'-I={proto_path}',
        f'-I={well_known_path}',
        '--dart_out=grpc:lib/services',
        f'{proto_file}',
        os.path.join(well_known_path, 'google', 'protobuf', 'timestamp.proto')
    ])
    print("✅ Dart frontend gRPC files generated successfully (including timestamp).")
except subprocess.CalledProcessError as e:
    print("❌ Failed to generate Dart gRPC files:")
    print(e)
