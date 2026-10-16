# FUN_00514d5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514d5d
# extent:       0x00514d5d-0x00514d99 (60 code bytes)
# span:         0x00514d5d-0x00514d99 (code 60, tables 0, padding 0)
# sha256:       b3a42d82432bb8bab3179536c8bbb5586cc3090c8160b98c7778c658077b4843
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514d5d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls KERNEL32.dll!HeapCreate, FUN_00514f25, KERNEL32.dll!HeapDestroy
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00514f25, .text + (0x00514f25 - 0x401000)

.org 0x00514d5d - 0x401000
.globl FUN_00514d5d
FUN_00514d5d:
    # block 0x00514d5d: entry, 10 instruction(s), calls KERNEL32.dll!HeapCreate, ends with je to 0x00514d92 (forward)
    {load} xor eax, eax                          # 00514d5d
    push 0x0                                     # 00514d5f
    cmp dword ptr [esp + stk_8], eax             # 00514d61
    push 0x1000                                  # 00514d65
    sete al                                      # 00514d6a
    push eax                                     # 00514d6d
    call dword ptr [0x52a198]                    # 00514d6e
    test eax, eax                                # 00514d74
    mov dword ptr [0x63cdd8], eax                # 00514d76
    je.d8 L_00514d92                             # 00514d7b
    # block 0x00514d7d: entered by fall-through of je at 0x00514d7b, 3 instruction(s), calls FUN_00514f25, ends with jne to 0x00514d95 (forward)
    call FUN_00514f25                            # 00514d7d
    test eax, eax                                # 00514d82
    jne.d8 L_00514d95                            # 00514d84
    # block 0x00514d86: entered by fall-through of jne at 0x00514d84, 2 instruction(s), calls KERNEL32.dll!HeapDestroy, falls into the block at 0x00514d92
    push dword ptr [0x63cdd8]                    # 00514d86
    call dword ptr [0x52a194]                    # 00514d8c
L_00514d92:
    # block 0x00514d92: entered by je at 0x00514d7b, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00514d92
    ret                                          # 00514d94
L_00514d95:
    # block 0x00514d95: entered by jne at 0x00514d84, 3 instruction(s), ends with ret
    push 0x1                                     # 00514d95
    pop eax                                      # 00514d97
    ret                                          # 00514d98

