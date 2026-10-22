# FUN_0043f0fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f0fb
# extent:       0x0043f0fb-0x0043f1d2 (215 code bytes)
# span:         0x0043f0fb-0x0043f1e0 (code 215, tables 0, padding 14)
# sha256:       87d1189e9a09bf73389993175baf0018bc936db9ce92a59c92f98367b6cfe278
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43f0fb_lifted
# naming:       native port src/original_methods_fl40.c:m43f0fb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 57/57 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_fc, local_100
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GlobalMemoryStatus, FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43f0fb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_fc, 0xfc  # offset -0xfc
.equ local_100, 0x100  # offset -0x100

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0043f0fb - 0x401000
.globl FUN_0043f0fb
FUN_0043f0fb:
    # block 0x0043f0fb: entry, 15 instruction(s), calls KERNEL32.dll!GlobalMemoryStatus, ends with je to 0x0043f1c8 (forward)
    push ebp                                     # 0043f0fb
    {load} mov ebp, esp                          # 0043f0fc
    sub esp, 0x100                               # 0043f0fe
    push edi                                     # 0043f104
    mov dword ptr [ebp - local_100], ecx         # 0043f105
    mov ecx, 0x8                                 # 0043f10b
    {load} xor eax, eax                          # 0043f110
    mov edi, 0x63a5d0                            # 0043f112
    rep stosd dword ptr es:[edi], eax            # 0043f117
    mov dword ptr [0x63a5d0], 0x20               # 0043f119
    push 0x63a5d0                                # 0043f123
    call dword ptr [0x52a288]                    # 0043f128
    movsx eax, word ptr [0x63a4cd]               # 0043f12e
    test eax, eax                                # 0043f135
    je.d32 L_0043f1c8                            # 0043f137
    # block 0x0043f13d: entered by fall-through of je at 0x0043f137, 37 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0043f1c8
    mov ecx, dword ptr [0x63a5d4]                # 0043f13d
    push ecx                                     # 0043f143
    push 0x5477ec                                # 0043f144
    lea edx, [ebp - local_fc]                    # 0043f149
    push edx                                     # 0043f14f
    call FUN_0050ca3e                            # 0043f150
    add esp, 0xc                                 # 0043f155
    lea eax, [ebp - local_fc]                    # 0043f158
    push eax                                     # 0043f15e
    call FUN_0044a2b7                            # 0043f15f
    add esp, 0x4                                 # 0043f164
    mov ecx, dword ptr [0x63a5dc]                # 0043f167
    push ecx                                     # 0043f16d
    mov edx, dword ptr [0x63a5d8]                # 0043f16e
    push edx                                     # 0043f174
    push 0x547820                                # 0043f175
    lea eax, [ebp - local_fc]                    # 0043f17a
    push eax                                     # 0043f180
    call FUN_0050ca3e                            # 0043f181
    add esp, 0x10                                # 0043f186
    lea ecx, [ebp - local_fc]                    # 0043f189
    push ecx                                     # 0043f18f
    call FUN_0044a2b7                            # 0043f190
    add esp, 0x4                                 # 0043f195
    mov edx, dword ptr [0x63a5ec]                # 0043f198
    push edx                                     # 0043f19e
    mov eax, dword ptr [0x63a5e8]                # 0043f19f
    push eax                                     # 0043f1a4
    push 0x54785c                                # 0043f1a5
    lea ecx, [ebp - local_fc]                    # 0043f1aa
    push ecx                                     # 0043f1b0
    call FUN_0050ca3e                            # 0043f1b1
    add esp, 0x10                                # 0043f1b6
    lea edx, [ebp - local_fc]                    # 0043f1b9
    push edx                                     # 0043f1bf
    call FUN_0044a2b7                            # 0043f1c0
    add esp, 0x4                                 # 0043f1c5
L_0043f1c8:
    # block 0x0043f1c8: entered by je at 0x0043f137, 5 instruction(s), ends with ret
    mov eax, 0x63a5d0                            # 0043f1c8
    pop edi                                      # 0043f1cd
    {load} mov esp, ebp                          # 0043f1ce
    pop ebp                                      # 0043f1d0
    ret                                          # 0043f1d1

# --- data items (not part of the function) -------------------------
.org 0x0043f1d2 - 0x401000
PAD_0043f1d2:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

