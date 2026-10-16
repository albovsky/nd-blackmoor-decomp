# FUN_00512018
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512018
# extent:       0x00512018-0x005120c0 (168 code bytes)
# span:         0x00512018-0x005120c0 (code 168, tables 0, padding 0)
# sha256:       42dcda7dcd409ce633e49c7025226e5fb75bbce4b4edea8426390402c1772a84
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00511fab (+0x6d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512018
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050e97e, FUN_0050e8ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005120c0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x00512018 - 0x401000
.globl FUN_00512018
FUN_00512018:
    # block 0x00512018: entry, 6 instruction(s), ends with jne to 0x0051202c (forward)
    mov eax, dword ptr [0x63df00]                # 00512018
    push esi                                     # 0051201d
    push 0x14                                    # 0051201e
    test eax, eax                                # 00512020
    pop esi                                      # 00512022
    jne.d8 L_0051202c                            # 00512023
    # block 0x00512025: entered by fall-through of jne at 0x00512023, 2 instruction(s), ends with forward jump to 0x00512032
    mov eax, 0x200                               # 00512025
    jmp.d8 L_00512032                            # 0051202a
L_0051202c:
    # block 0x0051202c: entered by jne at 0x00512023, 2 instruction(s), ends with jge to 0x00512037 (forward)
    {load} cmp eax, esi                          # 0051202c
    jge.d8 L_00512037                            # 0051202e
    # block 0x00512030: entered by fall-through of jge at 0x0051202e, 1 instruction(s), falls into the block at 0x00512032
    {load} mov eax, esi                          # 00512030
L_00512032:
    # block 0x00512032: entered by jmp at 0x0051202a, 1 instruction(s), falls into the block at 0x00512037
    mov dword ptr [0x63df00], eax                # 00512032
L_00512037:
    # block 0x00512037: entered by jge at 0x0051202e, 8 instruction(s), calls FUN_0050e97e, ends with jne to 0x0051206b (forward)
    push 0x4                                     # 00512037
    push eax                                     # 00512039
    call FUN_0050e97e                            # 0051203a
    pop ecx                                      # 0051203f
    mov dword ptr [0x63ceec], eax                # 00512040
    test eax, eax                                # 00512045
    pop ecx                                      # 00512047
    jne.d8 L_0051206b                            # 00512048
    # block 0x0051204a: entered by fall-through of jne at 0x00512048, 9 instruction(s), calls FUN_0050e97e, ends with jne to 0x0051206b (forward)
    push 0x4                                     # 0051204a
    push esi                                     # 0051204c
    mov dword ptr [0x63df00], esi                # 0051204d
    call FUN_0050e97e                            # 00512053
    pop ecx                                      # 00512058
    mov dword ptr [0x63ceec], eax                # 00512059
    test eax, eax                                # 0051205e
    pop ecx                                      # 00512060
    jne.d8 L_0051206b                            # 00512061
    # block 0x00512063: entered by fall-through of jne at 0x00512061, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x0051206b
    push 0x1a                                    # 00512063
    call FUN_0050e8ed                            # 00512065
    pop ecx                                      # 0051206a
L_0051206b:
    # block 0x0051206b: entered by jne at 0x00512048; jne at 0x00512061, 2 instruction(s), falls into the block at 0x00512072
    {load} xor ecx, ecx                          # 0051206b
    mov eax, 0x568430                            # 0051206d
L_00512072:
    # block 0x00512072: entered by jl at 0x00512086, 6 instruction(s), ends with jl to 0x00512072 (backward)
    mov edx, dword ptr [0x63ceec]                # 00512072
    mov dword ptr [ecx + edx], eax               # 00512078
    add eax, 0x20                                # 0051207b
    add ecx, 0x4                                 # 0051207e
    cmp eax, 0x5686b0                            # 00512081
    jl.d8 L_00512072                             # 00512086
    # block 0x00512088: entered by fall-through of jl at 0x00512086, 2 instruction(s), falls into the block at 0x0051208f
    {load} xor ecx, ecx                          # 00512088
    mov edx, 0x568440                            # 0051208a
L_0051208f:
    # block 0x0051208f: entered by jl at 0x005120bc, 9 instruction(s), ends with je to 0x005120af (forward)
    {load} mov esi, ecx                          # 0051208f
    {load} mov eax, ecx                          # 00512091
    sar esi, 0x5                                 # 00512093
    and eax, 0x1f                                # 00512096
    mov esi, dword ptr [4*esi + 0x63cde0]        # 00512099
    lea eax, [eax + 8*eax]                       # 005120a0
    mov eax, dword ptr [esi + 4*eax]             # 005120a3
    cmp eax, -0x1                                # 005120a6
    je.d8 L_005120af                             # 005120a9
    # block 0x005120ab: entered by fall-through of je at 0x005120a9, 2 instruction(s), ends with jne to 0x005120b2 (forward)
    test eax, eax                                # 005120ab
    jne.d8 L_005120b2                            # 005120ad
L_005120af:
    # block 0x005120af: entered by je at 0x005120a9; fall-through of jne at 0x005120ad, 1 instruction(s), falls into the block at 0x005120b2
    or dword ptr [edx], -0x1                     # 005120af
L_005120b2:
    # block 0x005120b2: entered by jne at 0x005120ad, 4 instruction(s), ends with jl to 0x0051208f (backward)
    add edx, 0x20                                # 005120b2
    inc ecx                                      # 005120b5
    cmp edx, 0x5684a0                            # 005120b6
    jl.d8 L_0051208f                             # 005120bc
    # block 0x005120be: entered by fall-through of jl at 0x005120bc, 2 instruction(s), ends with ret
    pop esi                                      # 005120be
    ret                                          # 005120bf

