# FUN_0044f4fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f4fa
# extent:       0x0044f4fa-0x0044f615 (283 code bytes)
# span:         0x0044f4fa-0x0044f620 (code 283, tables 0, padding 11)
# sha256:       d288c7103009a7b0d29bfc9997c510686f1e4df3a1adf74648da3288da5d6e82
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44f4fa_lifted
# naming:       native port src/original_methods_fl40.c:m44f4fa_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 79/79 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_10, local_14
# fields:       [eax + n] field_8d, field_13d
# callees:      calls FUN_0044e95b, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44f4fa_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 79 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_8d, 0x8d  # offset +0x8d
.equ field_13d, 0x13d  # offset +0x13d

# --- external targets -----------------------------------------------
.set FUN_0044e95b, .text + (0x0044e95b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0044f4fa - 0x401000
.globl FUN_0044f4fa
FUN_0044f4fa:
    # block 0x0044f4fa: entry, 55 instruction(s), calls FUN_0044e95b, FUN_004c5377, ends with je to 0x0044f611 (forward)
    push ebp                                     # 0044f4fa
    {load} mov ebp, esp                          # 0044f4fb
    sub esp, 0x14                                # 0044f4fd
    movsx eax, word ptr [0x62494f]               # 0044f500
    imul eax, eax, 0x8d                          # 0044f507
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044f50d
    mov dword ptr [ebp - local_14], ecx          # 0044f513
    lea edx, [ebp - local_10]                    # 0044f516
    push edx                                     # 0044f519
    mov eax, dword ptr [ebp - local_14]          # 0044f51a
    add eax, 0xdd                                # 0044f51d
    push eax                                     # 0044f522
    mov ecx, 0x624931                            # 0044f523
    call FUN_0044e95b                            # 0044f528
    push 0x5498b8                                # 0044f52d
    lea ecx, [ebp - local_10]                    # 0044f532
    push ecx                                     # 0044f535
    movsx edx, word ptr [0x624955]               # 0044f536
    shl edx, 0x4                                 # 0044f53d
    mov eax, dword ptr [ebp - local_14]          # 0044f540
    lea ecx, [eax + edx + field_13d]             # 0044f543
    push ecx                                     # 0044f54a
    mov edx, dword ptr [0x5cf665]                # 0044f54b
    push edx                                     # 0044f551
    movsx eax, word ptr [0x62494d]               # 0044f552
    imul eax, eax, 0x4a                          # 0044f559
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044f55c
    push ecx                                     # 0044f562
    mov ecx, 0x5cf659                            # 0044f563
    call FUN_004c5377                            # 0044f568
    lea edx, [ebp - local_10]                    # 0044f56d
    push edx                                     # 0044f570
    mov eax, dword ptr [ebp - local_14]          # 0044f571
    add eax, 0x7d                                # 0044f574
    push eax                                     # 0044f577
    mov ecx, 0x624931                            # 0044f578
    call FUN_0044e95b                            # 0044f57d
    push 0x5498dc                                # 0044f582
    lea ecx, [ebp - local_10]                    # 0044f587
    push ecx                                     # 0044f58a
    movsx edx, word ptr [0x624957]               # 0044f58b
    shl edx, 0x4                                 # 0044f592
    mov eax, dword ptr [ebp - local_14]          # 0044f595
    lea ecx, [eax + edx + field_8d]              # 0044f598
    push ecx                                     # 0044f59f
    mov edx, dword ptr [0x5cf665]                # 0044f5a0
    push edx                                     # 0044f5a6
    movsx eax, word ptr [0x62494d]               # 0044f5a7
    imul eax, eax, 0x4a                          # 0044f5ae
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044f5b1
    push ecx                                     # 0044f5b7
    mov ecx, 0x5cf659                            # 0044f5b8
    call FUN_004c5377                            # 0044f5bd
    cmp dword ptr [0x624959], 0x0                # 0044f5c2
    je.d8 L_0044f611                             # 0044f5c9
    # block 0x0044f5cb: entered by fall-through of je at 0x0044f5c9, 21 instruction(s), calls FUN_0044e95b, FUN_004c5377, falls into the block at 0x0044f611
    lea edx, [ebp - local_10]                    # 0044f5cb
    push edx                                     # 0044f5ce
    mov eax, dword ptr [ebp - local_14]          # 0044f5cf
    add eax, 0x3d                                # 0044f5d2
    push eax                                     # 0044f5d5
    mov ecx, 0x624931                            # 0044f5d6
    call FUN_0044e95b                            # 0044f5db
    push 0x549900                                # 0044f5e0
    lea ecx, [ebp - local_10]                    # 0044f5e5
    push ecx                                     # 0044f5e8
    mov edx, dword ptr [ebp - local_14]          # 0044f5e9
    add edx, 0x4d                                # 0044f5ec
    push edx                                     # 0044f5ef
    mov eax, dword ptr [0x5cf665]                # 0044f5f0
    push eax                                     # 0044f5f5
    movsx ecx, word ptr [0x62494d]               # 0044f5f6
    imul ecx, ecx, 0x4a                          # 0044f5fd
    mov edx, dword ptr [ecx + 0x5d1599]          # 0044f600
    push edx                                     # 0044f606
    mov ecx, 0x5cf659                            # 0044f607
    call FUN_004c5377                            # 0044f60c
L_0044f611:
    # block 0x0044f611: entered by je at 0x0044f5c9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044f611
    pop ebp                                      # 0044f613
    ret                                          # 0044f614

# --- data items (not part of the function) -------------------------
.org 0x0044f615 - 0x401000
PAD_0044f615:  # 11 byte(s) of int3 padding
    .fill 11, 1, 0xcc

