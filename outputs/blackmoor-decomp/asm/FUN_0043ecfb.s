# FUN_0043ecfb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ecfb
# extent:       0x0043ecfb-0x0043ed36 (59 code bytes)
# span:         0x0043ecfb-0x0043ed36 (code 59, tables 0, padding 0)
# sha256:       267e5dd889c81b901ea9f9247a23a87fed1c500d06970e5b387e072b6017665b
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43ecfb_lifted
# naming:       native port src/original_methods_fl40.c:m43ecfb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 21/21 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db066, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43ecfb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.set FUN_004db066, .text + (0x004db066 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ecfb - 0x401000
.globl FUN_0043ecfb
FUN_0043ecfb:
    # block 0x0043ecfb: entry, 21 instruction(s), calls FUN_004db066, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043ecfb
    {load} mov ebp, esp                          # 0043ecfc
    sub esp, 0x10                                # 0043ecfe
    mov dword ptr [ebp - local_10], ecx          # 0043ed01
    lea eax, [ebp + arg_c]                       # 0043ed04
    push eax                                     # 0043ed07
    lea ecx, [ebp + arg_8]                       # 0043ed08
    push ecx                                     # 0043ed0b
    mov ecx, 0x5830a6                            # 0043ed0c
    call FUN_004db066                            # 0043ed11
    mov edx, dword ptr [ebp + arg_c]             # 0043ed16
    mov dword ptr [ebp - local_c], edx           # 0043ed19
    mov eax, dword ptr [ebp + arg_10]            # 0043ed1c
    mov dword ptr [ebp - local_8], eax           # 0043ed1f
    mov ecx, dword ptr [ebp + arg_8]             # 0043ed22
    mov dword ptr [ebp - local_4], ecx           # 0043ed25
    mov ecx, dword ptr [ebp - local_10]          # 0043ed28
    call FUN_0051ab4b                            # 0043ed2b
    {load} mov esp, ebp                          # 0043ed30
    pop ebp                                      # 0043ed32
    ret 0xc                                      # 0043ed33

