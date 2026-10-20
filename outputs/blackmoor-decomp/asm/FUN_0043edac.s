# FUN_0043edac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043edac
# extent:       0x0043edac-0x0043edeb (63 code bytes)
# span:         0x0043edac-0x0043edeb (code 63, tables 0, padding 0)
# sha256:       31421ae9cbd60c6f57f38d33932dab8ec4db7d404de30dfef11d7529cb270534
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43edac_default_after_query
# naming:       native port src/original_methods_fl32c.c:m43edac_default_after_query (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x437774 with pointers to its three argument slots, keeps three dead copies, returns the result of 0x51ab4b(this); dead frame stores checked on the original only; 23/23 executed.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00437774, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32c.c:m43edac_default_after_query (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00437774, .text + (0x00437774 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043edac - 0x401000
.globl FUN_0043edac
FUN_0043edac:
    # block 0x0043edac: entry, 23 instruction(s), calls FUN_00437774, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043edac
    {load} mov ebp, esp                          # 0043edad
    sub esp, 0x10                                # 0043edaf
    mov dword ptr [ebp - local_10], ecx          # 0043edb2
    lea eax, [ebp + arg_10]                      # 0043edb5
    push eax                                     # 0043edb8
    lea ecx, [ebp + arg_c]                       # 0043edb9
    push ecx                                     # 0043edbc
    lea edx, [ebp + arg_8]                       # 0043edbd
    push edx                                     # 0043edc0
    mov ecx, 0x583208                            # 0043edc1
    call FUN_00437774                            # 0043edc6
    mov eax, dword ptr [ebp + arg_10]            # 0043edcb
    mov dword ptr [ebp - local_c], eax           # 0043edce
    mov ecx, dword ptr [ebp + arg_c]             # 0043edd1
    mov dword ptr [ebp - local_8], ecx           # 0043edd4
    mov edx, dword ptr [ebp + arg_8]             # 0043edd7
    mov dword ptr [ebp - local_4], edx           # 0043edda
    mov ecx, dword ptr [ebp - local_10]          # 0043eddd
    call FUN_0051ab4b                            # 0043ede0
    {load} mov esp, ebp                          # 0043ede5
    pop ebp                                      # 0043ede7
    ret 0xc                                      # 0043ede8

