# FUN_0050d6f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d6f7
# extent:       0x0050d6f7-0x0050d775 (126 code bytes)
# span:         0x0050d6f7-0x0050d775 (code 126, tables 0, padding 0)
# sha256:       65ee25fe6842cb5789e9863270e339d309bf19dab7416f8e05e700b316913d45
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d6f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050d8aa, FUN_00510066, FUN_0050ebca, FUN_0050d8b3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d8aa, .text + (0x0050d8aa - 0x401000)
.set FUN_0050d8b3, .text + (0x0050d8b3 - 0x401000)
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)
.set FUN_00510066, .text + (0x00510066 - 0x401000)

.org 0x0050d6f7 - 0x401000
.globl FUN_0050d6f7
FUN_0050d6f7:
    # block 0x0050d6f7: entry, 12 instruction(s), calls FUN_0050d8aa, FUN_00510066, ends with jae to 0x0050d75d (forward)
    push esi                                     # 0050d6f7
    call FUN_0050d8aa                            # 0050d6f8
    push dword ptr [0x63e138]                    # 0050d6fd
    call FUN_00510066                            # 0050d703
    mov edx, dword ptr [0x63e138]                # 0050d708
    pop ecx                                      # 0050d70e
    mov ecx, dword ptr [0x63e134]                # 0050d70f
    {load} mov esi, ecx                          # 0050d715
    {load} sub esi, edx                          # 0050d717
    add esi, 0x4                                 # 0050d719
    {load} cmp eax, esi                          # 0050d71c
    jae.d8 L_0050d75d                            # 0050d71e
    # block 0x0050d720: entered by fall-through of jae at 0x0050d71e, 9 instruction(s), calls FUN_00510066, FUN_0050ebca, ends with jne to 0x0050d740 (forward)
    push edx                                     # 0050d720
    call FUN_00510066                            # 0050d721
    add eax, 0x10                                # 0050d726
    push eax                                     # 0050d729
    push dword ptr [0x63e138]                    # 0050d72a
    call FUN_0050ebca                            # 0050d730
    add esp, 0xc                                 # 0050d735
    test eax, eax                                # 0050d738
    jne.d8 L_0050d740                            # 0050d73a
    # block 0x0050d73c: entered by fall-through of jne at 0x0050d73a, 2 instruction(s), ends with forward jump to 0x0050d76c
    {load} xor esi, esi                          # 0050d73c
    jmp.d8 L_0050d76c                            # 0050d73e
L_0050d740:
    # block 0x0050d740: entered by jne at 0x0050d73a, 6 instruction(s), falls into the block at 0x0050d75d
    mov ecx, dword ptr [0x63e134]                # 0050d740
    sub ecx, dword ptr [0x63e138]                # 0050d746
    mov dword ptr [0x63e138], eax                # 0050d74c
    sar ecx, 0x2                                 # 0050d751
    lea ecx, [eax + 4*ecx]                       # 0050d754
    mov dword ptr [0x63e134], ecx                # 0050d757
L_0050d75d:
    # block 0x0050d75d: entered by jae at 0x0050d71e, 4 instruction(s), falls into the block at 0x0050d76c
    mov eax, dword ptr [esp + stk_8]             # 0050d75d
    mov dword ptr [ecx], eax                     # 0050d761
    add dword ptr [0x63e134], 0x4                # 0050d763
    {load} mov esi, eax                          # 0050d76a
L_0050d76c:
    # block 0x0050d76c: entered by jmp at 0x0050d73e, 4 instruction(s), calls FUN_0050d8b3, ends with ret
    call FUN_0050d8b3                            # 0050d76c
    {load} mov eax, esi                          # 0050d771
    pop esi                                      # 0050d773
    ret                                          # 0050d774

