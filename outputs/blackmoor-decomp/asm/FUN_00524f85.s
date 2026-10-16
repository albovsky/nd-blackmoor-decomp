# FUN_00524f85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524f85
# extent:       0x00524f85-0x00524fbb (54 code bytes)
# span:         0x00524f85-0x00524fbb (code 54, tables 0, padding 0)
# sha256:       c673e8a039fc9afd4d30db32b173162858ea580edcc00897100ac77f441adae0
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524f85
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10, field_14; [esi + n] field_38, field_ac, field_bc
# callees:      calls FUN_00525371, FUN_00524f55; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00524fbb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_38, 0x38  # offset +0x38
.equ field_ac, 0xac  # offset +0xac
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_00524f55, .text + (0x00524f55 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00524f85 - 0x401000
.globl FUN_00524f85
FUN_00524f85:
    # block 0x00524f85: entry, 5 instruction(s), ends with je to 0x00524f98 (forward)
    push esi                                     # 00524f85
    {load} mov esi, ecx                          # 00524f86
    mov eax, dword ptr [esi + field_ac]          # 00524f88
    test eax, eax                                # 00524f8e
    je.d8 L_00524f98                             # 00524f90
    # block 0x00524f92: entered by fall-through of je at 0x00524f90, 2 instruction(s), ends with je to 0x00524faa (forward)
    cmp dword ptr [eax + field_10], 0x5          # 00524f92
    je.d8 L_00524faa                             # 00524f96
L_00524f98:
    # block 0x00524f98: entered by je at 0x00524f90; fall-through of je at 0x00524f96, 3 instruction(s), calls FUN_00525371, ends with jne to 0x00524faa (forward)
    call FUN_00525371                            # 00524f98
    cmp byte ptr [eax + field_14], 0x0           # 00524f9d
    jne.d8 L_00524faa                            # 00524fa1
    # block 0x00524fa3: entered by fall-through of jne at 0x00524fa1, 2 instruction(s), calls FUN_00524f55, falls into the block at 0x00524faa
    {load} mov ecx, esi                          # 00524fa3
    call FUN_00524f55                            # 00524fa5
L_00524faa:
    # block 0x00524faa: entered by je at 0x00524f96; jne at 0x00524fa1, 3 instruction(s), ends with je to 0x00524fb6 (forward)
    mov eax, dword ptr [esi + field_bc]          # 00524faa
    test eax, eax                                # 00524fb0
    je.d8 L_00524fb6                             # 00524fb2
    # block 0x00524fb4: entered by fall-through of je at 0x00524fb2, 1 instruction(s), calls indirect eax, falls into the block at 0x00524fb6
    call eax                                     # 00524fb4
L_00524fb6:
    # block 0x00524fb6: entered by je at 0x00524fb2, 3 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_38]          # 00524fb6
    pop esi                                      # 00524fb9
    ret                                          # 00524fba

