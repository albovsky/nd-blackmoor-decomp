# FUN_004e29b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e29b7
# extent:       0x004e29b7-0x004e29ec (53 code bytes)
# span:         0x004e29b7-0x004e29ec (code 53, tables 0, padding 0)
# sha256:       15feca1107cc25e3ce26c8577f402519eb7d76568d77c2d0e24cb69bf51456f1
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e29b7_lifted
# naming:       native port src/original_methods_fl39d.c:m4e29b7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (39 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_30; [ecx + n] field_30; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e29b7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x004e29b7 - 0x401000
.globl FUN_004e29b7
FUN_004e29b7:
    # block 0x004e29b7: entry, 10 instruction(s), ends with je to 0x004e29dc (forward)
    push ebp                                     # 004e29b7
    {load} mov ebp, esp                          # 004e29b8
    push ecx                                     # 004e29ba
    mov dword ptr [ebp - local_4], ecx           # 004e29bb
    mov eax, dword ptr [ebp - local_4]           # 004e29be
    mov ecx, dword ptr [ebp + arg_8]             # 004e29c1
    mov dword ptr [eax + field_1c], ecx          # 004e29c4
    mov edx, dword ptr [ebp - local_4]           # 004e29c7
    cmp dword ptr [edx + field_1c], 0x0          # 004e29ca
    je.d8 L_004e29dc                             # 004e29ce
    # block 0x004e29d0: entered by fall-through of je at 0x004e29ce, 3 instruction(s), ends with forward jump to 0x004e29e6
    mov eax, dword ptr [ebp - local_4]           # 004e29d0
    mov dword ptr [eax + field_30], 0x0          # 004e29d3
    jmp.d8 L_004e29e6                            # 004e29da
L_004e29dc:
    # block 0x004e29dc: entered by je at 0x004e29ce, 2 instruction(s), falls into the block at 0x004e29e6
    mov ecx, dword ptr [ebp - local_4]           # 004e29dc
    mov dword ptr [ecx + field_30], 0x2          # 004e29df
L_004e29e6:
    # block 0x004e29e6: entered by jmp at 0x004e29da, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004e29e6
    pop ebp                                      # 004e29e8
    ret 0x4                                      # 004e29e9

