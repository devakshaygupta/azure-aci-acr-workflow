# Word Count Application

def count_words_in_file(file_path):
    """Counts the number of words in the specified file."""
    try:
        with open(file_path, 'r') as file:
            text = file.read()
            words = text.split()
            return len(words)
    except FileNotFoundError:
        print(f"The file {file_path} was not found.")
        return 0

if __name__ == "__main__":
    file_path = 'data.txt'  # Path to the input file
    word_count = count_words_in_file(file_path)
    print(f"Word count: {word_count}")