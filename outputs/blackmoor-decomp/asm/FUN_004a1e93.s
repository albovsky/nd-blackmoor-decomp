# FUN_004a1e93
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1e93
# extent:       0x004a1e93-0x004a1efd (106 code bytes)
# span:         0x004a1e93-0x004a1efd (code 106, tables 0, padding 0)
# sha256:       a5ef57e432d45f12cd65b07a69a4fb6ec9694f04a58b70f42c0d5c918ff51728
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1e93_lifted
# naming:       native port src/original_methods_fl41.c:m4a1e93_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 22/22 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a1e93_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004a1e93 - 0x401000
.globl FUN_004a1e93
FUN_004a1e93:
    # block 0x004a1e93: entry, 7 instruction(s), ends with jne to 0x004a1ef7 (forward)
    push ebp                                     # 004a1e93
    {load} mov ebp, esp                          # 004a1e94
    push ecx                                     # 004a1e96
    mov dword ptr [ebp - local_4], ecx           # 004a1e97
    movsx eax, word ptr [ebp + arg_8]            # 004a1e9a
    cmp eax, 0x2760                              # 004a1e9e
    jne.d8 L_004a1ef7                            # 004a1ea3
    # block 0x004a1ea5: entered by fall-through of jne at 0x004a1ea3, 12 instruction(s), falls into the block at 0x004a1ef7
    mov dword ptr [0x5b44f0], 0x9                # 004a1ea5
    mov ecx, dword ptr [0x5d0377]                # 004a1eaf
    mov dword ptr [0x5d162d], ecx                # 004a1eb5
    mov dword ptr [0x5b44f4], 0x1                # 004a1ebb
    mov edx, dword ptr [0x5b44f0]                # 004a1ec5
    shl edx, 0x5                                 # 004a1ecb
    mov eax, dword ptr [0x5b44f4]                # 004a1ece
    shl eax, 0x4                                 # 004a1ed3
    lea ecx, [edx + eax + 0x5b160c]              # 004a1ed6
    mov dword ptr [0x5d1631], ecx                # 004a1edd
    mov dword ptr [0x5d1639], 0x1                # 004a1ee3
    mov dword ptr [0x5c39e5], 0x2760             # 004a1eed
L_004a1ef7:
    # block 0x004a1ef7: entered by jne at 0x004a1ea3, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004a1ef7
    pop ebp                                      # 004a1ef9
    ret 0x4                                      # 004a1efa

