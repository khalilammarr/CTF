# GoCipher
* ***Category : Reverse Engineering***  
 >   **Break Leg !**

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


 ###############################################


Flag : Flag


 ###############################################



Sorry, you have failed the challenge! :(


 ###############################################


```

Looks like a simple program where we need to enter the flag

Let's take a look at the disassembly using [IDA](https://getintopc.com/softwares/disassembler/hex-rays-ida-pro-2024-free-download/)
```c
// main.main
void __fastcall main_main()
{
  int v0; // r10d
  int v1; // r11d
  string *p_string; // rax
  __int64 v3; // rdi
  int v4; // r8d
  int v5; // r9d
  int v6; // r10d
  int v7; // r11d
  __int64 v8; // rbx
  __int64 v9; // r8
  int v10; // r9d
  int v11; // r10d
  int v12; // r11d
  __int64 v13; // rax
  __int64 v14; // r8
  int v15; // r9d
  int v16; // r10d
  int v17; // r11d
  __int64 v18; // rcx
  __int64 v19; // rdx
  __int64 v20; // rsi
  int v21; // esi
  __int64 v22; // rbx
  __int64 v23; // rax
  __int64 v24; // rdx
  __int64 v25; // rdi
  int v26; // edi
  int v27; // ebx
  __int64 v28; // rax
  int v29; // r8d
  int v30; // r9d
  int v31; // r10d
  int v32; // r11d
  unsigned __int64 v33; // rdi
  __int64 v34; // rbx
  __int64 v35; // rax
  unsigned __int64 i; // rcx
  __int64 v37; // rax
  __int64 v38; // rcx
  int v39; // r8d
  int v40; // r9d
  int v41; // r10d
  int v42; // r11d
  __int64 v43; // [rsp-3Ah] [rbp-1A8h]
  __int64 v44; // [rsp-32h] [rbp-1A0h]
  __int16 v45; // [rsp+0h] [rbp-16Eh]
  int v46; // [rsp+2h] [rbp-16Ch]
  __int64 v47; // [rsp+6h] [rbp-168h]
  __int64 v48; // [rsp+Eh] [rbp-160h]
  __int64 v49; // [rsp+16h] [rbp-158h]
  __int64 v50; // [rsp+1Eh] [rbp-150h]
  __int64 v51; // [rsp+26h] [rbp-148h]
  char v52[24]; // [rsp+2Eh] [rbp-140h] BYREF
  char v53[128]; // [rsp+AEh] [rbp-C0h] BYREF
  __int64 v54; // [rsp+12Eh] [rbp-40h]
  __int64 v55; // [rsp+136h] [rbp-38h]
  __int64 v56; // [rsp+13Eh] [rbp-30h]
  __int64 v57; // [rsp+146h] [rbp-28h]
  __int64 v58; // [rsp+14Eh] [rbp-20h]
  _QWORD v59[2]; // [rsp+156h] [rbp-18h] BYREF
  __int64 *v60; // [rsp+166h] [rbp-8h]

  main_welcome();
  fmt_Fprintf(
    (unsigned int)off_4F33C8,
    qword_580508,
    (unsigned int)"Flag : booleanbdoUxXvintegercomplexfloat32float6419531259765625consoleinvaliduintptrChanDir Value>:eventsCopySidWSARecvWSASendconnectforcegcallocmWcpuprofallocmRunknowngctraceIO waitrunningsyscallwaitingforevernetworkUNKNOWN, goid= s=nil\n (scan  MB in pacer: % CPU ( zombie, j0 = head = panic:  nmsys= locks= dying= allocsGODEBUG m->g0= pad1=  pad2=  text= minpc= \tvalue= (scan)\ttypes : type avx512fos/execruntimetls3desGoString01234567beEfFgGv48828125infinitystrconv.parsing ParseIntnil Poolno anodeCancelIoReadFileAcceptExWSAIoctlshutdownscavengepollDesctraceBufdeadlockraceFinipanicnilcgocheckrunnable procid rax     rbx     rcx     rdx     rdi     rsi     rbp     rsp     r8      r9      r10     r11     r12     r13     r14     r15     rip     rflags  cs      fs      gs       is not  pointer packed=BAD RANK status unknown(trigger= npages= nalloc= nfreed=[signal  newval= mcount= bytes,  stack=[ minLC=  maxpc= \tstack=[ minutes status= etypes wsaioctlavx512bwavx512vlgo/typesnet/httpgo/buildnetedns0tlskyberx509sha101234567_244140625ParseUintcomplex64interfaceinvalid nreflect: funcargs(bad indirInterfaceFindCloseLocalFreeMoveFileWWriteFileWSASendTotimerSendpollCacheprofBlockstackpoolhchanLeafwbufSpansGC (idle)mSpanDeadinittracescavtracepanicwaitchan sendpreemptedcoroutinecopystack -> node= ms cpu,  (forced) wbuf1.n= wbuf2.n= s.limit= s.state= B work ( B exp.)  marked   unmarked in use)\n, size = bad prune, tail = recover:  not in [ctxt != 0, oldval=, newval= threads=: status= blocked= lockedg=atomicor8 runtime= m->curg=(unknown)traceback} stack=[ gp.goid= lockedm=ntdll.dllpsapi.dllInheritedpclmulqdqmath/randtlsrsakex012345678912207031256103515625ParseFloatwinsymlink/dev/stdincomplex128t.Kind == owner diedDnsQuery_WGetIfEntryCancelIoExCreatePipeGetVersionWSACleanupWSAStartupgetsockoptsetsockoptdnsapi.dllws2_32.dllnotifyListprofInsertstackLargeNot workermSpanInUseGOMAXPROCSstop tracedisablethpinvalidptrschedtracesemacquiredebug call flushGen  MB goal, s.state =  s.base()= heapGoal=GOMEMLIMIT KiB now,  pages at  sweepgen= sweepgen , bound = , limit = exitThreadBad varintGC forced\n runqueue= stopwait= runqsize= gfreecnt= throwing= spinning=atomicand8float64nanfloat32nanException  ptrSize=  targetpc= until pc=unknown pcruntime: ggoroutine LockFileExWSASocketWexecerrdothttp2debugcrypto/tlsbad verb '%0123456789_30517578125short write/dev/stdout/dev/stderrOpenProcessunreachableGetFileTypebad argSizemethodargs(reflect.Setbroken pipebad messagefile existsbad addressRegCloseKeyCloseHandleCreateFileWDeleteFileWExitProcessFreeLibrarySetFileTimeVirtualLockWSARecvFromclosesocketgetpeernamegetsocknamecrypt32.dllmswsock.dllsecur32.dllshell32.dlluserenv.dllassistQueuenetpollInitreflectOffsglobalAllocmSpanManualstart traceclobberfreegccheckmarkscheddetailunspecifiedcgocall nil s.nelems=   of size  runtime: p  ms clock,  nBSSRoots=runtime: P  exp.) for minTrigger=GOMEMLIMIT=bad m value, elemsize= freeindex= span.list=, npages =  p->status= in status  idleprocs= gcwaiting= schedtick= timerslen= mallocing=bad timedivfloat64nan1float64nan2float64nan3float32nan2GOTRACEBACK) at entry+ (targetpc= , plugin: runtime: g : frame.sp=created by ProcessPrngMoveFileExWNetShareAddNetShareDeli/o timeoutgocachehashgocachetesthttp2clienthttp2serverarchive/tartls10servercrypto/x509archive/zip152587890625762939453125short bufferinvalid slothost is downillegal seekGetLengthSidGetLastErrorGetStdHandleGetTempPathWLoadLibraryWReadConsoleWSetEndOfFileTransmitFileGetAddrInfoWadvapi32.dlliphlpapi.dllkernel32.dllnetapi32.dllsweepWaiterstraceStringsspanSetSpinemspanSpecialtraceTypeTabgcBitsArenasmheapSpecialgcpacertraceharddecommitmadvdontneeddumping heapchan receivelfstack.push span.limit= span.state=bad flushGen MB stacks, worker mode  nDataRoots= nSpanRoots= wbuf1=<nil> wbuf2=<nil> gcscandone runtime: gp= found at *( s.elemsize= B (",
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
Upon examining the disassembly code, we notice that the program doesn't impose any condition on the length of the entered flag.. This means that even an incomplete flag could potentially pass the check if the entered characters match the corresponding characters in the original flag. If this is the case we should be able to use brute force to find the complete flag.

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


 ###############################################


Flag : Securinets{

                 O
                /|\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O/
                 |
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O
                 |\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                 O/
                /|
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                 O
                /|\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O/
                 |
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O
                 |\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                 O/
                /|
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                 O
                /|\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O/
                 |
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                \O
                 |\
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K
                 O/
                /|
                / \

←[F←[2K←[F←[2K←[F←[2K←[F←[2K←[F←[2K

 ###############################################



Congratulations! You have solved the challenge!


 ###############################################
```
So instead of trying to figure out how the program handles our input and reverse the logic ... we can just brute-force our way to the flag.
>We’ll start by testing every printable character one by one. When the program prints a success message, we add the character to the flag and keep going. We’ll keep doing this until we hit the '}' character, which tells us the flag is complete

***This is the script that will make this happen***
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
            
            # If the output contains "Congratulations", the key is correct
            print(f"AHAWA: {output}")
            if "Congratulations" in output:
                print(f"Valid serial key found so far: {candidate}")
                flag = candidate  # Update the global flag with the correct character
                break  # Move to the next character

brute_force_GoCipher_flag()
```
* By executing the script we find the following flag :
  ***Securinets{1_L0v3_G0l4ng5_50_MuCH_d0n'T_You_?}***
