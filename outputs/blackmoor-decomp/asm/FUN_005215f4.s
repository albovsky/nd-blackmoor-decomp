# FUN_005215f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005215f4
# extent:       0x005215f4-0x0052160e (26 code bytes)
# span:         0x005215f4-0x0052160e (code 26, tables 0, padding 0)
# sha256:       2135c431444154a50683956581cc87a0641c34feaf186981b01038fcfeb8dd24
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005215bc (+0x38)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005215f4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_30; [ecx + n] field_80; [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0052160e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_30, 0x30  # offset +0x30
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x005215f4 - 0x401000
.globl FUN_005215f4
FUN_005215f4:
    # block 0x005215f4: entry, 3 instruction(s), ends with je to 0x00521609 (forward)
    mov ecx, dword ptr [ecx + field_80]          # 005215f4
    test ecx, ecx                                # 005215fa
    je.d8 L_00521609                             # 005215fc
    # block 0x005215fe: entered by fall-through of je at 0x005215fc, 4 instruction(s), calls indirect dword ptr [eax + 0x30], ends with forward jump to 0x0052160b
    mov eax, dword ptr [ecx]                     # 005215fe
    push dword ptr [esp + stk_4]                 # 00521600
    call dword ptr [eax + field_30]              # 00521604
    jmp.d8 L_0052160b                            # 00521607
L_00521609:
    # block 0x00521609: entered by je at 0x005215fc, 1 instruction(s), falls into the block at 0x0052160b
    {load} xor eax, eax                          # 00521609
L_0052160b:
    # block 0x0052160b: entered by jmp at 0x00521607, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0052160b

