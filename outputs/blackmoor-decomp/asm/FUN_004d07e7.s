# FUN_004d07e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d07e7
# extent:       0x004d07e7-0x004d0952 (363 code bytes)
# span:         0x004d07e7-0x004d0952 (code 363, tables 0, padding 0)
# sha256:       de207b780a3184ced6cbcc96ff3674e33d23015298105746adf6f3a269e70aae
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d07e7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004d2c20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)

.org 0x004d07e7 - 0x401000
.globl FUN_004d07e7
FUN_004d07e7:
    # block 0x004d07e7: entry, 54 instruction(s), calls FUN_004c5377, FUN_004d2c20, ends with jbe to 0x004d094f (forward)
    push ebp                                     # 004d07e7
    {load} mov ebp, esp                          # 004d07e8
    push edi                                     # 004d07ea
    push 0x55a004                                # 004d07eb
    push 0x5b61c1                                # 004d07f0
    movsx eax, word ptr [0x5b61b0]               # 004d07f5
    imul eax, eax, 0x8d                          # 004d07fc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0802
    add ecx, 0x24                                # 004d0808
    push ecx                                     # 004d080b
    mov edx, dword ptr [0x5cf665]                # 004d080c
    push edx                                     # 004d0812
    mov eax, dword ptr [0x5d15e3]                # 004d0813
    push eax                                     # 004d0818
    mov ecx, 0x5cf659                            # 004d0819
    call FUN_004c5377                            # 004d081e
    push 0x0                                     # 004d0823
    mov ecx, dword ptr [0x5cf665]                # 004d0825
    push ecx                                     # 004d082b
    movsx edx, word ptr [0x5b61b0]               # 004d082c
    imul edx, edx, 0x8d                          # 004d0833
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0839
    movsx ecx, word ptr [eax]                    # 004d083f
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d0842
    push edx                                     # 004d0849
    mov ax, word ptr [0x5b61dd]                  # 004d084a
    push eax                                     # 004d0850
    mov cx, word ptr [0x5b61d1]                  # 004d0851
    push ecx                                     # 004d0858
    movsx edx, word ptr [0x5b61b0]               # 004d0859
    imul edx, edx, 0x8d                          # 004d0860
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0866
    movsx ecx, word ptr [eax]                    # 004d086c
    imul ecx, ecx, 0x1d0                         # 004d086f
    add ecx, 0x5adb3a                            # 004d0875
    push ecx                                     # 004d087b
    movsx edx, word ptr [0x5b61b0]               # 004d087c
    imul edx, edx, 0x8d                          # 004d0883
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0889
    movsx ecx, word ptr [eax]                    # 004d088f
    imul ecx, ecx, 0x7f3                         # 004d0892
    add ecx, 0x5a4c24                            # 004d0898
    push ecx                                     # 004d089e
    push 0x5b616d                                # 004d089f
    call FUN_004d2c20                            # 004d08a4
    add esp, 0x20                                # 004d08a9
    mov edi, 0x5b618e                            # 004d08ac
    or ecx, -0x1                                 # 004d08b1
    {load} xor eax, eax                          # 004d08b4
    repne scasb al, byte ptr es:[edi]            # 004d08b6
    not ecx                                      # 004d08b8
    add ecx, -0x1                                # 004d08ba
    test ecx, ecx                                # 004d08bd
    jbe.d32 L_004d094f                           # 004d08bf
    # block 0x004d08c5: entered by fall-through of jbe at 0x004d08bf, 30 instruction(s), calls FUN_004d2c20, falls into the block at 0x004d094f
    push 0x0                                     # 004d08c5
    mov edx, dword ptr [0x5cf665]                # 004d08c7
    push edx                                     # 004d08cd
    movsx eax, word ptr [0x5b61b0]               # 004d08ce
    imul eax, eax, 0x8d                          # 004d08d5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d08db
    movsx edx, word ptr [ecx]                    # 004d08e1
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d08e4
    push eax                                     # 004d08eb
    mov cx, word ptr [0x5b61ed]                  # 004d08ec
    push ecx                                     # 004d08f3
    mov dx, word ptr [0x5b61e1]                  # 004d08f4
    push edx                                     # 004d08fb
    movsx eax, word ptr [0x5b61b0]               # 004d08fc
    imul eax, eax, 0x8d                          # 004d0903
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0909
    movsx edx, word ptr [ecx]                    # 004d090f
    imul edx, edx, 0x1d0                         # 004d0912
    add edx, 0x5adb3a                            # 004d0918
    push edx                                     # 004d091e
    movsx eax, word ptr [0x5b61b0]               # 004d091f
    imul eax, eax, 0x8d                          # 004d0926
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d092c
    movsx edx, word ptr [ecx]                    # 004d0932
    imul edx, edx, 0x7f3                         # 004d0935
    add edx, 0x5a4c24                            # 004d093b
    push edx                                     # 004d0941
    push 0x5b618e                                # 004d0942
    call FUN_004d2c20                            # 004d0947
    add esp, 0x20                                # 004d094c
L_004d094f:
    # block 0x004d094f: entered by jbe at 0x004d08bf, 3 instruction(s), ends with ret
    pop edi                                      # 004d094f
    pop ebp                                      # 004d0950
    ret                                          # 004d0951

