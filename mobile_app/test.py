import os

def find_double_slash_in_files(folder_path):
    # Iteracja przez wszystkie pliki w folderze i podfolderach
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.dart'):  # Sprawdzamy tylko pliki Dart
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for line_number, line in enumerate(lines, start=1):
                        if '//' in line:  # Szukamy znaków //
                            print(f"Znaleziono '//' w pliku: {file_path} w linii {line_number}")
                            print(f"  Treść linii: {line.strip()}")

if __name__ == "__main__":
    # Ścieżka do folderu lib (dostosuj do swojej struktury projektu)
    folder_path = './lib'
    
    if os.path.exists(folder_path):
        find_double_slash_in_files(folder_path)
    else:
        print(f"Folder {folder_path} nie istnieje.")
