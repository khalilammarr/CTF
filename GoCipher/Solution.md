# GoCipher
* ***Category : Reverse Engineering***  
 >   Description : **Break Leg !**

An executable was attached ( *.exe* ).
## Solution
Let's run this file :
```
PS C:\Users\MSI\CTF\Securinets Mini_CTF\GoCipher> .\gocipher.exe
__   __    _ _            _
\ \ / /_ _| | |___  _ _ _(_)___
 \ V / _` | | / / || | '_| / -_)
  \_/\__,_|_|_\_\\_, |_| |_|\___|
                 |__/
 ###############################################
Welcome to the challenge!

Flag : flag

Sorry, you have failed the challenge! :(
```

Looks like a simple program where we need to enter the flag

Let's take a look at the disassembly using [IDA](https://getintopc.com/softwares/disassembler/hex-rays-ida-pro-2024-free-download/)
```c
// main.main
void __fastcall main_main()
{
 ...
 ...
  main_welcome();
  fmt_Fprintf(
    (unsigned int)off_4F33C8,
    qword_580508,
    (unsigned int)"Flag : booleanbdoUxXvintegercomplexfloat32float6419531259765625consoleinvaliduintptrChanDir Value>:eventsCopySidWSARecvWSASendconnectforcegcallocmWcpuprofallocmRunknowngctraceIO : gp= found at *( s.elemsize= B (",
    7,
    0,
    0,
    0,
    v0,
    v1);
  p_string = (string *)runtime_newobject((const RTYPE *)&RTYPE_string);
  v60 = (__int64 *)p_string;
  p_string->ptr = 0LL;
  v59[0] = &RTYPE__ptr_string;
  v59[1] = p_string;
  v3 = 1LL;
  fmt_Fscanln((unsigned int)off_4F33E8, qword_580500, (unsigned int)v59, 1, 1, v4, v5, v6, v7);
  v8 = *v60;
  v13 = runtime_stringtoslicerune((__int64)v53, *v60, v60[1], 1, 1, v9, v10, v11, v12);
  v58 = v13;
  v56 = v8;
  v45 = 18608;
  v46 = -1689127791;
  v47 = 0x5FC8434AF08048E6LL;
  v48 = 0x729813986D12F65CLL;
  v49 = 0x7F6E6A476E74953DLL;
  v50 = 0x6E65C47C87462F4LL;
  v51 = 0x44D6EF49D6CC860LL;
  v18 = 0LL;
  v19 = 0LL;
  v20 = 0LL;
  while ( v8 > v18 )
  {
    v54 = v18;
    v55 = v19;
    v57 = v20;
    v24 = 3 * ((__int64)(v18 + ((unsigned __int128)(v18 * (__int128)(__int64)0xAAAAAAAAAAAAAAABLL) >> 64)) >> 1);
    v25 = *(int *)(v13 + 4 * v18);
    if ( v18 == v24 )
    {
      v33 = 2 * v25 - ((((unsigned __int64)((2 * v25 + 10) >> 63) >> 56) + 2 * v25 + 10) & 0xFFFFFFFFFFFFFF00LL);
      v27 = v33 + 10;
      v28 = runtime_intstring(0, (int)v33 + 10, (int)v33 + 10, v33, v20, v14, v15, v16, v17, v43, v44);
    }
    else if ( v18 - v24 == 1 )
    {
      v26 = v25 ^ 0x2A;
      v27 = v26 - 7;
      v28 = runtime_intstring(0, v26 - 7, v26 - 7, v26, v20, v14, v15, v16, v17, v43, v44);
    }
    else
    {
      v27 = (v25 + 31) ^ 0x13;
      v28 = runtime_intstring(0, v27, v27, v25, v20, v14, v15, v16, v17, v43, v44);
    }
    v3 = v28;
    v21 = v27;
    v22 = v57;
    v23 = runtime_concatstring2(0, v57, v55, v28, v21, v29, v30, v31, v32);
    v18 = v54 + 1;
    v19 = v22;
    v20 = v23;
    v13 = v58;
    v8 = v56;
  }
  v34 = v20;
  v35 = runtime_stringtoslicerune((__int64)v52, v20, v19, v3, v20, v14, v15, v16, v17);
  for ( i = 0LL; v34 > (__int64)i; ++i )
  {
    if ( i >= 0x2E )
      runtime_panicIndex(i, v34, 46LL);
    v20 = *((unsigned __int8 *)&v45 + i);
    if ( *(_DWORD *)(v35 + 4 * i) != (_DWORD)v20 )
    {
      main_fail();
      return;
    }
  }
  v37 = main_DancingStickMan(v35);
  main_win(v37, v34, v38, v3, v20, v39, v40, v41, v42);
}
```
Looking at the disassembly code, we can see the program doesn’t check the length of the entered flag. This means **even an incomplete flag could ***potentially*** pass**, as long as the characters match the original flag. If that’s the case, we should be able to brute force our way to the complete flag.
Since we know the flag format : Securinets{###} let's try Securinets as an input !
```
PS C:\Users\MSI\CTF\Securinets Mini_CTF\GoCipher> .\gocipher.exe
__   __    _ _            _
\ \ / /_ _| | |___  _ _ _(_)___
 \ V / _` | | / / || | '_| / -_)
  \_/\__,_|_|_\_\\_, |_| |_|\___|
                 |__/

 ###############################################

Welcome to the challenge!


Flag : Securinets{

Congratulations! You have solved the challenge!

```
It did actually pass so instead of trying to figure out how the program handles our input and reverse its logic etc ... we can simply use brute force to find the flag.
>We’ll start by testing every printable character one by one. When the program prints a success message, we add the character to the flag and keep going. We’ll keep doing this until we hit the '}' character, which tells us the flag is complete

***This is the script that will make that happen***
```
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
```
* By executing the script we find the following flag :
  ![image](https://github.com/user-attachments/assets/4c804a12-9311-4c03-8b11-0f189a193d09)

-------->     ***Securinets{1_L0v3_G0l4ng5_50_MuCH_d0n'T_You?}***

  
