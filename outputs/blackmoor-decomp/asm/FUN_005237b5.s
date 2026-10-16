# FUN_005237b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005237b5
# extent:       0x005237b5-0x005237da (37 code bytes)
# span:         0x005237b5-0x005237da (code 37, tables 0, padding 0)
# sha256:       cfd78a566fb453423789ec38589fefc572b8de7d672325fda52e7a382cefd1b2
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005237b5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [edx + n] field_88
# callees:      calls FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005237da
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x005237b5 - 0x401000
.globl FUN_005237b5
FUN_005237b5:
    # block 0x005237b5: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x005237d5 (forward)
    push esi                                     # 005237b5
    {load} mov esi, ecx                          # 005237b6
    call FUN_00525371                            # 005237b8
    mov eax, dword ptr [eax + field_4]           # 005237bd
    test eax, eax                                # 005237c0
    je.d8 L_005237d5                             # 005237c2
    # block 0x005237c4: entered by fall-through of je at 0x005237c2, 2 instruction(s), ends with jne to 0x005237d5 (forward)
    cmp dword ptr [eax + field_1c], esi          # 005237c4
    jne.d8 L_005237d5                            # 005237c7
    # block 0x005237c9: entered by fall-through of jne at 0x005237c7, 5 instruction(s), calls indirect dword ptr [edx + 0x88], ends with ret
    mov edx, dword ptr [eax]                     # 005237c9
    {load} mov ecx, eax                          # 005237cb
    call dword ptr [edx + field_88]              # 005237cd
    pop esi                                      # 005237d3
    ret                                          # 005237d4
L_005237d5:
    # block 0x005237d5: entered by je at 0x005237c2; jne at 0x005237c7, 4 instruction(s), ends with ret
    push 0x1                                     # 005237d5
    pop eax                                      # 005237d7
    pop esi                                      # 005237d8
    ret                                          # 005237d9

