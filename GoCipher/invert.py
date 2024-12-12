import subprocess

# The known part of the flag
flag = "Securinets{"
# The characters to try
CHOICES = (
    "0123456789"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "'_{}=+-*/!?%&@#^~`|\\:;,.<>[]()"  # Additional space, tab, newline, and other control characters

)

def brute_force_serial_key():
    global flag  # Tell Python we're using the global 'flag' variable
    # Loop until the flag ends with '}'
    while not flag.endswith('}'):
        # Try all possible characters for the next position
        for ch in CHOICES:
            # Construct the current serial key by appending the candidate character
            candidate = flag + ch
            print(f"Trying key: {candidate}")
            
            # Run the command using subprocess and pass the candidate via stdin
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
            
            # If the output is "GG", the key is correct
            print(f"AHAWA: {output}")
            if "solved" in output:
                print(f"Valid serial key found so far: {candidate}")
                flag = candidate  # Update the global flag with the correct character
                break  # Move to the next character

brute_force_serial_key()
