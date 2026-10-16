# FUN_005214d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005214d5
# extent:       0x005214d5-0x005214e5 (16 code bytes)
# span:         0x005214d5-0x005214e5 (code 16, tables 0, padding 0)
# sha256:       6368faa70577cb7e58638ffdf038acaea2f64af000f2d5b7345a9e0321e74c78
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005214c9 (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005214d5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_34; [ecx + n] field_80
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005214e5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_34, 0x34  # offset +0x34
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x005214d5 - 0x401000
.globl FUN_005214d5
FUN_005214d5:
    # block 0x005214d5: entry, 3 instruction(s), ends with je to 0x005214e4 (forward)
    mov ecx, dword ptr [ecx + field_80]          # 005214d5
    test ecx, ecx                                # 005214db
    je.d8 L_005214e4                             # 005214dd
    # block 0x005214df: entered by fall-through of je at 0x005214dd, 2 instruction(s), ends with indirect jump dword ptr [eax + 0x34]
    mov eax, dword ptr [ecx]                     # 005214df
    jmp dword ptr [eax + field_34]               # 005214e1
L_005214e4:
    # block 0x005214e4: entered by je at 0x005214dd, 1 instruction(s), ends with ret
    ret                                          # 005214e4

