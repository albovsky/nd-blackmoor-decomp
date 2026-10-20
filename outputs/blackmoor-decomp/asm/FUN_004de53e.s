# FUN_004de53e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de53e
# extent:       0x004de53e-0x004de584 (70 code bytes)
# span:         0x004de53e-0x004de584 (code 70, tables 0, padding 0)
# sha256:       2bb0c2bf9f3173f97ea279ef02a2e15f78f15e5c84353d7ec2464a6a7c4c80f4
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de53e_report
# naming:       native port src/original_methods_fl32c.c:m4de53e_report (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4ee630; when it returns non-zero calls 0x4c5377 with that value, dword [0x5cf665], self+0x981 and the constants 0x5b0227, 0x55b8d0; both outcomes taken, 23/23 executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee630, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32c.c:m4de53e_report (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004ee630, .text + (0x004ee630 - 0x401000)

.org 0x004de53e - 0x401000
.globl FUN_004de53e
FUN_004de53e:
    # block 0x004de53e: entry, 9 instruction(s), calls FUN_004ee630, ends with je to 0x004de580 (forward)
    push ebp                                     # 004de53e
    {load} mov ebp, esp                          # 004de53f
    sub esp, 0x8                                 # 004de541
    mov dword ptr [ebp - local_8], ecx           # 004de544
    mov ecx, dword ptr [ebp - local_8]           # 004de547
    call FUN_004ee630                            # 004de54a
    mov dword ptr [ebp - local_4], eax           # 004de54f
    cmp dword ptr [ebp - local_4], 0x0           # 004de552
    je.d8 L_004de580                             # 004de556
    # block 0x004de558: entered by fall-through of je at 0x004de556, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x004de580
    push 0x55b8d0                                # 004de558
    push 0x5b0227                                # 004de55d
    mov eax, dword ptr [ebp - local_8]           # 004de562
    add eax, 0x981                               # 004de565
    push eax                                     # 004de56a
    mov ecx, dword ptr [0x5cf665]                # 004de56b
    push ecx                                     # 004de571
    mov edx, dword ptr [ebp - local_4]           # 004de572
    push edx                                     # 004de575
    mov ecx, 0x5cf659                            # 004de576
    call FUN_004c5377                            # 004de57b
L_004de580:
    # block 0x004de580: entered by je at 0x004de556, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de580
    pop ebp                                      # 004de582
    ret                                          # 004de583

