import os

def extract_image_names(directory):
    """Extract image names from the specified directory and save them to a text file."""
    # List of common image extensions
    image_extensions = ('.jpg', '.jpeg', '.png', '.webp')
    
    # Get all files in the directory
    try:
        files = os.listdir(directory)
    except FileNotFoundError:
        print(f"Error: Directory '{directory}' not found.")
        return
    
    # Filter for image files and remove extensions
    image_names = []
    for file in files:
        if file.lower().endswith(image_extensions):
            # Remove the file extension and add to list
            name = os.path.splitext(file)[0]
            image_names.append(name)
    
    # Sort the names alphabetically
    image_names.sort()
    
    # Write to output file
    output_file = os.path.join(os.path.dirname(directory), 'simplified_image_names.txt')
    with open(output_file, 'w', encoding='utf-8') as f:
        for name in image_names:
            f.write(f"{name}\n")
    
    print(f"Successfully extracted {len(image_names)} image names to {output_file}")

if __name__ == "__main__":
    # Directory containing the images
    image_dir = r"assets\images\subcategoryImages\Système_d'Alimentation"
    
    # Get the full path relative to the script's location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    full_path = os.path.join(script_dir, image_dir)
    
    extract_image_names(full_path)
