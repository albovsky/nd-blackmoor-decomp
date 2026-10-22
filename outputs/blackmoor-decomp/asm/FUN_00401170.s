# FUN_00401170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401170
# extent:       0x00401170-0x0040118a (26 code bytes)
# span:         0x00401170-0x00401190 (code 26, tables 0, padding 6)
# sha256:       0b0d297ae6266a8ea8d9c85d0105a4fd5e2720a8882a6ebf208319ccfb13b01b
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401170_lifted
# naming:       native port src/original_methods_fl40.c:m401170_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c
# callees:      calls USER32.dll!EnableWindow
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401170_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00401170 - 0x401000
.globl FUN_00401170
FUN_00401170:
    # block 0x00401170: entry, 12 instruction(s), calls USER32.dll!EnableWindow, ends with ret
    push ebp                                     # 00401170
    {load} mov ebp, esp                          # 00401171
    push ecx                                     # 00401173
    mov dword ptr [ebp - local_4], ecx           # 00401174
    push 0x1                                     # 00401177
    mov eax, dword ptr [ebp - local_4]           # 00401179
    mov ecx, dword ptr [eax + field_1c]          # 0040117c
    push ecx                                     # 0040117f
    call dword ptr [0x52a4d0]                    # 00401180
    {load} mov esp, ebp                          # 00401186
    pop ebp                                      # 00401188
    ret                                          # 00401189

# --- data items (not part of the function) -------------------------
.org 0x0040118a - 0x401000
PAD_0040118a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

