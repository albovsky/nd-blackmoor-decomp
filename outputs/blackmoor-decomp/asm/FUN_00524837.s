# FUN_00524837
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524837
# extent:       0x00524837-0x00524861 (42 code bytes)
# span:         0x00524837-0x00524861 (code 42, tables 0, padding 0)
# sha256:       4fd16d1596d6fc2491a6ab6033719fc8b5440a893a7f14c8ef4df20670b9fd12
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524837
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_78, field_d0; [esi + n] field_70, field_78
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_70, 0x70  # offset +0x70
.equ field_78, 0x78  # offset +0x78
.equ field_d0, 0xd0  # offset +0xd0

# --- external targets -----------------------------------------------

.org 0x00524837 - 0x401000
.globl FUN_00524837
FUN_00524837:
    # block 0x00524837: entry, 6 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with je to 0x0052484b (forward)
    push esi                                     # 00524837
    {load} mov esi, ecx                          # 00524838
    mov eax, dword ptr [esi]                     # 0052483a
    call dword ptr [eax + field_d0]              # 0052483c
    test eax, eax                                # 00524842
    je.d8 L_0052484b                             # 00524844
    # block 0x00524846: entered by fall-through of je at 0x00524844, 3 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_78]          # 00524846
    pop esi                                      # 00524849
    ret                                          # 0052484a
L_0052484b:
    # block 0x0052484b: entered by je at 0x00524844, 3 instruction(s), ends with je to 0x0052485d (forward)
    mov eax, dword ptr [esi + field_70]          # 0052484b
    test eax, eax                                # 0052484e
    je.d8 L_0052485d                             # 00524850
    # block 0x00524852: entered by fall-through of je at 0x00524850, 2 instruction(s), ends with je to 0x0052485d (forward)
    cmp dword ptr [eax + field_78], 0x0          # 00524852
    je.d8 L_0052485d                             # 00524856
    # block 0x00524858: entered by fall-through of je at 0x00524856, 4 instruction(s), ends with ret
    push 0x1                                     # 00524858
    pop eax                                      # 0052485a
    pop esi                                      # 0052485b
    ret                                          # 0052485c
L_0052485d:
    # block 0x0052485d: entered by je at 0x00524850; je at 0x00524856, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0052485d
    pop esi                                      # 0052485f
    ret                                          # 00524860

