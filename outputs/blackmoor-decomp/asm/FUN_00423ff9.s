# FUN_00423ff9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423ff9
# extent:       0x00423ff9-0x00424035 (60 code bytes)
# span:         0x00423ff9-0x00424035 (code 60, tables 0, padding 0)
# sha256:       d3a832322b5d4532f5002aa795906802af9d85200e1c2622b2f6fad37a07c1e7
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423ff9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20; [ecx + n] field_20; [edx + n] field_12, field_40
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m423ff9_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_12, 0x12  # offset +0x12
.equ field_20, 0x20  # offset +0x20
.equ field_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------

.org 0x00423ff9 - 0x401000
.globl FUN_00423ff9
FUN_00423ff9:
    # block 0x00423ff9: entry, 7 instruction(s), ends with jne to 0x00424010 (forward)
    push ebp                                     # 00423ff9
    {load} mov ebp, esp                          # 00423ffa
    sub esp, 0x8                                 # 00423ffc
    mov dword ptr [ebp - local_8], ecx           # 00423fff
    mov eax, dword ptr [ebp + arg_8]             # 00424002
    cmp dword ptr [eax + field_20], 0x0          # 00424005
    jne.d8 L_00424010                            # 00424009
    # block 0x0042400b: entered by fall-through of jne at 0x00424009, 2 instruction(s), ends with forward jump to 0x0042402f
    or eax, -0x1                                 # 0042400b
    jmp.d8 L_0042402f                            # 0042400e
L_00424010:
    # block 0x00424010: entered by jne at 0x00424009, 10 instruction(s), falls into the block at 0x0042402f
    mov ecx, dword ptr [ebp + arg_8]             # 00424010
    mov edx, dword ptr [ecx + field_20]          # 00424013
    movsx eax, word ptr [edx + field_12]         # 00424016
    mov dword ptr [ebp - local_4], eax           # 0042401a
    mov ecx, dword ptr [ebp + arg_8]             # 0042401d
    mov edx, dword ptr [ecx + field_20]          # 00424020
    mov eax, dword ptr [ebp + arg_8]             # 00424023
    mov ecx, dword ptr [edx + field_40]          # 00424026
    mov dword ptr [eax + field_20], ecx          # 00424029
    mov eax, dword ptr [ebp - local_4]           # 0042402c
L_0042402f:
    # block 0x0042402f: entered by jmp at 0x0042400e, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0042402f
    pop ebp                                      # 00424031
    ret 0x4                                      # 00424032

