# FUN_0043edeb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043edeb
# extent:       0x0043edeb-0x0043ee2a (63 code bytes)
# span:         0x0043edeb-0x0043ee2a (code 63, tables 0, padding 0)
# sha256:       e425d5b847d01df166c43fb0432b163cd5663fb03f49aefdb7d5490e51aeee2f
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43edeb_lifted
# naming:       native port src/original_methods_fl40.c:m43edeb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 23/23 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00437cff, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43edeb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00437cff, .text + (0x00437cff - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043edeb - 0x401000
.globl FUN_0043edeb
FUN_0043edeb:
    # block 0x0043edeb: entry, 23 instruction(s), calls FUN_00437cff, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043edeb
    {load} mov ebp, esp                          # 0043edec
    sub esp, 0x10                                # 0043edee
    mov dword ptr [ebp - local_10], ecx          # 0043edf1
    lea eax, [ebp + arg_10]                      # 0043edf4
    push eax                                     # 0043edf7
    lea ecx, [ebp + arg_c]                       # 0043edf8
    push ecx                                     # 0043edfb
    lea edx, [ebp + arg_8]                       # 0043edfc
    push edx                                     # 0043edff
    mov ecx, 0x583208                            # 0043ee00
    call FUN_00437cff                            # 0043ee05
    mov eax, dword ptr [ebp + arg_10]            # 0043ee0a
    mov dword ptr [ebp - local_c], eax           # 0043ee0d
    mov ecx, dword ptr [ebp + arg_c]             # 0043ee10
    mov dword ptr [ebp - local_8], ecx           # 0043ee13
    mov edx, dword ptr [ebp + arg_8]             # 0043ee16
    mov dword ptr [ebp - local_4], edx           # 0043ee19
    mov ecx, dword ptr [ebp - local_10]          # 0043ee1c
    call FUN_0051ab4b                            # 0043ee1f
    {load} mov esp, ebp                          # 0043ee24
    pop ebp                                      # 0043ee26
    ret 0xc                                      # 0043ee27

