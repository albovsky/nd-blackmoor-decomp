# FUN_004fef10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fef10
# extent:       0x004fef10-0x004fef61 (81 code bytes)
# span:         0x004fef10-0x004fef70 (code 81, tables 0, padding 15)
# sha256:       897fb21b02ba30d71daeed36d06c4fc67b61fba7062f7edaf39d2f139a23d731
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fef10
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_40, field_44, field_68; [esp + n] stk_8
# callees:      calls FUN_0050bc20, FUN_004feea0, FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_004feea0, .text + (0x004feea0 - 0x401000)
.set FUN_0050bc20, .text + (0x0050bc20 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004fef10 - 0x401000
.globl FUN_004fef10
FUN_004fef10:
    # block 0x004fef10: entry, 5 instruction(s), ends with je to 0x004fef2d (forward)
    push edi                                     # 004fef10
    mov edi, dword ptr [esp + stk_8]             # 004fef11
    mov eax, dword ptr [edi + field_40]          # 004fef15
    test eax, eax                                # 004fef18
    je.d8 L_004fef2d                             # 004fef1a
    # block 0x004fef1c: entered by fall-through of je at 0x004fef1a, 2 instruction(s), ends with je to 0x004fef2d (forward)
    cmp dword ptr [eax], 0x0                     # 004fef1c
    je.d8 L_004fef2d                             # 004fef1f
    # block 0x004fef21: entered by fall-through of je at 0x004fef1f, 4 instruction(s), calls FUN_0050bc20, falls into the block at 0x004fef2d
    lea eax, [edi + field_4]                     # 004fef21
    push eax                                     # 004fef24
    call FUN_0050bc20                            # 004fef25
    add esp, 0x4                                 # 004fef2a
L_004fef2d:
    # block 0x004fef2d: entered by je at 0x004fef1a; je at 0x004fef1f, 6 instruction(s), calls FUN_004feea0, ends with je to 0x004fef46 (forward)
    push edi                                     # 004fef2d
    call FUN_004feea0                            # 004fef2e
    mov eax, dword ptr [edi + field_44]          # 004fef33
    add esp, 0x4                                 # 004fef36
    test eax, eax                                # 004fef39
    je.d8 L_004fef46                             # 004fef3b
    # block 0x004fef3d: entered by fall-through of je at 0x004fef3b, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fef46
    push eax                                     # 004fef3d
    call FUN_0050e936                            # 004fef3e
    add esp, 0x4                                 # 004fef43
L_004fef46:
    # block 0x004fef46: entered by je at 0x004fef3b, 3 instruction(s), ends with je to 0x004fef56 (forward)
    mov eax, dword ptr [edi + field_68]          # 004fef46
    test eax, eax                                # 004fef49
    je.d8 L_004fef56                             # 004fef4b
    # block 0x004fef4d: entered by fall-through of je at 0x004fef4b, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fef56
    push eax                                     # 004fef4d
    call FUN_0050e936                            # 004fef4e
    add esp, 0x4                                 # 004fef53
L_004fef56:
    # block 0x004fef56: entered by je at 0x004fef4b, 5 instruction(s), ends with ret
    mov ecx, 0x1b                                # 004fef56
    {load} xor eax, eax                          # 004fef5b
    rep stosd dword ptr es:[edi], eax            # 004fef5d
    pop edi                                      # 004fef5f
    ret                                          # 004fef60

# --- data items (not part of the function) -------------------------
.org 0x004fef61 - 0x401000
PAD_004fef61:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

