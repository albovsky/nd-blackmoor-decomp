# FUN_004782db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004782db
# extent:       0x004782db-0x00478396 (187 code bytes)
# span:         0x004782db-0x00478396 (code 187, tables 0, padding 0)
# sha256:       48e77486a566994b0087109fa7762e2ffea4f5c7ede05d49532f309bf233d769
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4782db_clone_record
# naming:       native port src/original_methods_fl38b.c:m4782db_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x29b) stored at *out; copies 0x29b bytes (movsw+movsb) from *in2 and advances *adv and *in2 by it; p == 0 ends in 0x4c97b4 (returns; post-call null copy not modelled). 58/58 instructions, both jne/je ways.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38b.c:m4782db_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004782db - 0x401000
.globl FUN_004782db
FUN_004782db:
    # block 0x004782db: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00478342 (forward)
    push ebp                                     # 004782db
    {load} mov ebp, esp                          # 004782dc
    sub esp, 0x8                                 # 004782de
    push esi                                     # 004782e1
    push edi                                     # 004782e2
    mov dword ptr [ebp - local_8], ecx           # 004782e3
    push 0x29b                                   # 004782e6
    call FUN_0051dc43                            # 004782eb
    add esp, 0x4                                 # 004782f0
    mov dword ptr [ebp - local_4], eax           # 004782f3
    mov eax, dword ptr [ebp + arg_8]             # 004782f6
    mov ecx, dword ptr [ebp - local_4]           # 004782f9
    mov dword ptr [eax], ecx                     # 004782fc
    cmp dword ptr [ebp - local_4], 0x0           # 004782fe
    jne.d8 L_00478342                            # 00478302
    # block 0x00478304: entered by fall-through of jne at 0x00478302, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00478342
    movsx edx, word ptr [0x5c39e3]               # 00478304
    push edx                                     # 0047830b
    mov eax, dword ptr [0x5bb57b]                # 0047830c
    push eax                                     # 00478311
    push 0x54cb10                                # 00478312
    push 0x63888b                                # 00478317
    call FUN_0050ca3e                            # 0047831c
    add esp, 0x10                                # 00478321
    push 0x63888b                                # 00478324
    push 0x54cb3c                                # 00478329
    mov ecx, 0x583979                            # 0047832e
    call FUN_0042639d                            # 00478333
    mov ecx, 0x5cf659                            # 00478338
    call FUN_004c97b4                            # 0047833d
L_00478342:
    # block 0x00478342: entered by jne at 0x00478302, 21 instruction(s), ends with je to 0x0047838e (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00478342
    mov esi, dword ptr [ecx]                     # 00478345
    mov edx, dword ptr [ebp + arg_8]             # 00478347
    mov edi, dword ptr [edx]                     # 0047834a
    mov ecx, 0xa6                                # 0047834c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00478351
    movsw word ptr es:[edi], word ptr [esi]      # 00478353
    movsb byte ptr es:[edi], byte ptr [esi]      # 00478355
    mov eax, dword ptr [ebp + arg_10]            # 00478356
    mov ecx, dword ptr [eax]                     # 00478359
    add ecx, 0x29b                               # 0047835b
    mov edx, dword ptr [ebp + arg_10]            # 00478361
    mov dword ptr [edx], ecx                     # 00478364
    mov eax, dword ptr [ebp + arg_c]             # 00478366
    mov ecx, dword ptr [eax]                     # 00478369
    add ecx, 0x29b                               # 0047836b
    mov edx, dword ptr [ebp + arg_c]             # 00478371
    mov dword ptr [edx], ecx                     # 00478374
    movsx eax, word ptr [0x63a4cd]               # 00478376
    test eax, eax                                # 0047837d
    je.d8 L_0047838e                             # 0047837f
    # block 0x00478381: entered by fall-through of je at 0x0047837f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047838e
    push 0x54cb58                                # 00478381
    call FUN_0044a2b7                            # 00478386
    add esp, 0x4                                 # 0047838b
L_0047838e:
    # block 0x0047838e: entered by je at 0x0047837f, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047838e
    pop esi                                      # 0047838f
    {load} mov esp, ebp                          # 00478390
    pop ebp                                      # 00478392
    ret 0xc                                      # 00478393

