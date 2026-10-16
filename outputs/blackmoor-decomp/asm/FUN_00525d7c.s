# FUN_00525d7c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525d7c
# extent:       0x00525d7c-0x00525dac (48 code bytes)
# span:         0x00525d7c-0x00525dac (code 48, tables 0, padding 0)
# sha256:       2c1af4d0b10151ba84c1efe3427ed0f82c11c3216c712f75d8807c475a79dcb8
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525d7c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00525d7c - 0x401000
.globl FUN_00525d7c
FUN_00525d7c:
    # block 0x00525d7c: entry, 2 instruction(s), ends with je to 0x00525dab (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00525d7c
    je.d8 L_00525dab                             # 00525d83
    # block 0x00525d85: entered by fall-through of je at 0x00525d83, 12 instruction(s), calls indirect esi, falls into the block at 0x00525dab
    push esi                                     # 00525d85
    mov esi, dword ptr [0x52a498]                # 00525d86
    push 0x2                                     # 00525d8c
    call esi                                     # 00525d8e
    inc eax                                      # 00525d90
    push 0x3                                     # 00525d91
    mov dword ptr [0x63c748], eax                # 00525d93
    call esi                                     # 00525d98
    inc eax                                      # 00525d9a
    mov dword ptr [0x63c7b0], 0x1                # 00525d9b
    mov dword ptr [0x63c74c], eax                # 00525da5
    pop esi                                      # 00525daa
L_00525dab:
    # block 0x00525dab: entered by je at 0x00525d83, 1 instruction(s), ends with ret
    ret                                          # 00525dab

