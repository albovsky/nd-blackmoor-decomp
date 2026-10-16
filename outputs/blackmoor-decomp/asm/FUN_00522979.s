# FUN_00522979
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522979
# extent:       0x00522979-0x0052299d (36 code bytes)
# span:         0x00522979-0x0052299d (code 36, tables 0, padding 0)
# sha256:       31fe8d051cf131a3953ee3997de13aa638522098abfdd46fa5f6ab124012b21d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522953 (+0x26)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522979
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_bc; [ecx + n] field_48; [edx + n] field_a8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0052299d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_48, 0x48  # offset +0x48
.equ field_a8, 0xa8  # offset +0xa8
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------

.org 0x00522979 - 0x401000
.globl FUN_00522979
FUN_00522979:
    # block 0x00522979: entry, 6 instruction(s), calls indirect dword ptr [eax + 0xbc], ends with je to 0x00522999 (forward)
    mov eax, dword ptr [ecx]                     # 00522979
    push esi                                     # 0052297b
    mov esi, dword ptr [ecx + field_48]          # 0052297c
    call dword ptr [eax + field_bc]              # 0052297f
    test eax, eax                                # 00522985
    je.d8 L_00522999                             # 00522987
    # block 0x00522989: entered by fall-through of je at 0x00522987, 5 instruction(s), calls indirect dword ptr [edx + 0xa8], ends with je to 0x00522999 (forward)
    mov edx, dword ptr [eax]                     # 00522989
    {load} mov ecx, eax                          # 0052298b
    call dword ptr [edx + field_a8]              # 0052298d
    test eax, eax                                # 00522993
    je.d8 L_00522999                             # 00522995
    # block 0x00522997: entered by fall-through of je at 0x00522995, 1 instruction(s), falls into the block at 0x00522999
    {load} mov esi, eax                          # 00522997
L_00522999:
    # block 0x00522999: entered by je at 0x00522987; je at 0x00522995, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 00522999
    pop esi                                      # 0052299b
    ret                                          # 0052299c

