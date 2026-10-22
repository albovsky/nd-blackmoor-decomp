# FUN_004e8994
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8994
# extent:       0x004e8994-0x004e89b9 (37 code bytes)
# span:         0x004e8994-0x004e89b9 (code 37, tables 0, padding 0)
# sha256:       21737181af23b834ab5dcdf0c25ab12fc947c5ccb4d2706c7c27af1fd9628172
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e8994_set_field_forward
# naming:       native port src/original_methods_fl39c.c:m4e8994_set_field_forward (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the stack argument in dword [self+0x7650] and returns 0x4edf96(this = self, argument); pops 4 bytes. No jumps; all 14 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7650
# callees:      calls FUN_004edf96
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4e8994_set_field_forward (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_7650, 0x7650  # offset +0x7650

# --- external targets -----------------------------------------------
.set FUN_004edf96, .text + (0x004edf96 - 0x401000)

.org 0x004e8994 - 0x401000
.globl FUN_004e8994
FUN_004e8994:
    # block 0x004e8994: entry, 14 instruction(s), calls FUN_004edf96, ends with ret 0x4
    push ebp                                     # 004e8994
    {load} mov ebp, esp                          # 004e8995
    push ecx                                     # 004e8997
    mov dword ptr [ebp - local_4], ecx           # 004e8998
    mov eax, dword ptr [ebp - local_4]           # 004e899b
    mov ecx, dword ptr [ebp + arg_8]             # 004e899e
    mov dword ptr [eax + field_7650], ecx        # 004e89a1
    mov edx, dword ptr [ebp + arg_8]             # 004e89a7
    push edx                                     # 004e89aa
    mov ecx, dword ptr [ebp - local_4]           # 004e89ab
    call FUN_004edf96                            # 004e89ae
    {load} mov esp, ebp                          # 004e89b3
    pop ebp                                      # 004e89b5
    ret 0x4                                      # 004e89b6

