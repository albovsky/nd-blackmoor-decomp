# FUN_005127e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005127e5
# extent:       0x005127e5-0x005128ad (200 code bytes)
# span:         0x005127e5-0x005128b0 (code 200, tables 0, padding 3)
# sha256:       621a6c9fec81090f6a172fc642b22fb4d1b4780087fd30fc8709e0c3bd9fc602
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005127e5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [edi + n] field_4, field_8, field_c, field_10, field_1c
# callees:      calls FUN_00512c18, FUN_00512103, FUN_00512155, FUN_0050ea90, KERNEL32.dll!InitializeCriticalSection, KERNEL32.dll!EnterCriticalSection, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00512103, .text + (0x00512103 - 0x401000)
.set FUN_00512155, .text + (0x00512155 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x005127e5 - 0x401000
.globl FUN_005127e5
FUN_005127e5:
    # block 0x005127e5: entry, 11 instruction(s), calls FUN_00512c18, ends with jle to 0x0051289f (forward)
    push ebx                                     # 005127e5
    push esi                                     # 005127e6
    push edi                                     # 005127e7
    push 0x2                                     # 005127e8
    {load} xor ebx, ebx                          # 005127ea
    {load} xor edi, edi                          # 005127ec
    call FUN_00512c18                            # 005127ee
    {load} xor esi, esi                          # 005127f3
    cmp dword ptr [0x63df00], ebx                # 005127f5
    pop ecx                                      # 005127fb
    jle.d32 L_0051289f                           # 005127fc
L_00512802:
    # block 0x00512802: entered by jl at 0x0051283c; fall-through of jle at 0x005127fc, 4 instruction(s), ends with je to 0x00512845 (forward)
    mov eax, dword ptr [0x63ceec]                # 00512802
    mov eax, dword ptr [eax + 4*esi]             # 00512807
    {load} cmp eax, ebx                          # 0051280a
    je.d8 L_00512845                             # 0051280c
    # block 0x0051280e: entered by fall-through of je at 0x0051280c, 2 instruction(s), ends with jne to 0x00512835 (forward)
    test byte ptr [eax + field_c], -0x7d         # 0051280e
    jne.d8 L_00512835                            # 00512812
    # block 0x00512814: entered by fall-through of jne at 0x00512812, 9 instruction(s), calls FUN_00512103, ends with je to 0x00512840 (forward)
    push eax                                     # 00512814
    push esi                                     # 00512815
    call FUN_00512103                            # 00512816
    pop ecx                                      # 0051281b
    pop ecx                                      # 0051281c
    mov ecx, dword ptr [0x63ceec]                # 0051281d
    mov eax, dword ptr [ecx + 4*esi]             # 00512823
    test byte ptr [eax + field_c], -0x7d         # 00512826
    je.d8 L_00512840                             # 0051282a
    # block 0x0051282c: entered by fall-through of je at 0x0051282a, 5 instruction(s), calls FUN_00512155, falls into the block at 0x00512835
    push eax                                     # 0051282c
    push esi                                     # 0051282d
    call FUN_00512155                            # 0051282e
    pop ecx                                      # 00512833
    pop ecx                                      # 00512834
L_00512835:
    # block 0x00512835: entered by jne at 0x00512812, 3 instruction(s), ends with jl to 0x00512802 (backward)
    inc esi                                      # 00512835
    cmp esi, dword ptr [0x63df00]                # 00512836
    jl.d8 L_00512802                             # 0051283c
    # block 0x0051283e: entered by fall-through of jl at 0x0051283c, 1 instruction(s), ends with forward jump to 0x0051289f
    jmp.d8 L_0051289f                            # 0051283e
L_00512840:
    # block 0x00512840: entered by je at 0x0051282a, 2 instruction(s), ends with forward jump to 0x00512889
    mov edi, dword ptr [ecx + 4*esi]             # 00512840
    jmp.d8 L_00512889                            # 00512843
L_00512845:
    # block 0x00512845: entered by je at 0x0051280c, 10 instruction(s), calls FUN_0050ea90, ends with je to 0x0051289f (forward)
    push 0x38                                    # 00512845
    shl esi, 0x2                                 # 00512847
    call FUN_0050ea90                            # 0051284a
    pop ecx                                      # 0051284f
    mov ecx, dword ptr [0x63ceec]                # 00512850
    mov dword ptr [esi + ecx], eax               # 00512856
    mov eax, dword ptr [0x63ceec]                # 00512859
    mov eax, dword ptr [esi + eax]               # 0051285e
    {load} cmp eax, ebx                          # 00512861
    je.d8 L_0051289f                             # 00512863
    # block 0x00512865: entered by fall-through of je at 0x00512863, 10 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, KERNEL32.dll!EnterCriticalSection, falls into the block at 0x00512889
    add eax, 0x20                                # 00512865
    push eax                                     # 00512868
    call dword ptr [0x52a0b4]                    # 00512869
    mov eax, dword ptr [0x63ceec]                # 0051286f
    mov eax, dword ptr [esi + eax]               # 00512874
    add eax, 0x20                                # 00512877
    push eax                                     # 0051287a
    call dword ptr [0x52a0d0]                    # 0051287b
    mov eax, dword ptr [0x63ceec]                # 00512881
    mov edi, dword ptr [esi + eax]               # 00512886
L_00512889:
    # block 0x00512889: entered by jmp at 0x00512843, 2 instruction(s), ends with je to 0x0051289f (forward)
    {load} cmp edi, ebx                          # 00512889
    je.d8 L_0051289f                             # 0051288b
    # block 0x0051288d: entered by fall-through of je at 0x0051288b, 6 instruction(s), falls into the block at 0x0051289f
    or dword ptr [edi + field_10], -0x1          # 0051288d
    mov dword ptr [edi + field_4], ebx           # 00512891
    mov dword ptr [edi + field_c], ebx           # 00512894
    mov dword ptr [edi + field_8], ebx           # 00512897
    mov dword ptr [edi], ebx                     # 0051289a
    mov dword ptr [edi + field_1c], ebx          # 0051289c
L_0051289f:
    # block 0x0051289f: entered by jle at 0x005127fc; jmp at 0x0051283e; je at 0x00512863; je at 0x0051288b, 8 instruction(s), calls FUN_00512c79, ends with ret
    push 0x2                                     # 0051289f
    call FUN_00512c79                            # 005128a1
    pop ecx                                      # 005128a6
    {load} mov eax, edi                          # 005128a7
    pop edi                                      # 005128a9
    pop esi                                      # 005128aa
    pop ebx                                      # 005128ab
    ret                                          # 005128ac

# --- data items (not part of the function) -------------------------
.org 0x005128ad - 0x401000
PAD_005128ad:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

