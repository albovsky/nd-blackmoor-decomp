# FUN_0051a3b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a3b0
# extent:       0x0051a3b0-0x0051a3d4 (36 code bytes)
# span:         0x0051a3b0-0x0051a3d4 (code 36, tables 0, padding 0)
# sha256:       efe211d83e596ca2deb29a870559b834ca09ecb60f9ec3f353e5ae9682e4fead
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a3b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [ecx + n] field_4, field_8; [edx + n] field_4
# callees:      calls FUN_0051a36e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051a36e, .text + (0x0051a36e - 0x401000)

.org 0x0051a3b0 - 0x401000
.globl FUN_0051a3b0
FUN_0051a3b0:
    # block 0x0051a3b0: entry, 7 instruction(s), ends with je to 0x0051a3c6 (forward)
    mov eax, dword ptr [ecx + field_4]           # 0051a3b0
    push esi                                     # 0051a3b3
    mov edx, dword ptr [eax]                     # 0051a3b4
    mov esi, dword ptr [eax + field_8]           # 0051a3b6
    test edx, edx                                # 0051a3b9
    mov dword ptr [ecx + field_4], edx           # 0051a3bb
    je.d8 L_0051a3c6                             # 0051a3be
    # block 0x0051a3c0: entered by fall-through of je at 0x0051a3be, 2 instruction(s), ends with forward jump to 0x0051a3ca
    and dword ptr [edx + field_4], 0x0           # 0051a3c0
    jmp.d8 L_0051a3ca                            # 0051a3c4
L_0051a3c6:
    # block 0x0051a3c6: entered by je at 0x0051a3be, 1 instruction(s), falls into the block at 0x0051a3ca
    and dword ptr [ecx + field_8], 0x0           # 0051a3c6
L_0051a3ca:
    # block 0x0051a3ca: entered by jmp at 0x0051a3c4, 5 instruction(s), calls FUN_0051a36e, ends with ret
    push eax                                     # 0051a3ca
    call FUN_0051a36e                            # 0051a3cb
    {load} mov eax, esi                          # 0051a3d0
    pop esi                                      # 0051a3d2
    ret                                          # 0051a3d3

