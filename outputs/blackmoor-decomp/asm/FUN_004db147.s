# FUN_004db147
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db147
# extent:       0x004db147-0x004db178 (49 code bytes)
# span:         0x004db147-0x004db178 (code 49, tables 0, padding 0)
# sha256:       e3ff14effc516d8aa8d9c05806e8af923bcdc4badf0ebc2b8660b66629e43c8f
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db147_lifted
# naming:       native port src/original_methods_fl41.c:m4db147_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 3 seeds; oracle: 20/20 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_1c
# callees:      calls USER32.dll!ClientToScreen, USER32.dll!SetCursorPos
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4db147_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x004db147 - 0x401000
.globl FUN_004db147
FUN_004db147:
    # block 0x004db147: entry, 20 instruction(s), calls USER32.dll!ClientToScreen, USER32.dll!SetCursorPos, ends with ret 0x8
    push ebp                                     # 004db147
    {load} mov ebp, esp                          # 004db148
    push ecx                                     # 004db14a
    mov dword ptr [ebp - local_4], ecx           # 004db14b
    mov eax, dword ptr [ebp + arg_c]             # 004db14e
    push eax                                     # 004db151
    mov ecx, dword ptr [ebp + arg_8]             # 004db152
    mov edx, dword ptr [ecx + field_1c]          # 004db155
    push edx                                     # 004db158
    call dword ptr [0x52a478]                    # 004db159
    mov eax, dword ptr [ebp + arg_c]             # 004db15f
    mov ecx, dword ptr [eax + field_4]           # 004db162
    push ecx                                     # 004db165
    mov edx, dword ptr [ebp + arg_c]             # 004db166
    mov eax, dword ptr [edx]                     # 004db169
    push eax                                     # 004db16b
    call dword ptr [0x52a488]                    # 004db16c
    {load} mov esp, ebp                          # 004db172
    pop ebp                                      # 004db174
    ret 0x8                                      # 004db175

