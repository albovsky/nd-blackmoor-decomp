# FUN_0043ee2a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ee2a
# extent:       0x0043ee2a-0x0043ee69 (63 code bytes)
# span:         0x0043ee2a-0x0043ee69 (code 63, tables 0, padding 0)
# sha256:       bd4443e14df0be4c3ea29b10fa860b75ab1e8999bc8d09c385e0678c402ea175
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43ee2a_lifted
# naming:       native port src/original_methods_fl40.c:m43ee2a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 23/23 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00437dcd, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43ee2a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00437dcd, .text + (0x00437dcd - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ee2a - 0x401000
.globl FUN_0043ee2a
FUN_0043ee2a:
    # block 0x0043ee2a: entry, 23 instruction(s), calls FUN_00437dcd, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043ee2a
    {load} mov ebp, esp                          # 0043ee2b
    sub esp, 0x10                                # 0043ee2d
    mov dword ptr [ebp - local_10], ecx          # 0043ee30
    lea eax, [ebp + arg_10]                      # 0043ee33
    push eax                                     # 0043ee36
    lea ecx, [ebp + arg_c]                       # 0043ee37
    push ecx                                     # 0043ee3a
    lea edx, [ebp + arg_8]                       # 0043ee3b
    push edx                                     # 0043ee3e
    mov ecx, 0x583208                            # 0043ee3f
    call FUN_00437dcd                            # 0043ee44
    mov eax, dword ptr [ebp + arg_10]            # 0043ee49
    mov dword ptr [ebp - local_c], eax           # 0043ee4c
    mov ecx, dword ptr [ebp + arg_c]             # 0043ee4f
    mov dword ptr [ebp - local_8], ecx           # 0043ee52
    mov edx, dword ptr [ebp + arg_8]             # 0043ee55
    mov dword ptr [ebp - local_4], edx           # 0043ee58
    mov ecx, dword ptr [ebp - local_10]          # 0043ee5b
    call FUN_0051ab4b                            # 0043ee5e
    {load} mov esp, ebp                          # 0043ee63
    pop ebp                                      # 0043ee65
    ret 0xc                                      # 0043ee66

