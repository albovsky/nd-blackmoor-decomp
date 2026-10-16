# FUN_0051ab4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ab4b
# extent:       0x0051ab4b-0x0051ab72 (39 code bytes)
# span:         0x0051ab4b-0x0051ab72 (code 39, tables 0, padding 0)
# sha256:       b91208c5ab685a525d77b3d569d058dfa03bec64ac2ceaf047c804571c4c4667
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ab4b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_38, field_3c, field_40; [edx + n] field_a0
# callees:      calls FUN_00525b0f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051ab4b - 0x401000
.globl FUN_0051ab4b
FUN_0051ab4b:
    # block 0x0051ab4b: entry, 13 instruction(s), calls FUN_00525b0f, indirect dword ptr [edx + 0xa0], ends with ret
    push esi                                     # 0051ab4b
    {load} mov esi, ecx                          # 0051ab4c
    push 0x52496c                                # 0051ab4e
    mov ecx, 0x63c444                            # 0051ab53
    call FUN_00525b0f                            # 0051ab58
    push dword ptr [eax + field_40]              # 0051ab5d
    mov edx, dword ptr [esi]                     # 0051ab60
    {load} mov ecx, esi                          # 0051ab62
    push dword ptr [eax + field_3c]              # 0051ab64
    push dword ptr [eax + field_38]              # 0051ab67
    call dword ptr [edx + field_a0]              # 0051ab6a
    pop esi                                      # 0051ab70
    ret                                          # 0051ab71

