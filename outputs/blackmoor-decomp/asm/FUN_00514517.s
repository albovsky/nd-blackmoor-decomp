# FUN_00514517
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514517
# extent:       0x00514517-0x0051453c (37 code bytes)
# span:         0x00514517-0x0051453c (code 37, tables 0, padding 0)
# sha256:       673349e0d4d6a8de9156f802cf3a259fd6fbeac487aa26646bc0be2e5413650e
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514517
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00514517 - 0x401000
.globl FUN_00514517
FUN_00514517:
    # block 0x00514517: entry, 2 instruction(s), falls into the block at 0x0051451e
    {load} xor ecx, ecx                          # 00514517
    mov eax, 0x568940                            # 00514519
L_0051451e:
    # block 0x0051451e: entered by jl at 0x0051452f, 3 instruction(s), ends with je to 0x00514534 (forward)
    mov edx, dword ptr [eax]                     # 0051451e
    cmp edx, dword ptr [esp + stk_4]             # 00514520
    je.d8 L_00514534                             # 00514524
    # block 0x00514526: entered by fall-through of je at 0x00514524, 4 instruction(s), ends with jl to 0x0051451e (backward)
    add eax, 0x8                                 # 00514526
    inc ecx                                      # 00514529
    cmp eax, 0x568a18                            # 0051452a
    jl.d8 L_0051451e                             # 0051452f
    # block 0x00514531: entered by fall-through of jl at 0x0051452f, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00514531
    ret                                          # 00514533
L_00514534:
    # block 0x00514534: entered by je at 0x00514524, 2 instruction(s), ends with ret
    mov eax, dword ptr [8*ecx + 0x568944]        # 00514534
    ret                                          # 0051453b

