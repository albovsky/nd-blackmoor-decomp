# FUN_0044c9db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c9db
# extent:       0x0044c9db-0x0044cb7d (418 code bytes)
# span:         0x0044c9db-0x0044cb7d (code 418, tables 0, padding 0)
# sha256:       d5880cc36fbc35e6096f2caa144bd9046b66c31615ef38e5ea07cc626491fde0
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44c9db_lifted
# naming:       native port src/original_methods_fl40.c:m44c9db_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 7 seeds; oracle: 102/102 instructions executed, 26/26 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44c9db_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 102 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044c9db - 0x401000
.globl FUN_0044c9db
FUN_0044c9db:
    # block 0x0044c9db: entry, 5 instruction(s), ends with je to 0x0044ca21 (forward)
    push ebp                                     # 0044c9db
    {load} mov ebp, esp                          # 0044c9dc
    sub esp, 0x18                                # 0044c9de
    cmp dword ptr [0x5b4db8], 0x0                # 0044c9e1
    je.d8 L_0044ca21                             # 0044c9e8
    # block 0x0044c9ea: entered by fall-through of je at 0x0044c9e8, 5 instruction(s), ends with jne to 0x0044ca0e (forward)
    {load} xor eax, eax                          # 0044c9ea
    mov ax, word ptr [0x5b4dc0]                  # 0044c9ec
    and eax, 0x8                                 # 0044c9f2
    test eax, eax                                # 0044c9f5
    jne.d8 L_0044ca0e                            # 0044c9f7
    # block 0x0044c9f9: entered by fall-through of jne at 0x0044c9f7, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044ca0e
    mov ecx, dword ptr [0x5b4db8]                # 0044c9f9
    mov dword ptr [ebp - local_4], ecx           # 0044c9ff
    mov edx, dword ptr [ebp - local_4]           # 0044ca02
    push edx                                     # 0044ca05
    call FUN_0051dc6c                            # 0044ca06
    add esp, 0x4                                 # 0044ca0b
L_0044ca0e:
    # block 0x0044ca0e: entered by jne at 0x0044c9f7, 2 instruction(s), falls into the block at 0x0044ca21
    mov word ptr [0x5b4dc0], 0x0                 # 0044ca0e
    mov dword ptr [0x5b4db8], 0x0                # 0044ca17
L_0044ca21:
    # block 0x0044ca21: entered by je at 0x0044c9e8, 2 instruction(s), ends with je to 0x0044ca61 (forward)
    cmp dword ptr [0x5b4dbc], 0x0                # 0044ca21
    je.d8 L_0044ca61                             # 0044ca28
    # block 0x0044ca2a: entered by fall-through of je at 0x0044ca28, 5 instruction(s), ends with jne to 0x0044ca4e (forward)
    {load} xor eax, eax                          # 0044ca2a
    mov ax, word ptr [0x5b4dc2]                  # 0044ca2c
    and eax, 0x8                                 # 0044ca32
    test eax, eax                                # 0044ca35
    jne.d8 L_0044ca4e                            # 0044ca37
    # block 0x0044ca39: entered by fall-through of jne at 0x0044ca37, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044ca4e
    mov ecx, dword ptr [0x5b4dbc]                # 0044ca39
    mov dword ptr [ebp - local_8], ecx           # 0044ca3f
    mov edx, dword ptr [ebp - local_8]           # 0044ca42
    push edx                                     # 0044ca45
    call FUN_0051dc6c                            # 0044ca46
    add esp, 0x4                                 # 0044ca4b
L_0044ca4e:
    # block 0x0044ca4e: entered by jne at 0x0044ca37, 2 instruction(s), falls into the block at 0x0044ca61
    mov word ptr [0x5b4dc2], 0x0                 # 0044ca4e
    mov dword ptr [0x5b4dbc], 0x0                # 0044ca57
L_0044ca61:
    # block 0x0044ca61: entered by je at 0x0044ca28, 2 instruction(s), ends with je to 0x0044caa1 (forward)
    cmp dword ptr [0x5b502f], 0x0                # 0044ca61
    je.d8 L_0044caa1                             # 0044ca68
    # block 0x0044ca6a: entered by fall-through of je at 0x0044ca68, 5 instruction(s), ends with jne to 0x0044ca8e (forward)
    {load} xor eax, eax                          # 0044ca6a
    mov ax, word ptr [0x5b5037]                  # 0044ca6c
    and eax, 0x8                                 # 0044ca72
    test eax, eax                                # 0044ca75
    jne.d8 L_0044ca8e                            # 0044ca77
    # block 0x0044ca79: entered by fall-through of jne at 0x0044ca77, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044ca8e
    mov ecx, dword ptr [0x5b502f]                # 0044ca79
    mov dword ptr [ebp - local_c], ecx           # 0044ca7f
    mov edx, dword ptr [ebp - local_c]           # 0044ca82
    push edx                                     # 0044ca85
    call FUN_0051dc6c                            # 0044ca86
    add esp, 0x4                                 # 0044ca8b
L_0044ca8e:
    # block 0x0044ca8e: entered by jne at 0x0044ca77, 2 instruction(s), falls into the block at 0x0044caa1
    mov word ptr [0x5b5037], 0x0                 # 0044ca8e
    mov dword ptr [0x5b502f], 0x0                # 0044ca97
L_0044caa1:
    # block 0x0044caa1: entered by je at 0x0044ca68, 2 instruction(s), ends with je to 0x0044cae1 (forward)
    cmp dword ptr [0x5b5033], 0x0                # 0044caa1
    je.d8 L_0044cae1                             # 0044caa8
    # block 0x0044caaa: entered by fall-through of je at 0x0044caa8, 5 instruction(s), ends with jne to 0x0044cace (forward)
    {load} xor eax, eax                          # 0044caaa
    mov ax, word ptr [0x5b5039]                  # 0044caac
    and eax, 0x8                                 # 0044cab2
    test eax, eax                                # 0044cab5
    jne.d8 L_0044cace                            # 0044cab7
    # block 0x0044cab9: entered by fall-through of jne at 0x0044cab7, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044cace
    mov ecx, dword ptr [0x5b5033]                # 0044cab9
    mov dword ptr [ebp - local_10], ecx          # 0044cabf
    mov edx, dword ptr [ebp - local_10]          # 0044cac2
    push edx                                     # 0044cac5
    call FUN_0051dc6c                            # 0044cac6
    add esp, 0x4                                 # 0044cacb
L_0044cace:
    # block 0x0044cace: entered by jne at 0x0044cab7, 2 instruction(s), falls into the block at 0x0044cae1
    mov word ptr [0x5b5039], 0x0                 # 0044cace
    mov dword ptr [0x5b5033], 0x0                # 0044cad7
L_0044cae1:
    # block 0x0044cae1: entered by je at 0x0044caa8, 2 instruction(s), ends with je to 0x0044cb21 (forward)
    cmp dword ptr [0x638151], 0x0                # 0044cae1
    je.d8 L_0044cb21                             # 0044cae8
    # block 0x0044caea: entered by fall-through of je at 0x0044cae8, 5 instruction(s), ends with jne to 0x0044cb0e (forward)
    {load} xor eax, eax                          # 0044caea
    mov ax, word ptr [0x638159]                  # 0044caec
    and eax, 0x8                                 # 0044caf2
    test eax, eax                                # 0044caf5
    jne.d8 L_0044cb0e                            # 0044caf7
    # block 0x0044caf9: entered by fall-through of jne at 0x0044caf7, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044cb0e
    mov ecx, dword ptr [0x638151]                # 0044caf9
    mov dword ptr [ebp - local_14], ecx          # 0044caff
    mov edx, dword ptr [ebp - local_14]          # 0044cb02
    push edx                                     # 0044cb05
    call FUN_0051dc6c                            # 0044cb06
    add esp, 0x4                                 # 0044cb0b
L_0044cb0e:
    # block 0x0044cb0e: entered by jne at 0x0044caf7, 2 instruction(s), falls into the block at 0x0044cb21
    mov word ptr [0x638159], 0x0                 # 0044cb0e
    mov dword ptr [0x638151], 0x0                # 0044cb17
L_0044cb21:
    # block 0x0044cb21: entered by je at 0x0044cae8, 2 instruction(s), ends with je to 0x0044cb61 (forward)
    cmp dword ptr [0x638155], 0x0                # 0044cb21
    je.d8 L_0044cb61                             # 0044cb28
    # block 0x0044cb2a: entered by fall-through of je at 0x0044cb28, 5 instruction(s), ends with jne to 0x0044cb4e (forward)
    {load} xor eax, eax                          # 0044cb2a
    mov ax, word ptr [0x63815b]                  # 0044cb2c
    and eax, 0x8                                 # 0044cb32
    test eax, eax                                # 0044cb35
    jne.d8 L_0044cb4e                            # 0044cb37
    # block 0x0044cb39: entered by fall-through of jne at 0x0044cb37, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044cb4e
    mov ecx, dword ptr [0x638155]                # 0044cb39
    mov dword ptr [ebp - local_18], ecx          # 0044cb3f
    mov edx, dword ptr [ebp - local_18]          # 0044cb42
    push edx                                     # 0044cb45
    call FUN_0051dc6c                            # 0044cb46
    add esp, 0x4                                 # 0044cb4b
L_0044cb4e:
    # block 0x0044cb4e: entered by jne at 0x0044cb37, 2 instruction(s), falls into the block at 0x0044cb61
    mov word ptr [0x63815b], 0x0                 # 0044cb4e
    mov dword ptr [0x638155], 0x0                # 0044cb57
L_0044cb61:
    # block 0x0044cb61: entered by je at 0x0044cb28, 3 instruction(s), ends with je to 0x0044cb79 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044cb61
    test eax, eax                                # 0044cb68
    je.d8 L_0044cb79                             # 0044cb6a
    # block 0x0044cb6c: entered by fall-through of je at 0x0044cb6a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cb79
    push 0x5493ec                                # 0044cb6c
    call FUN_0044a2b7                            # 0044cb71
    add esp, 0x4                                 # 0044cb76
L_0044cb79:
    # block 0x0044cb79: entered by je at 0x0044cb6a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044cb79
    pop ebp                                      # 0044cb7b
    ret                                          # 0044cb7c

