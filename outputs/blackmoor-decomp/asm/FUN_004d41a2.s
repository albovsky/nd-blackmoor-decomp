# FUN_004d41a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d41a2
# extent:       0x004d41a2-0x004d42a9 (263 code bytes)
# span:         0x004d41a2-0x004d42b0 (code 263, tables 0, padding 7)
# sha256:       ba5b922a85fc9f12bb64b68604f54746fef1d06ca001ae2db5f30f5e767da207
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d41a2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004d3c9a, FUN_004c5d4b, FUN_004d4074
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004d3c9a, .text + (0x004d3c9a - 0x401000)
.set FUN_004d4074, .text + (0x004d4074 - 0x401000)

.org 0x004d41a2 - 0x401000
.globl FUN_004d41a2
FUN_004d41a2:
    # block 0x004d41a2: entry, 6 instruction(s), ends with je to 0x004d41b5 (forward)
    push ebp                                     # 004d41a2
    {load} mov ebp, esp                          # 004d41a3
    {load} xor eax, eax                          # 004d41a5
    mov al, byte ptr [0x61c6ae]                  # 004d41a7
    test eax, eax                                # 004d41ac
    je.d8 L_004d41b5                             # 004d41ae
    # block 0x004d41b0: entered by fall-through of je at 0x004d41ae, 1 instruction(s), ends with forward jump to 0x004d42a7
    jmp.d32 L_004d42a7                           # 004d41b0
L_004d41b5:
    # block 0x004d41b5: entered by je at 0x004d41ae, 2 instruction(s), ends with je to 0x004d41fe (forward)
    cmp dword ptr [0x61c7c7], 0x0                # 004d41b5
    je.d8 L_004d41fe                             # 004d41bc
    # block 0x004d41be: entered by fall-through of je at 0x004d41bc, 13 instruction(s), calls FUN_004c5377, FUN_004d3c9a, ends with forward jump to 0x004d42a7
    mov dword ptr [0x61c7c7], 0x0                # 004d41be
    push 0x55a4dc                                # 004d41c8
    push 0x5b0217                                # 004d41cd
    push 0x5b0217                                # 004d41d2
    mov ecx, dword ptr [0x5cf665]                # 004d41d7
    push ecx                                     # 004d41dd
    mov edx, dword ptr [0x5d1599]                # 004d41de
    push edx                                     # 004d41e4
    mov ecx, 0x5cf659                            # 004d41e5
    call FUN_004c5377                            # 004d41ea
    mov ecx, 0x61c387                            # 004d41ef
    call FUN_004d3c9a                            # 004d41f4
    jmp.d32 L_004d42a7                           # 004d41f9
L_004d41fe:
    # block 0x004d41fe: entered by je at 0x004d41bc, 3 instruction(s), ends with jne to 0x004d4239 (forward)
    movsx eax, word ptr [0x61c7c5]               # 004d41fe
    test eax, eax                                # 004d4205
    jne.d8 L_004d4239                            # 004d4207
    # block 0x004d4209: entered by fall-through of jne at 0x004d4207, 2 instruction(s), ends with je to 0x004d4239 (forward)
    cmp dword ptr [0x61c7cb], 0x0                # 004d4209
    je.d8 L_004d4239                             # 004d4210
    # block 0x004d4212: entered by fall-through of je at 0x004d4210, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004d4239
    push 0x55a4fc                                # 004d4212
    push 0x5b0217                                # 004d4217
    push 0x5b0217                                # 004d421c
    mov ecx, dword ptr [0x5cf665]                # 004d4221
    push ecx                                     # 004d4227
    mov edx, dword ptr [0x5d1599]                # 004d4228
    push edx                                     # 004d422e
    mov ecx, 0x5cf659                            # 004d422f
    call FUN_004c5377                            # 004d4234
L_004d4239:
    # block 0x004d4239: entered by jne at 0x004d4207; je at 0x004d4210, 26 instruction(s), calls FUN_004c5d4b, FUN_004d4074, falls into the block at 0x004d42a7
    push 0x55a51c                                # 004d4239
    push 0x61c497                                # 004d423e
    push 0x61c487                                # 004d4243
    mov eax, dword ptr [0x5cf665]                # 004d4248
    push eax                                     # 004d424d
    mov ecx, dword ptr [0x5d1c3f]                # 004d424e
    push ecx                                     # 004d4254
    mov ecx, 0x5cf659                            # 004d4255
    call FUN_004c5d4b                            # 004d425a
    mov ecx, 0x61c387                            # 004d425f
    call FUN_004d4074                            # 004d4264
    push 0x55a528                                # 004d4269
    movsx edx, word ptr [0x61c7c5]               # 004d426e
    shl edx, 0x4                                 # 004d4275
    add edx, 0x61c417                            # 004d4278
    push edx                                     # 004d427e
    movsx eax, word ptr [0x61c7c5]               # 004d427f
    shl eax, 0x4                                 # 004d4286
    add eax, 0x61c3a7                            # 004d4289
    push eax                                     # 004d428e
    mov ecx, dword ptr [0x5cf665]                # 004d428f
    push ecx                                     # 004d4295
    mov edx, dword ptr [0x5d1c3f]                # 004d4296
    push edx                                     # 004d429c
    mov ecx, 0x5cf659                            # 004d429d
    call FUN_004c5d4b                            # 004d42a2
L_004d42a7:
    # block 0x004d42a7: entered by jmp at 0x004d41b0; jmp at 0x004d41f9, 2 instruction(s), ends with ret
    pop ebp                                      # 004d42a7
    ret                                          # 004d42a8

# --- data items (not part of the function) -------------------------
.org 0x004d42a9 - 0x401000
PAD_004d42a9:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

