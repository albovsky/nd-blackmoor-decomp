# FUN_004f6810
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6810
# extent:       0x004f6810-0x004f684a (58 code bytes)
# span:         0x004f6810-0x004f684a (code 58, tables 0, padding 0)
# sha256:       cd64cda1447e8e49c78c3eaf15b4df1eb82fa324813ebca22a046a0eae71bb04
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f6810_lifted
# naming:       native port src/original_methods_fl41.c:m4f6810_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 21/21 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f6624
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4f6810_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004f6624, .text + (0x004f6624 - 0x401000)

.org 0x004f6810 - 0x401000
.globl FUN_004f6810
FUN_004f6810:
    # block 0x004f6810: entry, 6 instruction(s), ends with forward jump to 0x004f682b
    push ebp                                     # 004f6810
    {load} mov ebp, esp                          # 004f6811
    sub esp, 0x8                                 # 004f6813
    mov dword ptr [ebp - local_8], ecx           # 004f6816
    mov dword ptr [ebp - local_4], 0x0           # 004f6819
    jmp.d8 L_004f682b                            # 004f6820
L_004f6822:
    # block 0x004f6822: entered by jmp at 0x004f683f, 3 instruction(s), falls into the block at 0x004f682b
    mov eax, dword ptr [ebp - local_4]           # 004f6822
    add eax, 0x1                                 # 004f6825
    mov dword ptr [ebp - local_4], eax           # 004f6828
L_004f682b:
    # block 0x004f682b: entered by jmp at 0x004f6820, 2 instruction(s), ends with jge to 0x004f6841 (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f682b
    jge.d8 L_004f6841                            # 004f682f
    # block 0x004f6831: entered by fall-through of jge at 0x004f682f, 6 instruction(s), calls FUN_004f6624, ends with backward jump to 0x004f6822
    push 0x1                                     # 004f6831
    mov ecx, dword ptr [ebp - local_4]           # 004f6833
    push ecx                                     # 004f6836
    mov ecx, dword ptr [ebp - local_8]           # 004f6837
    call FUN_004f6624                            # 004f683a
    jmp.d8 L_004f6822                            # 004f683f
L_004f6841:
    # block 0x004f6841: entered by jge at 0x004f682f, 4 instruction(s), ends with ret
    mov eax, 0x1                                 # 004f6841
    {load} mov esp, ebp                          # 004f6846
    pop ebp                                      # 004f6848
    ret                                          # 004f6849

