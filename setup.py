import subprocess
import shutil
import os


# Ensure the output directories exist
output_dirs = [
    'backend/python',
    'backend/dirt',
    'backend/go',
    'backend/node',
    'frontend/expense_tracker_app/lib/generated',
    'frontend/python_cli/generated',
    
]

for dir in output_dirs:
    if not os.path.exists(dir):
        os.makedirs(dir)
    
#Generate the gRPC code python server 
subprocess.check_call([
    'python', '-m', 'grpc_tools.protoc',
    '-I=grpc-proto',
    '--python_out=backend/python',
    '--pyi_out=backend/python',
    '--grpc_python_out=backend/python',
    'grpc-proto/expense.proto'
])

# Generate the Dart code for the frontend
subprocess.check_call([
    'protoc',
    '-I=grpc-proto',
    '--dart_out=grpc:frontend/expense_tracker_app/lib/generated',
    'grpc-proto/expense.proto'
])

# Generate the Dart code for the frontend
subprocess.check_call([
    'protoc',
    '-I=grpc-proto',
    '--dart_out=grpc:backend/dirt',
    'grpc-proto/expense.proto'
])

# # Cleanup generated Python code
# python_generated_dir = 'backend/python'
# if os.path.exists(python_generated_dir):
#     shutil.rmtree(python_generated_dir)

# # Cleanup generated Dart code
# dart_generated_dir = 'frontend/expense_tracker_app/lib/generated'
# if os.path.exists(dart_generated_dir):
#     shutil.rmtree(dart_generated_dir)