# FUN_004d3137
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3137
# extent:       0x004d3137-0x004d31ef (184 code bytes)
# span:         0x004d3137-0x004d31ef (code 184, tables 0, padding 0)
# sha256:       51f29a93d667e5b73f789bb9f407dcc4ed32232a9d2ef5c3f1074b46a11f25e4
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3137_lifted
# naming:       native port src/original_methods_fl41.c:m4d3137_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 9 seeds; oracle: 44/44 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee69e, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d3137_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004ee69e, .text + (0x004ee69e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004d3137 - 0x401000
.globl FUN_004d3137
FUN_004d3137:
    # block 0x004d3137: entry, 22 instruction(s), calls FUN_004ee69e, FUN_0050ce04, ends with jge to 0x004d319e (forward)
    push ebp                                     # 004d3137
    {load} mov ebp, esp                          # 004d3138
    sub esp, 0x10                                # 004d313a
    mov ecx, 0x582711                            # 004d313d
    call FUN_004ee69e                            # 004d3142
    mov dword ptr [ebp - local_4], eax           # 004d3147
    fild dword ptr [ebp - local_4]               # 004d314a
    fstp dword ptr [ebp - local_8]               # 004d314d
    fld dword ptr [ebp - local_8]                # 004d3150
    fdiv dword ptr [0x52cbec]                    # 004d3153
    fstp dword ptr [0x5b0a78]                    # 004d3159
    movsx eax, word ptr [0x5b0a7c]               # 004d315f
    mov dword ptr [ebp - local_c], eax           # 004d3166
    fild dword ptr [ebp - local_c]               # 004d3169
    fstp dword ptr [ebp - local_10]              # 004d316c
    fld dword ptr [0x5b0a78]                     # 004d316f
    fmul dword ptr [ebp - local_10]              # 004d3175
    call FUN_0050ce04                            # 004d3178
    mov dword ptr [0x5b0a82], eax                # 004d317d
    mov ecx, dword ptr [0x5b0a82]                # 004d3182
    cmp ecx, dword ptr [0x5b0a26]                # 004d3188
    jge.d8 L_004d319e                            # 004d318e
    # block 0x004d3190: entered by fall-through of jge at 0x004d318e, 3 instruction(s), ends with forward jump to 0x004d31d1
    mov edx, dword ptr [0x5b0a26]                # 004d3190
    mov dword ptr [0x5b0a82], edx                # 004d3196
    jmp.d8 L_004d31d1                            # 004d319c
L_004d319e:
    # block 0x004d319e: entered by jge at 0x004d318e, 6 instruction(s), ends with jle to 0x004d31d1 (forward)
    mov eax, dword ptr [0x5b0a1e]                # 004d319e
    sub eax, dword ptr [0x5b0a16]                # 004d31a3
    mov ecx, dword ptr [0x5b0a82]                # 004d31a9
    {load} add ecx, eax                          # 004d31af
    cmp ecx, dword ptr [0x5b0a2e]                # 004d31b1
    jle.d8 L_004d31d1                            # 004d31b7
    # block 0x004d31b9: entered by fall-through of jle at 0x004d31b7, 5 instruction(s), falls into the block at 0x004d31d1
    mov edx, dword ptr [0x5b0a1e]                # 004d31b9
    sub edx, dword ptr [0x5b0a16]                # 004d31bf
    mov eax, dword ptr [0x5b0a2e]                # 004d31c5
    {load} sub eax, edx                          # 004d31ca
    mov dword ptr [0x5b0a82], eax                # 004d31cc
L_004d31d1:
    # block 0x004d31d1: entered by jmp at 0x004d319c; jle at 0x004d31b7, 8 instruction(s), ends with ret
    mov ecx, dword ptr [0x5b0a1e]                # 004d31d1
    sub ecx, dword ptr [0x5b0a16]                # 004d31d7
    mov edx, dword ptr [0x5b0a82]                # 004d31dd
    {load} add edx, ecx                          # 004d31e3
    mov dword ptr [0x5b0a8a], edx                # 004d31e5
    {load} mov esp, ebp                          # 004d31eb
    pop ebp                                      # 004d31ed
    ret                                          # 004d31ee

