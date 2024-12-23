import os

def count_lines_in_file(file_path):
    """
    Counts the number of lines in a given file.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return sum(1 for _ in file)
    except (UnicodeDecodeError, IOError):
        # Skipping files that can't be read
        return 0

def count_lines_in_folder(folder_path):
    """
    Recursively counts the total number of lines of code in all files
    within the given folder and its subfolders.
    """
    total_lines = 0
    for root, _, files in os.walk(folder_path):
        for file in files:
            # Consider only code files (optional: filter by extensions)
            if file.endswith(('.py', '.dart', '.js', '.ts', '.java', '.cpp', '.h', '.cs', '.html', '.css', '.json', '.yaml', '.xml')):
                file_path = os.path.join(root, file)
                total_lines += count_lines_in_file(file_path)
    return total_lines

if __name__ == "__main__":
    folder = input("Enter the folder path to analyze: ").strip()
    if not os.path.exists(folder):
        print("The specified folder does not exist.")
    else:
        total_lines = count_lines_in_folder(folder)
        print(f"Total lines of code in '{folder}': {total_lines}")
