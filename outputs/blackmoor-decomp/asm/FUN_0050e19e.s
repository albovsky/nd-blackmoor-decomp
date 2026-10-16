# FUN_0050e19e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e19e
# extent:       0x0050e19e-0x0050e26d (207 code bytes)
# span:         0x0050e19e-0x0050e270 (code 207, tables 0, padding 3)
# sha256:       a43ce91ec07f79e4e129e204856c75ed0790cc6f4bfcd392514bb2bd20b6df57
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e19e
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_e; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005146dc, FUN_005145a4, FUN_00513dac, FUN_00514569, FUN_00513e60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------
.set FUN_00513dac, .text + (0x00513dac - 0x401000)
.set FUN_00513e60, .text + (0x00513e60 - 0x401000)
.set FUN_00514569, .text + (0x00514569 - 0x401000)
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x0050e19e - 0x401000
.globl FUN_0050e19e
FUN_0050e19e:
    # block 0x0050e19e: entry, 21 instruction(s), calls FUN_005146dc, ends with jne to 0x0050e224 (forward)
    push ebp                                     # 0050e19e
    {load} mov ebp, esp                          # 0050e19f
    push ecx                                     # 0050e1a1
    push ecx                                     # 0050e1a2
    push ebx                                     # 0050e1a3
    push esi                                     # 0050e1a4
    mov esi, 0xffff                              # 0050e1a5
    push esi                                     # 0050e1aa
    push dword ptr [0x567e64]                    # 0050e1ab
    call FUN_005146dc                            # 0050e1b1
    fld qword ptr [ebp + arg_8]                  # 0050e1b6
    pop ecx                                      # 0050e1b9
    {load} mov ebx, eax                          # 0050e1ba
    mov eax, dword ptr [ebp + arg_e]             # 0050e1bc
    pop ecx                                      # 0050e1bf
    push ecx                                     # 0050e1c0
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 0050e1c1
    push ecx                                     # 0050e1c5
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 0050e1c6
    fstp qword ptr [esp]                         # 0050e1ca
    jne.d8 L_0050e224                            # 0050e1cd
    # block 0x0050e1cf: entered by fall-through of jne at 0x0050e1cd, 5 instruction(s), calls FUN_005145a4, ends with jle to 0x0050e207 (forward)
    call FUN_005145a4                            # 0050e1cf
    pop ecx                                      # 0050e1d4
    test eax, eax                                # 0050e1d5
    pop ecx                                      # 0050e1d7
    jle.d8 L_0050e207                            # 0050e1d8
    # block 0x0050e1da: entered by fall-through of jle at 0x0050e1d8, 2 instruction(s), ends with jle to 0x0050e1f9 (forward)
    cmp eax, 0x2                                 # 0050e1da
    jle.d8 L_0050e1f9                            # 0050e1dd
    # block 0x0050e1df: entered by fall-through of jle at 0x0050e1dd, 2 instruction(s), ends with jne to 0x0050e207 (forward)
    cmp eax, 0x3                                 # 0050e1df
    jne.d8 L_0050e207                            # 0050e1e2
    # block 0x0050e1e4: entered by fall-through of jne at 0x0050e1e2, 9 instruction(s), calls FUN_00513dac, ends with forward jump to 0x0050e269
    fld qword ptr [ebp + arg_8]                  # 0050e1e4
    push ebx                                     # 0050e1e7
    push ecx                                     # 0050e1e8
    push ecx                                     # 0050e1e9
    fstp qword ptr [esp]                         # 0050e1ea
    push 0xb                                     # 0050e1ed
    call FUN_00513dac                            # 0050e1ef
    add esp, 0x10                                # 0050e1f4
    jmp.d8 L_0050e269                            # 0050e1f7
L_0050e1f9:
    # block 0x0050e1f9: entered by jle at 0x0050e1dd, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e269
    push esi                                     # 0050e1f9
    push ebx                                     # 0050e1fa
    call FUN_005146dc                            # 0050e1fb
    fld qword ptr [ebp + arg_8]                  # 0050e200
    pop ecx                                      # 0050e203
    pop ecx                                      # 0050e204
    jmp.d8 L_0050e269                            # 0050e205
L_0050e207:
    # block 0x0050e207: entered by jle at 0x0050e1d8; jne at 0x0050e1e2, 13 instruction(s), ends with forward jump to 0x0050e261
    fld qword ptr [ebp + arg_8]                  # 0050e207
    fadd qword ptr [0x52c598]                    # 0050e20a
    push ebx                                     # 0050e210
    push ecx                                     # 0050e211
    push ecx                                     # 0050e212
    fstp qword ptr [esp]                         # 0050e213
    fld qword ptr [ebp + arg_8]                  # 0050e216
    push ecx                                     # 0050e219
    push ecx                                     # 0050e21a
    fstp qword ptr [esp]                         # 0050e21b
    push 0xb                                     # 0050e21e
    push 0x8                                     # 0050e220
    jmp.d8 L_0050e261                            # 0050e222
L_0050e224:
    # block 0x0050e224: entered by jne at 0x0050e1cd, 9 instruction(s), calls FUN_00514569, ends with jne to 0x0050e247 (forward)
    call FUN_00514569                            # 0050e224
    fstp qword ptr [ebp - local_8]               # 0050e229
    fld qword ptr [ebp - local_8]                # 0050e22c
    fcomp qword ptr [ebp + arg_8]                # 0050e22f
    pop ecx                                      # 0050e232
    pop ecx                                      # 0050e233
    fnstsw ax                                    # 0050e234
    sahf                                         # 0050e236
    jne.d8 L_0050e247                            # 0050e237
L_0050e239:
    # block 0x0050e239: entered by jne at 0x0050e24a; fall-through of jne at 0x0050e237, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e269
    push esi                                     # 0050e239
    push ebx                                     # 0050e23a
    call FUN_005146dc                            # 0050e23b
    fld qword ptr [ebp - local_8]                # 0050e240
    pop ecx                                      # 0050e243
    pop ecx                                      # 0050e244
    jmp.d8 L_0050e269                            # 0050e245
L_0050e247:
    # block 0x0050e247: entered by jne at 0x0050e237, 2 instruction(s), ends with jne to 0x0050e239 (backward)
    test bl, 0x20                                # 0050e247
    jne.d8 L_0050e239                            # 0050e24a
    # block 0x0050e24c: entered by fall-through of jne at 0x0050e24a, 11 instruction(s), falls into the block at 0x0050e261
    fld qword ptr [ebp - local_8]                # 0050e24c
    push ebx                                     # 0050e24f
    push ecx                                     # 0050e250
    push ecx                                     # 0050e251
    fstp qword ptr [esp]                         # 0050e252
    fld qword ptr [ebp + arg_8]                  # 0050e255
    push ecx                                     # 0050e258
    push ecx                                     # 0050e259
    fstp qword ptr [esp]                         # 0050e25a
    push 0xb                                     # 0050e25d
    push 0x10                                    # 0050e25f
L_0050e261:
    # block 0x0050e261: entered by jmp at 0x0050e222, 2 instruction(s), calls FUN_00513e60, falls into the block at 0x0050e269
    call FUN_00513e60                            # 0050e261
    add esp, 0x1c                                # 0050e266
L_0050e269:
    # block 0x0050e269: entered by jmp at 0x0050e1f7; jmp at 0x0050e205; jmp at 0x0050e245, 4 instruction(s), ends with ret
    pop esi                                      # 0050e269
    pop ebx                                      # 0050e26a
    leave                                        # 0050e26b
    ret                                          # 0050e26c

# --- data items (not part of the function) -------------------------
.org 0x0050e26d - 0x401000
PAD_0050e26d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

