# FUN_0047a03c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047a03c
# extent:       0x0047a03c-0x0047a1a9 (365 code bytes)
# span:         0x0047a03c-0x0047a1a9 (code 365, tables 0, padding 0)
# sha256:       b9bdb49708ab5294f09473f5dc4f7e14d20a417cde5818726c8f91c4bb28563e
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047a03c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_1528, field_152c, field_157a, field_157e, field_159a; [ecx + n] field_1e, field_216, field_152e, field_1576, field_159a; [edx + n] field_24, field_1528, field_1532
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 83 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_216, 0x216  # offset +0x216
.equ field_1528, 0x1528  # offset +0x1528
.equ field_152c, 0x152c  # offset +0x152c
.equ field_152e, 0x152e  # offset +0x152e
.equ field_1532, 0x1532  # offset +0x1532
.equ field_1576, 0x1576  # offset +0x1576
.equ field_157a, 0x157a  # offset +0x157a
.equ field_157e, 0x157e  # offset +0x157e
.equ field_159a, 0x159a  # offset +0x159a

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047a03c - 0x401000
.globl FUN_0047a03c
FUN_0047a03c:
    # block 0x0047a03c: entry, 14 instruction(s), ends with je to 0x0047a1a3 (forward)
    push ebp                                     # 0047a03c
    {load} mov ebp, esp                          # 0047a03d
    sub esp, 0xc                                 # 0047a03f
    push esi                                     # 0047a042
    push edi                                     # 0047a043
    mov dword ptr [ebp - local_c], ecx           # 0047a044
    mov eax, dword ptr [ebp - local_c]           # 0047a047
    movsx ecx, word ptr [eax + field_1e]         # 0047a04a
    imul ecx, ecx, 0x8d                          # 0047a04e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047a054
    mov dword ptr [ebp - local_4], edx           # 0047a05a
    mov eax, dword ptr [ebp - local_c]           # 0047a05d
    cmp dword ptr [eax + field_157a], 0x0        # 0047a060
    je.d32 L_0047a1a3                            # 0047a067
    # block 0x0047a06d: entered by fall-through of je at 0x0047a067, 3 instruction(s), ends with jne to 0x0047a1a3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047a06d
    cmp dword ptr [ecx + field_1576], 0x0        # 0047a070
    jne.d32 L_0047a1a3                           # 0047a077
    # block 0x0047a07d: entered by fall-through of jne at 0x0047a077, 3 instruction(s), ends with jne to 0x0047a1a3 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047a07d
    cmp dword ptr [edx + field_24], 0x0          # 0047a080
    jne.d32 L_0047a1a3                           # 0047a084
    # block 0x0047a08a: entered by fall-through of jne at 0x0047a084, 3 instruction(s), ends with jne to 0x0047a1a3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047a08a
    cmp dword ptr [eax + field_1528], 0x0        # 0047a08d
    jne.d32 L_0047a1a3                           # 0047a094
    # block 0x0047a09a: entered by fall-through of jne at 0x0047a094, 5 instruction(s), ends with jne to 0x0047a1a3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047a09a
    movsx edx, word ptr [ecx + field_1e]         # 0047a09d
    imul edx, edx, 0x8d                          # 0047a0a1
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0047a0a7
    jne.d32 L_0047a1a3                           # 0047a0ae
    # block 0x0047a0b4: entered by fall-through of jne at 0x0047a0ae, 2 instruction(s), ends with jne to 0x0047a0e9 (forward)
    cmp dword ptr [0x5c39e5], 0x279d             # 0047a0b4
    jne.d8 L_0047a0e9                            # 0047a0be
    # block 0x0047a0c0: entered by fall-through of jne at 0x0047a0be, 7 instruction(s), ends with forward jump to 0x0047a1a3
    mov eax, dword ptr [ebp - local_c]           # 0047a0c0
    mov dword ptr [eax + field_157e], 0x1        # 0047a0c3
    mov ecx, dword ptr [ebp - local_c]           # 0047a0cd
    movsx edx, word ptr [ecx + field_1e]         # 0047a0d0
    imul edx, edx, 0x8d                          # 0047a0d4
    mov dword ptr [edx + 0x5bb632], 0x2          # 0047a0da
    jmp.d32 L_0047a1a3                           # 0047a0e4
L_0047a0e9:
    # block 0x0047a0e9: entered by jne at 0x0047a0be, 2 instruction(s), ends with jne to 0x0047a1a3 (forward)
    cmp dword ptr [0x5c39e5], 0x279c             # 0047a0e9
    jne.d32 L_0047a1a3                           # 0047a0f3
    # block 0x0047a0f9: entered by fall-through of jne at 0x0047a0f3, 4 instruction(s), ends with je to 0x0047a1a3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047a0f9
    movsx ecx, word ptr [eax + field_159a]       # 0047a0fc
    test ecx, ecx                                # 0047a103
    je.d32 L_0047a1a3                            # 0047a105
    # block 0x0047a10b: entered by fall-through of je at 0x0047a105, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0047a1a3 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047a10b
    mov dword ptr [edx + field_1528], 0x1        # 0047a10e
    mov eax, dword ptr [ebp - local_c]           # 0047a118
    mov ecx, dword ptr [ebp - local_c]           # 0047a11b
    mov dx, word ptr [ecx + field_159a]          # 0047a11e
    mov word ptr [eax + field_152c], dx          # 0047a125
    call dword ptr [0x52a23c]                    # 0047a12c
    add eax, 0xfa                                # 0047a132
    mov ecx, dword ptr [ebp - local_c]           # 0047a137
    mov dword ptr [ecx + field_152e], eax        # 0047a13a
    mov edx, dword ptr [ebp - local_c]           # 0047a140
    mov dword ptr [edx + field_1532], 0x1        # 0047a143
    cmp dword ptr [0x5bb1ca], 0x0                # 0047a14d
    je.d8 L_0047a1a3                             # 0047a154
    # block 0x0047a156: entered by fall-through of je at 0x0047a154, 7 instruction(s), ends with je to 0x0047a1a3 (forward)
    mov edi, 0x54cb8c                            # 0047a156
    mov esi, dword ptr [ebp - local_4]           # 0047a15b
    add esi, 0x1f5                               # 0047a15e
    mov ecx, 0x9                                 # 0047a164
    {load} xor eax, eax                          # 0047a169
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047a16b
    je.d8 L_0047a1a3                             # 0047a16d
    # block 0x0047a16f: entered by fall-through of je at 0x0047a16d, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0047a1a3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047a16f
    movsx edx, word ptr [ecx + field_216]        # 0047a172
    mov dword ptr [ebp - local_8], edx           # 0047a179
    mov eax, dword ptr [ebp - local_8]           # 0047a17c
    push eax                                     # 0047a17f
    mov ecx, 0x5cf1eb                            # 0047a180
    call FUN_004f6334                            # 0047a185
    test eax, eax                                # 0047a18a
    jne.d8 L_0047a1a3                            # 0047a18c
    # block 0x0047a18e: entered by fall-through of jne at 0x0047a18c, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0047a1a3
    mov ecx, dword ptr [ebp - local_4]           # 0047a18e
    mov dx, word ptr [ecx + field_216]           # 0047a191
    push edx                                     # 0047a198
    mov ecx, 0x5c3a67                            # 0047a199
    call FUN_004fb2e3                            # 0047a19e
L_0047a1a3:
    # block 0x0047a1a3: entered by je at 0x0047a067; jne at 0x0047a077; jne at 0x0047a084; jne at 0x0047a094; more, 5 instruction(s), ends with ret
    pop edi                                      # 0047a1a3
    pop esi                                      # 0047a1a4
    {load} mov esp, ebp                          # 0047a1a5
    pop ebp                                      # 0047a1a7
    ret                                          # 0047a1a8

