# FUN_00425fc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00425fc0
# extent:       0x00425fc0-0x00426063 (163 code bytes)
# span:         0x00425fc0-0x00426063 (code 163, tables 0, padding 0)
# sha256:       1c7a1bdeb47dfcc727304caa508e78b629e43db48fb81b8677925999c254202b
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m425fc0_lifted
# naming:       native port src/original_methods_fl40.c:m425fc0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 37/37 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c92c5, FUN_004c5377, FUN_004c4c2b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m425fc0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c4c2b, .text + (0x004c4c2b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)

.org 0x00425fc0 - 0x401000
.globl FUN_00425fc0
FUN_00425fc0:
    # block 0x00425fc0: entry, 10 instruction(s), calls FUN_004c92c5, ends with je to 0x00426061 (forward)
    push ebp                                     # 00425fc0
    {load} mov ebp, esp                          # 00425fc1
    mov ax, word ptr [0x5b0266]                  # 00425fc3
    push eax                                     # 00425fc9
    mov ecx, 0x5cf659                            # 00425fca
    call FUN_004c92c5                            # 00425fcf
    mov byte ptr [0x58320d], 0x0                 # 00425fd4
    mov dword ptr [0x5d1761], 0x0                # 00425fdb
    cmp dword ptr [0x5bb1f2], 0x0                # 00425fe5
    je.d8 L_00426061                             # 00425fec
    # block 0x00425fee: entered by fall-through of je at 0x00425fec, 2 instruction(s), ends with jne to 0x00426061 (forward)
    cmp dword ptr [0x583981], 0xe                # 00425fee
    jne.d8 L_00426061                            # 00425ff5
    # block 0x00425ff7: entered by fall-through of jne at 0x00425ff5, 2 instruction(s), ends with jne to 0x00426061 (forward)
    cmp dword ptr [0x583999], 0x3                # 00425ff7
    jne.d8 L_00426061                            # 00425ffe
    # block 0x00426000: entered by fall-through of jne at 0x00425ffe, 21 instruction(s), calls FUN_004c5377, FUN_004c4c2b, falls into the block at 0x00426061
    push 0x545340                                # 00426000
    push 0x5bb1ea                                # 00426005
    push 0x5bb1ea                                # 0042600a
    mov ecx, dword ptr [0x5cf665]                # 0042600f
    push ecx                                     # 00426015
    mov edx, dword ptr [0x570c57]                # 00426016
    push edx                                     # 0042601c
    mov ecx, 0x5cf659                            # 0042601d
    call FUN_004c5377                            # 00426022
    mov ecx, 0x5cf659                            # 00426027
    call FUN_004c4c2b                            # 0042602c
    push 0x54534c                                # 00426031
    push 0x5bb1ea                                # 00426036
    push 0x5bb1ea                                # 0042603b
    mov eax, dword ptr [0x5cf665]                # 00426040
    push eax                                     # 00426045
    mov ecx, dword ptr [0x570c57]                # 00426046
    push ecx                                     # 0042604c
    mov ecx, 0x5cf659                            # 0042604d
    call FUN_004c5377                            # 00426052
    mov dword ptr [0x5bb1f2], 0x0                # 00426057
L_00426061:
    # block 0x00426061: entered by je at 0x00425fec; jne at 0x00425ff5; jne at 0x00425ffe, 2 instruction(s), ends with ret
    pop ebp                                      # 00426061
    ret                                          # 00426062

