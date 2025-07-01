import os
import re
import shutil
from collections import defaultdict
from datetime import datetime
import numpy as np

# TODO: update db_path during building of STATIC_DB

# Define the metadata structure
metadata_structure = {
    'cc_main_name': {'type': 'string', 'mandatory': True},
    'cc_main_full': {'type': 'string', 'mandatory': False},
    'cc_alt_name': {'type': 'string', 'mandatory': False},
    'cc_alt_full': {'type': 'string', 'mandatory': False},
    'sc_main_name': {'type': 'string', 'mandatory': True},
    'sc_alt_name': {'type': 'string', 'mandatory': False},
    'exec_year': {'type': 'int', 'mandatory': True},
    'exec_date': {'type': 'string', 'mandatory': False},
    'proj_main_name': {'type': 'string', 'mandatory': False},
    'proj_alt_name': {'type': 'string', 'mandatory': False},
    'pi_name': {'type': 'string', 'mandatory': True},
    'pi_email': {'type': 'string', 'mandatory': False},
    'sim_bibcode': {'type': 'string', 'mandatory': False},
    'sim_queue': {'type': 'string', 'mandatory': True},
    'sim_nnodes': {'type': 'int', 'mandatory': True},
    'sim_nmpi': {'type': 'int', 'mandatory': True},
    'sim_ncpu': {'type': 'int', 'mandatory': True},
    'sim_ngpu': {'type': 'int', 'mandatory': False},
    'sim_nthreads_total': {'type': 'int', 'mandatory': True},
    'sim_nvector': {'type': 'int', 'mandatory': False},
    'sim_cpu_compiler': {'type': 'string', 'mandatory': True},
    'sim_accel_compiler': {'type': 'string', 'mandatory': False},
    'sim_modules': {'type': 'string', 'mandatory': False},
    'ori_file_name': {'type': 'string', 'mandatory': True},
    'alt_file_name': {'type': 'string', 'mandatory': False},
    'db_file_name': {'type': 'string', 'mandatory': False},
    'db_path': {'type': 'string', 'mandatory': False}
}

def extract_metadata(file_path):
    metadata = {key: ('' if value['type'] == 'string' else 0) for key, value in metadata_structure.items()}
    with open(file_path, 'r') as file:
        content = file.read()
        header_match = re.search(r'########\s*#HEADER\s*########(.*?)#######\s*#SCRIPT\s*#######', content, re.DOTALL)
        if header_match:
            header = header_match.group(1)
            lines = header.strip().split('\n')
            for line in lines:
                if '=' in line:
                    key, value = line.split('=', 1)
                    key = key.strip()
                    value = value.strip()
                    if key in metadata_structure:
                        if metadata_structure[key]['type'] == 'int':
                            try:
                                metadata[key] = int(value) if value else 0
                            except ValueError:
                                print(f"Warning: Could not convert '{value}' for key '{key}' to int in file {os.path.basename(file_path)}")
                        else:
                            metadata[key] = value
    return metadata

def validate_metadata(metadata, file_name):
    errors = []
    for key, props in metadata_structure.items():
        if props['mandatory'] and not metadata.get(key):
            # Special handling for year, allowing fallback to exec_date
            if key == 'exec_year' and metadata.get('exec_date'):
                continue
            errors.append(f"Mandatory field '{key}' is missing or empty in file '{file_name}'")
    return errors

def process_files(directory):
    database = defaultdict(list)
    file_metadata = {}
    for filename in os.listdir(directory):
        if filename.endswith(('.sh', '.lsf')):
            file_path = os.path.join(directory, filename)
            metadata = extract_metadata(file_path)
            errors = validate_metadata(metadata, filename)
            if errors:
                print(f"Errors in file '{filename}':")
                for error in errors:
                    print(f"  - {error}")
            file_metadata[filename] = metadata
            for key, value in metadata.items():
                database[key].append(value)
    return database, file_metadata

def organize_files(file_metadata, source_dir, target_dir):
    for filename, metadata in file_metadata.items():
        cc_name = metadata.get('cc_main_name')
        computer_name = metadata.get('sc_main_name')
        compiler = metadata.get('sim_cpu_compiler')
        exec_year = metadata.get('exec_year')
        exec_date = metadata.get('exec_date')

        # Determine execution year, prioritizing exec_year
        if not exec_year:
            if exec_date:
                try:
                    exec_year = datetime.strptime(exec_date, '%d-%m-%Y').year
                except (ValueError, TypeError):
                    exec_year = 'unknown'
            else:
                exec_year = 'unknown'
        
        if exec_year == 'unknown':
            print(f"Warning: Could not determine execution year for file {filename}. Using 'unknown'.")

        # Ensure essential components for path are present
        if not all([cc_name, computer_name, exec_year, compiler]):
            print(f"Error: Cannot determine target directory for {filename} due to missing metadata. Skipping.")
            continue

        # Create directory structure
        dir_path = os.path.join(target_dir, cc_name, computer_name, str(exec_year), compiler)
        os.makedirs(dir_path, exist_ok=True)

        # Copy file to new location
        source_file = os.path.join(source_dir, filename)
        target_file = os.path.join(dir_path, filename)
        shutil.copy2(source_file, target_file)
        print(f"Copied {filename} to {dir_path}")

def save_database_to_npz(database, output_file):
    """
    Save the database to a .npz file.
    """
    # np.savez cannot handle object arrays with mixed types like the 'files' dict.
    # We create a clean version of the database for saving.
    db_to_save = {k: v for k, v in database.items() if k != 'files'}
    np.savez(output_file, **db_to_save)
    print(f"Database saved to {output_file}")


# Main execution
if __name__ == "__main__":
    incoming_directory = "../../INCOMING"
    target_directory = "../../STATIC_DB"
    npz_output_file = "ramses_slurm_database.npz"

    database, file_metadata = process_files(incoming_directory)
    
    if file_metadata:
        print("\nComputing centers represented in the sample:")
        print(np.unique(database['cc_main_name']))

        print("\nAll supercomputer names:")
        print(np.unique(database['sc_main_name']))

        print("\nAll metadata:")
        for key in metadata_structure:
            # to avoid printing the large list of file metadata
            if key in database:
                 print(f"{key}: {database[key]}")

        print("\nNumber of files processed:", len(file_metadata))

        print("\nExample of complete metadata for one file:")
        example_file = next(iter(file_metadata))
        print(f"File: {example_file}")
        for key, value in file_metadata[example_file].items():
            print(f"  {key}: {value}")

        # Organize files into static directory structure
        organize_files(file_metadata, incoming_directory, target_directory)

        print("\nFiles have been organized into the static directory structure.")

        # Save the database to a .npz file
        save_database_to_npz(database, npz_output_file)
    else:
        print("No script files found in the INCOMING directory.")
