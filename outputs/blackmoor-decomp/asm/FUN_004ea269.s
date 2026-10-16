# FUN_004ea269
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea269
# extent:       0x004ea269-0x004ea361 (248 code bytes)
# span:         0x004ea269-0x004ea361 (code 248, tables 0, padding 0)
# sha256:       7058fd7b41efbdf39670dbb3e695c06a0aefc540390f13aa95bc12fa74d93e7a
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ea269
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_780, field_782
# callees:      calls FUN_004e9e84, FUN_004eb70f, FUN_004ea06c, FUN_004fb2e3, FUN_004e7d04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_780, 0x780  # offset +0x780
.equ field_782, 0x782  # offset +0x782

# --- external targets -----------------------------------------------
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)
.set FUN_004eb70f, .text + (0x004eb70f - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ea269 - 0x401000
.globl FUN_004ea269
FUN_004ea269:
    # block 0x004ea269: entry, 7 instruction(s), ends with je to 0x004ea28e (forward)
    push ebp                                     # 004ea269
    {load} mov ebp, esp                          # 004ea26a
    push ecx                                     # 004ea26c
    mov dword ptr [ebp - local_4], ecx           # 004ea26d
    movsx eax, word ptr [0x583f1d]               # 004ea270
    cmp eax, -0x1                                # 004ea277
    je.d8 L_004ea28e                             # 004ea27a
    # block 0x004ea27c: entered by fall-through of je at 0x004ea27a, 5 instruction(s), calls FUN_004e9e84, falls into the block at 0x004ea28e
    push 0x1                                     # 004ea27c
    mov cx, word ptr [0x583f1d]                  # 004ea27e
    push ecx                                     # 004ea285
    mov ecx, dword ptr [ebp - local_4]           # 004ea286
    call FUN_004e9e84                            # 004ea289
L_004ea28e:
    # block 0x004ea28e: entered by je at 0x004ea27a, 3 instruction(s), ends with jne to 0x004ea2a4 (forward)
    movsx edx, word ptr [0x583f1d]               # 004ea28e
    cmp edx, -0x1                                # 004ea295
    jne.d8 L_004ea2a4                            # 004ea298
    # block 0x004ea29a: entered by fall-through of jne at 0x004ea298, 3 instruction(s), calls FUN_004eb70f, falls into the block at 0x004ea2a4
    push 0x2                                     # 004ea29a
    mov ecx, dword ptr [ebp - local_4]           # 004ea29c
    call FUN_004eb70f                            # 004ea29f
L_004ea2a4:
    # block 0x004ea2a4: entered by jne at 0x004ea298, 3 instruction(s), ends with jne to 0x004ea2ba (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ea2a4
    cmp eax, 0x1                                 # 004ea2a8
    jne.d8 L_004ea2ba                            # 004ea2ab
    # block 0x004ea2ad: entered by fall-through of jne at 0x004ea2ab, 3 instruction(s), ends with forward jump to 0x004ea2c3
    mov cx, word ptr [ebp + arg_8]               # 004ea2ad
    mov word ptr [0x583f1d], cx                  # 004ea2b1
    jmp.d8 L_004ea2c3                            # 004ea2b8
L_004ea2ba:
    # block 0x004ea2ba: entered by jne at 0x004ea2ab, 1 instruction(s), falls into the block at 0x004ea2c3
    mov word ptr [0x583f1d], 0xffff              # 004ea2ba
L_004ea2c3:
    # block 0x004ea2c3: entered by jmp at 0x004ea2b8, 6 instruction(s), calls FUN_004ea06c, ends with je to 0x004ea2e2 (forward)
    mov dx, word ptr [ebp + arg_8]               # 004ea2c3
    push edx                                     # 004ea2c7
    mov ecx, dword ptr [ebp - local_4]           # 004ea2c8
    call FUN_004ea06c                            # 004ea2cb
    cmp dword ptr [ebp + arg_10], 0x0            # 004ea2d0
    je.d8 L_004ea2e2                             # 004ea2d4
    # block 0x004ea2d6: entered by fall-through of je at 0x004ea2d4, 3 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ea2e2
    push 0x17                                    # 004ea2d6
    mov ecx, 0x5c3a67                            # 004ea2d8
    call FUN_004fb2e3                            # 004ea2dd
L_004ea2e2:
    # block 0x004ea2e2: entered by je at 0x004ea2d4, 21 instruction(s), calls FUN_004e7d04, ends with ret 0xc
    movsx eax, word ptr [ebp + arg_8]            # 004ea2e2
    imul eax, eax, 0x16d                         # 004ea2e6
    mov ecx, dword ptr [ebp - local_4]           # 004ea2ec
    movsx edx, word ptr [ecx + eax + field_780]  # 004ea2ef
    mov dword ptr [0x5bb57b], edx                # 004ea2f7
    mov word ptr [0x5bb599], 0x0                 # 004ea2fd
    mov word ptr [0x5bb595], 0x0                 # 004ea306
    movsx eax, word ptr [ebp + arg_8]            # 004ea30f
    imul eax, eax, 0x16d                         # 004ea313
    mov ecx, dword ptr [ebp - local_4]           # 004ea319
    mov dx, word ptr [ecx + eax + field_782]     # 004ea31c
    mov word ptr [0x5c39ff], dx                  # 004ea324
    mov dword ptr [0x5bb59b], 0x0                # 004ea32b
    mov dword ptr [0x5bb59f], 0x0                # 004ea335
    mov dword ptr [0x5bb5a3], 0x1                # 004ea33f
    mov dword ptr [0x583999], 0x4                # 004ea349
    mov ecx, dword ptr [ebp - local_4]           # 004ea353
    call FUN_004e7d04                            # 004ea356
    {load} mov esp, ebp                          # 004ea35b
    pop ebp                                      # 004ea35d
    ret 0xc                                      # 004ea35e

