# FUN_00422e4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00422e4a
# extent:       0x00422e4a-0x00422fa1 (343 code bytes)
# span:         0x00422e4a-0x00422fb0 (code 343, tables 0, padding 15)
# sha256:       a1fc9156c1c91e54e28ceb99c14d8e8f77f7c4a338459a4e70f5fcd4db1aa0fa
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_cel_frame_reader_thread_loop
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:453 says "One pass of the reader thread loop 0x422e4a"
# name-note:    Reader thread loop of the cel conversation: evicts cache, loads one frame, advances.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044c479, FUN_0041dfd2, FUN_0041e1e4, FUN_0041e043, FUN_0041e0b4, FUN_0044c4ab, KERNEL32.dll!Sleep, FUN_0051ec84
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.h:convo3f_cel_reader_iteration (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 84 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0041dfd2, .text + (0x0041dfd2 - 0x401000)
.set FUN_0041e043, .text + (0x0041e043 - 0x401000)
.set FUN_0041e0b4, .text + (0x0041e0b4 - 0x401000)
.set FUN_0041e1e4, .text + (0x0041e1e4 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x00422e4a - 0x401000
.globl FUN_00422e4a
FUN_00422e4a:
    # block 0x00422e4a: entry, 5 instruction(s), falls into the block at 0x00422e56
    push ebp                                     # 00422e4a
    {load} mov ebp, esp                          # 00422e4b
    sub esp, 0x8                                 # 00422e4d
    mov eax, dword ptr [ebp + arg_8]             # 00422e50
    mov dword ptr [ebp - local_8], eax           # 00422e53
L_00422e56:
    # block 0x00422e56: entered by jmp at 0x00422f8d, 3 instruction(s), ends with je to 0x00422f92 (forward)
    mov ecx, 0x1                                 # 00422e56
    test ecx, ecx                                # 00422e5b
    je.d32 L_00422f92                            # 00422e5d
    # block 0x00422e63: entered by fall-through of je at 0x00422e5d, 3 instruction(s), ends with je to 0x00422e70 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00422e63
    cmp dword ptr [edx], 0x0                     # 00422e66
    je.d8 L_00422e70                             # 00422e69
    # block 0x00422e6b: entered by fall-through of je at 0x00422e69, 1 instruction(s), ends with forward jump to 0x00422f92
    jmp.d32 L_00422f92                           # 00422e6b
L_00422e70:
    # block 0x00422e70: entered by je at 0x00422e69, 6 instruction(s), calls FUN_0044c479, ends with jne to 0x00422e8a (forward)
    push 0x617e80                                # 00422e70
    call FUN_0044c479                            # 00422e75
    add esp, 0x4                                 # 00422e7a
    movsx eax, ax                                # 00422e7d
    cmp eax, 0x2                                 # 00422e80
    jne.d8 L_00422e8a                            # 00422e83
    # block 0x00422e85: entered by fall-through of jne at 0x00422e83, 1 instruction(s), ends with forward jump to 0x00422f9f
    jmp.d32 L_00422f9f                           # 00422e85
L_00422e8a:
    # block 0x00422e8a: entered by jne at 0x00422e83, 6 instruction(s), calls FUN_0041dfd2, ends with jge to 0x00422eb8 (forward)
    mov ecx, 0x6177e8                            # 00422e8a
    call FUN_0041dfd2                            # 00422e8f
    movsx ecx, word ptr [0x617e76]               # 00422e94
    movsx edx, word ptr [0x617e7e]               # 00422e9b
    {load} cmp ecx, edx                          # 00422ea2
    jge.d8 L_00422eb8                            # 00422ea4
    # block 0x00422ea6: entered by fall-through of jge at 0x00422ea4, 4 instruction(s), ends with jle to 0x00422ebd (forward)
    movsx eax, word ptr [0x617e7a]               # 00422ea6
    movsx ecx, word ptr [0x617e8c]               # 00422ead
    {load} cmp eax, ecx                          # 00422eb4
    jle.d8 L_00422ebd                            # 00422eb6
L_00422eb8:
    # block 0x00422eb8: entered by jge at 0x00422ea4; fall-through of jle at 0x00422eb6, 1 instruction(s), ends with forward jump to 0x00422f9d
    jmp.d32 L_00422f9d                           # 00422eb8
L_00422ebd:
    # block 0x00422ebd: entered by jle at 0x00422eb6, 7 instruction(s), calls FUN_0041e1e4, ends with jne to 0x00422f0a (forward)
    mov dx, word ptr [0x617e7a]                  # 00422ebd
    push edx                                     # 00422ec4
    mov ecx, 0x6177e8                            # 00422ec5
    call FUN_0041e1e4                            # 00422eca
    movsx eax, ax                                # 00422ecf
    cmp eax, -0x1                                # 00422ed2
    jne.d8 L_00422f0a                            # 00422ed5
    # block 0x00422ed7: entered by fall-through of jne at 0x00422ed5, 6 instruction(s), calls FUN_0041e043, ends with jne to 0x00422ef3 (forward)
    mov ecx, 0x6177e8                            # 00422ed7
    call FUN_0041e043                            # 00422edc
    mov word ptr [ebp - local_4], ax             # 00422ee1
    movsx ecx, word ptr [ebp - local_4]          # 00422ee5
    cmp ecx, -0x1                                # 00422ee9
    jne.d8 L_00422ef3                            # 00422eec
    # block 0x00422eee: entered by fall-through of jne at 0x00422eec, 1 instruction(s), ends with forward jump to 0x00422f9b
    jmp.d32 L_00422f9b                           # 00422eee
L_00422ef3:
    # block 0x00422ef3: entered by jne at 0x00422eec, 6 instruction(s), calls FUN_0041e0b4, falls into the block at 0x00422f0a
    mov dx, word ptr [0x617e7a]                  # 00422ef3
    push edx                                     # 00422efa
    mov ax, word ptr [ebp - local_4]             # 00422efb
    push eax                                     # 00422eff
    mov ecx, 0x6177e8                            # 00422f00
    call FUN_0041e0b4                            # 00422f05
L_00422f0a:
    # block 0x00422f0a: entered by jne at 0x00422ed5, 3 instruction(s), ends with jne to 0x00422f41 (forward)
    movsx ecx, word ptr [0x617e7c]               # 00422f0a
    cmp ecx, -0x1                                # 00422f11
    jne.d8 L_00422f41                            # 00422f14
    # block 0x00422f16: entered by fall-through of jne at 0x00422f14, 10 instruction(s), ends with forward jump to 0x00422f58
    movsx edx, word ptr [0x617f6e]               # 00422f16
    mov eax, dword ptr [0x617e8e]                # 00422f1d
    {load} xor ecx, ecx                          # 00422f22
    mov cl, byte ptr [eax + edx]                 # 00422f24
    movsx edx, word ptr [0x617f74]               # 00422f27
    {load} add ecx, edx                          # 00422f2e
    mov ax, word ptr [0x617e7a]                  # 00422f30
    {load} add ax, cx                            # 00422f36
    mov word ptr [0x617e7a], ax                  # 00422f39
    jmp.d8 L_00422f58                            # 00422f3f
L_00422f41:
    # block 0x00422f41: entered by jne at 0x00422f14, 3 instruction(s), falls into the block at 0x00422f58
    mov cx, word ptr [0x617e7c]                  # 00422f41
    mov word ptr [0x617e7a], cx                  # 00422f48
    mov word ptr [0x617e7c], 0xffff              # 00422f4f
L_00422f58:
    # block 0x00422f58: entered by jmp at 0x00422f3f, 4 instruction(s), ends with jle to 0x00422f78 (forward)
    movsx edx, word ptr [0x617e7a]               # 00422f58
    movsx eax, word ptr [0x617e8c]               # 00422f5f
    {load} cmp edx, eax                          # 00422f66
    jle.d8 L_00422f78                            # 00422f68
    # block 0x00422f6a: entered by fall-through of jle at 0x00422f68, 2 instruction(s), falls into the block at 0x00422f78
    mov cx, word ptr [0x617e8c]                  # 00422f6a
    mov word ptr [0x617e7a], cx                  # 00422f71
L_00422f78:
    # block 0x00422f78: entered by jle at 0x00422f68; jmp at 0x00422f9b; jmp at 0x00422f9d; jmp at 0x00422f9f, 6 instruction(s), calls FUN_0044c4ab, KERNEL32.dll!Sleep, ends with backward jump to 0x00422e56
    push 0x617e80                                # 00422f78
    call FUN_0044c4ab                            # 00422f7d
    add esp, 0x4                                 # 00422f82
    push 0x1                                     # 00422f85
    call dword ptr [0x52a2b0]                    # 00422f87
    jmp.d32 L_00422e56                           # 00422f8d
L_00422f92:
    # block 0x00422f92: entered by je at 0x00422e5d; jmp at 0x00422e6b, 3 instruction(s), calls FUN_0051ec84, falls into the block at 0x00422f9b
    push 0x1                                     # 00422f92
    push 0x0                                     # 00422f94
    call FUN_0051ec84                            # 00422f96
L_00422f9b:
    # block 0x00422f9b: entered by jmp at 0x00422eee, 1 instruction(s), ends with backward jump to 0x00422f78
    jmp.d8 L_00422f78                            # 00422f9b
L_00422f9d:
    # block 0x00422f9d: entered by jmp at 0x00422eb8, 1 instruction(s), ends with backward jump to 0x00422f78
    jmp.d8 L_00422f78                            # 00422f9d
L_00422f9f:
    # block 0x00422f9f: entered by jmp at 0x00422e85, 1 instruction(s), ends with backward jump to 0x00422f78
    jmp.d8 L_00422f78                            # 00422f9f

# --- data items (not part of the function) -------------------------
.org 0x00422fa1 - 0x401000
PAD_00422fa1:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

