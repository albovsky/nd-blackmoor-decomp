# FUN_0045445a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045445a
# extent:       0x0045445a-0x00454565 (267 code bytes)
# span:         0x0045445a-0x00454565 (code 267, tables 0, padding 0)
# sha256:       6943f015d60e68afd23ea23409910438759e3879d6e17509f1ddacfbc099bf3a
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45445a_lifted
# naming:       native port src/original_methods_fl40.c:m45445a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 18 seeds; oracle 83/83 instructions, 20/20 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00454565
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45445a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 83 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00454565, .text + (0x00454565 - 0x401000)

.org 0x0045445a - 0x401000
.globl FUN_0045445a
FUN_0045445a:
    # block 0x0045445a: entry, 46 instruction(s), calls FUN_00454565, ends with je to 0x004544f3 (forward)
    push ebp                                     # 0045445a
    {load} mov ebp, esp                          # 0045445b
    sub esp, 0x30                                # 0045445d
    mov dword ptr [ebp - local_2c], ecx          # 00454460
    mov dword ptr [ebp - local_10], 0x0          # 00454463
    mov dword ptr [ebp - local_c], 0x0           # 0045446a
    mov dword ptr [ebp - local_18], 0x0          # 00454471
    mov dword ptr [ebp - local_24], 0x0          # 00454478
    mov eax, dword ptr [ebp + arg_10]            # 0045447f
    push eax                                     # 00454482
    mov ecx, dword ptr [ebp + arg_c]             # 00454483
    push ecx                                     # 00454486
    mov edx, dword ptr [ebp + arg_8]             # 00454487
    push edx                                     # 0045448a
    mov ecx, dword ptr [ebp - local_2c]          # 0045448b
    call FUN_00454565                            # 0045448e
    mov dword ptr [ebp - local_4], eax           # 00454493
    mov eax, dword ptr [ebp + arg_14]            # 00454496
    push eax                                     # 00454499
    mov ecx, dword ptr [ebp + arg_c]             # 0045449a
    push ecx                                     # 0045449d
    mov edx, dword ptr [ebp + arg_8]             # 0045449e
    push edx                                     # 004544a1
    mov ecx, dword ptr [ebp - local_2c]          # 004544a2
    call FUN_00454565                            # 004544a5
    mov dword ptr [ebp - local_8], eax           # 004544aa
    mov eax, dword ptr [ebp + arg_8]             # 004544ad
    push eax                                     # 004544b0
    mov ecx, dword ptr [ebp + arg_14]            # 004544b1
    push ecx                                     # 004544b4
    mov edx, dword ptr [ebp + arg_10]            # 004544b5
    push edx                                     # 004544b8
    mov ecx, dword ptr [ebp - local_2c]          # 004544b9
    call FUN_00454565                            # 004544bc
    mov dword ptr [ebp - local_28], eax          # 004544c1
    mov eax, dword ptr [ebp + arg_c]             # 004544c4
    push eax                                     # 004544c7
    mov ecx, dword ptr [ebp + arg_14]            # 004544c8
    push ecx                                     # 004544cb
    mov edx, dword ptr [ebp + arg_10]            # 004544cc
    push edx                                     # 004544cf
    mov ecx, dword ptr [ebp - local_2c]          # 004544d0
    call FUN_00454565                            # 004544d3
    mov dword ptr [ebp - local_14], eax          # 004544d8
    cmp dword ptr [ebp - local_4], 0x0           # 004544db
    je.d8 L_004544f3                             # 004544df
    # block 0x004544e1: entered by fall-through of je at 0x004544df, 2 instruction(s), ends with je to 0x004544f3 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004544e1
    je.d8 L_004544f3                             # 004544e5
    # block 0x004544e7: entered by fall-through of je at 0x004544e5, 2 instruction(s), ends with je to 0x004544f3 (forward)
    cmp dword ptr [ebp - local_28], 0x0          # 004544e7
    je.d8 L_004544f3                             # 004544eb
    # block 0x004544ed: entered by fall-through of je at 0x004544eb, 2 instruction(s), ends with jne to 0x004544fa (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 004544ed
    jne.d8 L_004544fa                            # 004544f1
L_004544f3:
    # block 0x004544f3: entered by je at 0x004544df; je at 0x004544e5; je at 0x004544eb; fall-through of jne at 0x004544f1, 2 instruction(s), ends with forward jump to 0x0045455f
    mov eax, 0x1                                 # 004544f3
    jmp.d8 L_0045455f                            # 004544f8
L_004544fa:
    # block 0x004544fa: entered by jne at 0x004544f1, 2 instruction(s), ends with jle to 0x00454507 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004544fa
    jle.d8 L_00454507                            # 004544fe
    # block 0x00454500: entered by fall-through of jle at 0x004544fe, 1 instruction(s), falls into the block at 0x00454507
    mov dword ptr [ebp - local_10], 0x1          # 00454500
L_00454507:
    # block 0x00454507: entered by jle at 0x004544fe, 2 instruction(s), ends with jle to 0x00454514 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00454507
    jle.d8 L_00454514                            # 0045450b
    # block 0x0045450d: entered by fall-through of jle at 0x0045450b, 1 instruction(s), falls into the block at 0x00454514
    mov dword ptr [ebp - local_c], 0x1           # 0045450d
L_00454514:
    # block 0x00454514: entered by jle at 0x0045450b, 2 instruction(s), ends with jle to 0x00454521 (forward)
    cmp dword ptr [ebp - local_28], 0x0          # 00454514
    jle.d8 L_00454521                            # 00454518
    # block 0x0045451a: entered by fall-through of jle at 0x00454518, 1 instruction(s), falls into the block at 0x00454521
    mov dword ptr [ebp - local_18], 0x1          # 0045451a
L_00454521:
    # block 0x00454521: entered by jle at 0x00454518, 2 instruction(s), ends with jle to 0x0045452e (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 00454521
    jle.d8 L_0045452e                            # 00454525
    # block 0x00454527: entered by fall-through of jle at 0x00454525, 1 instruction(s), falls into the block at 0x0045452e
    mov dword ptr [ebp - local_24], 0x1          # 00454527
L_0045452e:
    # block 0x0045452e: entered by jle at 0x00454525, 8 instruction(s), ends with je to 0x00454555 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045452e
    xor eax, dword ptr [ebp - local_c]           # 00454531
    mov dword ptr [ebp - local_1c], eax          # 00454534
    mov ecx, dword ptr [ebp - local_18]          # 00454537
    xor ecx, dword ptr [ebp - local_24]          # 0045453a
    mov dword ptr [ebp - local_20], ecx          # 0045453d
    cmp dword ptr [ebp - local_1c], 0x0          # 00454540
    je.d8 L_00454555                             # 00454544
    # block 0x00454546: entered by fall-through of je at 0x00454544, 2 instruction(s), ends with je to 0x00454555 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 00454546
    je.d8 L_00454555                             # 0045454a
    # block 0x0045454c: entered by fall-through of je at 0x0045454a, 2 instruction(s), ends with forward jump to 0x0045455c
    mov dword ptr [ebp - local_30], 0x1          # 0045454c
    jmp.d8 L_0045455c                            # 00454553
L_00454555:
    # block 0x00454555: entered by je at 0x00454544; je at 0x0045454a, 1 instruction(s), falls into the block at 0x0045455c
    mov dword ptr [ebp - local_30], 0x0          # 00454555
L_0045455c:
    # block 0x0045455c: entered by jmp at 0x00454553, 1 instruction(s), falls into the block at 0x0045455f
    mov eax, dword ptr [ebp - local_30]          # 0045455c
L_0045455f:
    # block 0x0045455f: entered by jmp at 0x004544f8, 3 instruction(s), ends with ret 0x10
    {load} mov esp, ebp                          # 0045455f
    pop ebp                                      # 00454561
    ret 0x10                                     # 00454562

