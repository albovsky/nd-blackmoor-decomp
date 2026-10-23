# FUN_004d46b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d46b3
# extent:       0x004d46b3-0x004d47ab (248 code bytes)
# span:         0x004d46b3-0x004d47b0 (code 248, tables 0, padding 5)
# sha256:       22dbd03a96d5ae5261e5a1f880d65bd814bf656aed1205c4e3e3a589b78962fd
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d46b3_lifted
# naming:       native port src/original_methods_fl41.c:m4d46b3_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 7 seeds; oracle: 49/49 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_2b; [edx + n] field_2d
# callees:      calls FUN_004c2dfb, FUN_004c2790
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d46b3_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 49 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004d46b3 - 0x401000
.globl FUN_004d46b3
FUN_004d46b3:
    # block 0x004d46b3: entry, 11 instruction(s), calls FUN_004c2dfb, ends with jl to 0x004d46ea (forward)
    push ebp                                     # 004d46b3
    {load} mov ebp, esp                          # 004d46b4
    push 0x5d038b                                # 004d46b6
    mov ecx, 0x5cf659                            # 004d46bb
    call FUN_004c2dfb                            # 004d46c0
    mov ax, word ptr [0x5b00e7]                  # 004d46c5
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d46cb
    mov word ptr [0x5b00e7], ax                  # 004d46cf
    movsx ecx, word ptr [0x5b00e7]               # 004d46d5
    cmp ecx, 0x1                                 # 004d46dc
    jl.d8 L_004d46ea                             # 004d46df
    # block 0x004d46e1: entered by fall-through of jl at 0x004d46df, 1 instruction(s), falls into the block at 0x004d46ea
    mov word ptr [0x5b00e7], 0x0                 # 004d46e1
L_004d46ea:
    # block 0x004d46ea: entered by jl at 0x004d46df, 37 instruction(s), calls FUN_004c2790, ends with ret
    push 0x55a584                                # 004d46ea
    push 0x6                                     # 004d46ef
    movsx edx, word ptr [0x5b00e7]               # 004d46f1
    imul edx, edx, 0x21                          # 004d46f8
    add edx, 0x5b0053                            # 004d46fb
    push edx                                     # 004d4701
    push 0x55a59c                                # 004d4702
    mov ecx, 0x5cf659                            # 004d4707
    call FUN_004c2790                            # 004d470c
    mov dword ptr [0x5d038b], eax                # 004d4711
    mov dword ptr [0x5b0084], 0x0                # 004d4716
    mov dword ptr [0x5b0088], 0x0                # 004d4720
    mov eax, dword ptr [0x5d038b]                # 004d472a
    movsx ecx, word ptr [eax + field_2b]         # 004d472f
    sub ecx, 0x1                                 # 004d4733
    mov dword ptr [0x5b008c], ecx                # 004d4736
    mov edx, dword ptr [0x5d038b]                # 004d473c
    movsx eax, word ptr [edx + field_2d]         # 004d4742
    sub eax, 0x1                                 # 004d4746
    mov dword ptr [0x5b0090], eax                # 004d4749
    mov ecx, dword ptr [0x5b00a4]                # 004d474e
    mov dword ptr [0x5b00ef], ecx                # 004d4754
    mov edx, dword ptr [0x5b00ac]                # 004d475a
    mov dword ptr [0x5b00f7], edx                # 004d4760
    mov dword ptr [0x5b00f3], 0x0                # 004d4766
    mov dword ptr [0x5b00fb], 0x1                # 004d4770
    mov eax, dword ptr [0x5b0094]                # 004d477a
    mov dword ptr [0x5b00ff], eax                # 004d477f
    mov ecx, dword ptr [0x5b009c]                # 004d4784
    mov dword ptr [0x5b0107], ecx                # 004d478a
    mov edx, dword ptr [0x5b00a0]                # 004d4790
    sub edx, 0x1                                 # 004d4796
    mov dword ptr [0x5b0103], edx                # 004d4799
    mov eax, dword ptr [0x5b00a0]                # 004d479f
    mov dword ptr [0x5b010b], eax                # 004d47a4
    pop ebp                                      # 004d47a9
    ret                                          # 004d47aa

# --- data items (not part of the function) -------------------------
.org 0x004d47ab - 0x401000
PAD_004d47ab:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

