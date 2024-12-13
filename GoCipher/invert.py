import subprocess
flag = ""
# The characters to try
CHOICES = (
    "0123456789"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "'_{}=+-*/!?%&@#^~`|\\:;,.<>[]()"
)

def brute_force_GoCipher_flag():
    global flag
    while not flag.endswith('}'):
        for ch in CHOICES:
            candidate = flag + ch
            print(f"Trying key: {candidate}")
            process = subprocess.Popen(
                [r'.\gocipher.exe'],  # The executable
                stdin=subprocess.PIPE,  # Pipe the input to stdin
                stdout=subprocess.PIPE,  # Capture the output
                stderr=subprocess.PIPE,  # Capture any errors
                text=True  # Return output as a string (not bytes)
            )
            
            # Pass the candidate as input to inverted.exe and get the output
            output, error = process.communicate(input=candidate + "\n")  # Send input and get output

            output = output.strip()  # Clean up the output
            if "Congratulations" in output:
                print(f"Valid flag found so far: {candidate}")
                flag = candidate  # Update the global flag with the correct character
                break  # Move to the next character

brute_force_GoCipher_flag()
