# FUN_004c9ca0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9ca0
# extent:       0x004c9ca0-0x004c9cdd (61 code bytes)
# span:         0x004c9ca0-0x004c9cdd (code 61, tables 0, padding 0)
# sha256:       bb43c9e1d7c3123d35dbe4a586982a24694829848521b91e9bd8278459eef529
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c9ca0_lifted
# naming:       native port src/original_methods_fl41.c:m4c9ca0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 18/18 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4c9ca0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c9ca0 - 0x401000
.globl FUN_004c9ca0
FUN_004c9ca0:
    # block 0x004c9ca0: entry, 18 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with ret 0x4
    push ebp                                     # 004c9ca0
    {load} mov ebp, esp                          # 004c9ca1
    push ecx                                     # 004c9ca3
    mov dword ptr [ebp - local_4], ecx           # 004c9ca4
    mov eax, dword ptr [ebp + arg_8]             # 004c9ca7
    push eax                                     # 004c9caa
    push 0x557cbc                                # 004c9cab
    push 0x63888b                                # 004c9cb0
    call FUN_0050ca3e                            # 004c9cb5
    add esp, 0xc                                 # 004c9cba
    push 0x639897                                # 004c9cbd
    push 0x63888b                                # 004c9cc2
    push 0x557cc0                                # 004c9cc7
    push 0x557ce0                                # 004c9ccc
    call dword ptr [0x52a26c]                    # 004c9cd1
    {load} mov esp, ebp                          # 004c9cd7
    pop ebp                                      # 004c9cd9
    ret 0x4                                      # 004c9cda

