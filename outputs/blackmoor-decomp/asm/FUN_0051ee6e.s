# FUN_0051ee6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ee6e
# extent:       0x0051ee6e-0x0051ee80 (18 code bytes)
# span:         0x0051ee6e-0x0051ee80 (code 18, tables 0, padding 0)
# sha256:       acc12dc6442b82658483dd09ff7b760cb4dab425a8a644949d598bab7bca4a7d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051ed8c (+0xe2)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ee6e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_24
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0051ee6e - 0x401000
.globl FUN_0051ee6e
FUN_0051ee6e:
    # block 0x0051ee6e: entry, 2 instruction(s), ends with je to 0x0051ee7f (forward)
    cmp dword ptr [ecx + field_24], 0x0          # 0051ee6e
    je.d8 L_0051ee7f                             # 0051ee72
    # block 0x0051ee74: entered by fall-through of je at 0x0051ee72, 2 instruction(s), ends with je to 0x0051ee7f (forward)
    test ecx, ecx                                # 0051ee74
    je.d8 L_0051ee7f                             # 0051ee76
    # block 0x0051ee78: entered by fall-through of je at 0x0051ee76, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051ee7f
    mov eax, dword ptr [ecx]                     # 0051ee78
    push 0x1                                     # 0051ee7a
    call dword ptr [eax + field_4]               # 0051ee7c
L_0051ee7f:
    # block 0x0051ee7f: entered by je at 0x0051ee72; je at 0x0051ee76, 1 instruction(s), ends with ret
    ret                                          # 0051ee7f

