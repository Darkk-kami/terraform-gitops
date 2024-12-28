#!/usr/bin/env python

import subprocess

def run_command(command):
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")
        exit(1)

# Initialization tasks
print("Initializing service...")
run_command(["python", "./app/backend_pre_start.py"])
run_command(["alembic", "upgrade", "head"])
run_command(["python", "./app/initial_data.py"])

# Start uvicorn
print("Starting the application with uvicorn...")
subprocess.Popen(
    ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)
