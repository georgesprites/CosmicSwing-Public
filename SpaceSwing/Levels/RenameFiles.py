# File: rename_levels_command.py
import os
import sys

def rename_levels(start_level):
    """
    Renames files starting from the specified level by incrementing their level by 1.
    Operates in the current directory.

    Args:
        start_level (int): The level from which to start renaming.
    """
    # Get the current directory
    directory = os.getcwd()
    
    # List all files in the directory and sort them by level number
    files = sorted(
        [f for f in os.listdir(directory) if f.startswith("Level") and f.endswith(".sks")],
        key=lambda x: int(x.replace("Level", "").replace(".sks", ""))
    )
    
    # Rename files starting from the specified level
    for file in reversed(files):
        current_level = int(file.replace("Level", "").replace(".sks", ""))
        if current_level >= start_level:
            new_level = current_level + 1
            old_path = os.path.join(directory, file)
            new_filename = f"Level{new_level}.sks"
            new_path = os.path.join(directory, new_filename)
            os.rename(old_path, new_path)
            print(f"Renamed: {file} -> {new_filename}")

if __name__ == "__main__":
    # Ensure the user provides the starting level
    if len(sys.argv) != 2:
        print("Usage: python rename_levels_command.py <start_level>")
        sys.exit(1)
    
    try:
        start_level = int(sys.argv[1])
        rename_levels(start_level)
    except ValueError:
        print("Error: <start_level> must be an integer.")
        sys.exit(1)