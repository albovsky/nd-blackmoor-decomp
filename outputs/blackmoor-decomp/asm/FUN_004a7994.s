# FUN_004a7994
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7994
# extent:       0x004a7994-0x004a7a19 (133 code bytes)
# span:         0x004a7994-0x004a7a19 (code 133, tables 0, padding 0)
# sha256:       05290dac71ef14c4207ba3121a47f06ab3efa6051ba2012eb5b23766fbb2e98b
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7994_lifted
# naming:       native port src/original_methods_fl39d.c:m4a7994_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (29 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a7994_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004a7994 - 0x401000
.globl FUN_004a7994
FUN_004a7994:
    # block 0x004a7994: entry, 10 instruction(s), ends with jne to 0x004a79ef (forward)
    push ebp                                     # 004a7994
    {load} mov ebp, esp                          # 004a7995
    sub esp, 0x8                                 # 004a7997
    mov dword ptr [ebp - local_8], ecx           # 004a799a
    movsx eax, word ptr [0x61d3bf]               # 004a799d
    imul eax, eax, 0x8d                          # 004a79a4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a79aa
    mov dword ptr [ebp - local_4], ecx           # 004a79b0
    cmp dword ptr [0x61d3e5], 0x0                # 004a79b3
    jne.d8 L_004a79ef                            # 004a79ba
    # block 0x004a79bc: entered by fall-through of jne at 0x004a79ba, 2 instruction(s), ends with jne to 0x004a79ef (forward)
    cmp dword ptr [0x61d3ed], 0x0                # 004a79bc
    jne.d8 L_004a79ef                            # 004a79c3
    # block 0x004a79c5: entered by fall-through of jne at 0x004a79c3, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a7a15
    push 0x550a5c                                # 004a79c5
    push 0x61d3f1                                # 004a79ca
    mov edx, dword ptr [ebp - local_4]           # 004a79cf
    add edx, 0x66                                # 004a79d2
    push edx                                     # 004a79d5
    mov eax, dword ptr [0x5cf665]                # 004a79d6
    push eax                                     # 004a79db
    mov ecx, dword ptr [0x5d15e3]                # 004a79dc
    push ecx                                     # 004a79e2
    mov ecx, 0x5cf659                            # 004a79e3
    call FUN_004c5377                            # 004a79e8
    jmp.d8 L_004a7a15                            # 004a79ed
L_004a79ef:
    # block 0x004a79ef: entered by jne at 0x004a79ba; jne at 0x004a79c3, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004a7a15
    push 0x550a78                                # 004a79ef
    push 0x61d3f1                                # 004a79f4
    push 0x61d3e1                                # 004a79f9
    mov edx, dword ptr [0x5cf665]                # 004a79fe
    push edx                                     # 004a7a04
    mov eax, dword ptr [0x61d3d1]                # 004a7a05
    push eax                                     # 004a7a0a
    mov ecx, 0x5cf659                            # 004a7a0b
    call FUN_004c5377                            # 004a7a10
L_004a7a15:
    # block 0x004a7a15: entered by jmp at 0x004a79ed, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a7a15
    pop ebp                                      # 004a7a17
    ret                                          # 004a7a18

