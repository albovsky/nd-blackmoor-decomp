# FUN_0050c193
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c193
# extent:       0x0050c193-0x0050c1a7 (20 code bytes)
# span:         0x0050c193-0x0050c1a7 (code 20, tables 0, padding 0)
# sha256:       5c45f5ebd11ec8e03f9b2b1dfad90fdc27e4d4098b51791d3bd12e91d1250913
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c193
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_74
# callees:      calls FUN_0051ec6f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)

.org 0x0050c193 - 0x401000
.globl FUN_0050c193
FUN_0050c193:
    # block 0x0050c193: entry, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0050c1a4 (forward)
    call FUN_0051ec6f                            # 0050c193
    test eax, eax                                # 0050c198
    je.d8 L_0050c1a4                             # 0050c19a
    # block 0x0050c19c: entered by fall-through of je at 0x0050c19a, 4 instruction(s), calls indirect dword ptr [edx + 0x74], ends with ret
    mov edx, dword ptr [eax]                     # 0050c19c
    {load} mov ecx, eax                          # 0050c19e
    call dword ptr [edx + field_74]              # 0050c1a0
    ret                                          # 0050c1a3
L_0050c1a4:
    # block 0x0050c1a4: entered by je at 0x0050c19a, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050c1a4
    ret                                          # 0050c1a6

