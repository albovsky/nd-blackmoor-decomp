# FUN_0047e2a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e2a5
# extent:       0x0047e2a5-0x0047e3f7 (338 code bytes)
# span:         0x0047e2a5-0x0047e3f7 (code 338, tables 0, padding 0)
# sha256:       e6d3db96d20fd50d62d65e1cf99f7843b524ec8480134a2b08e7bf19e254104b
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e2a5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_20, field_13a4, field_13a8, field_13ac; [ecx + n] field_1c, field_20; [edx + n] field_20, field_13a4, field_13a8, field_13ac
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0047e25a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_13a4, 0x13a4  # offset +0x13a4
.equ field_13a8, 0x13a8  # offset +0x13a8
.equ field_13ac, 0x13ac  # offset +0x13ac

# --- external targets -----------------------------------------------
.set FUN_0047e25a, .text + (0x0047e25a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0047e2a5 - 0x401000
.globl FUN_0047e2a5
FUN_0047e2a5:
    # block 0x0047e2a5: entry, 7 instruction(s), ends with je to 0x0047e2db (forward)
    push ebp                                     # 0047e2a5
    {load} mov ebp, esp                          # 0047e2a6
    sub esp, 0xc                                 # 0047e2a8
    mov dword ptr [ebp - local_c], ecx           # 0047e2ab
    mov eax, dword ptr [ebp - local_c]           # 0047e2ae
    cmp dword ptr [eax + field_13a4], 0x0        # 0047e2b1
    je.d8 L_0047e2db                             # 0047e2b8
    # block 0x0047e2ba: entered by fall-through of je at 0x0047e2b8, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047e2db
    mov ecx, dword ptr [ebp - local_c]           # 0047e2ba
    add ecx, 0x13a4                              # 0047e2bd
    push ecx                                     # 0047e2c3
    mov ecx, 0x5cf659                            # 0047e2c4
    call FUN_004c2dfb                            # 0047e2c9
    mov edx, dword ptr [ebp - local_c]           # 0047e2ce
    mov dword ptr [edx + field_13a4], 0x0        # 0047e2d1
L_0047e2db:
    # block 0x0047e2db: entered by je at 0x0047e2b8, 3 instruction(s), ends with je to 0x0047e308 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047e2db
    cmp dword ptr [eax + field_13a8], 0x0        # 0047e2de
    je.d8 L_0047e308                             # 0047e2e5
    # block 0x0047e2e7: entered by fall-through of je at 0x0047e2e5, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047e308
    mov ecx, dword ptr [ebp - local_c]           # 0047e2e7
    add ecx, 0x13a8                              # 0047e2ea
    push ecx                                     # 0047e2f0
    mov ecx, 0x5cf659                            # 0047e2f1
    call FUN_004c2dfb                            # 0047e2f6
    mov edx, dword ptr [ebp - local_c]           # 0047e2fb
    mov dword ptr [edx + field_13a8], 0x0        # 0047e2fe
L_0047e308:
    # block 0x0047e308: entered by je at 0x0047e2e5, 3 instruction(s), ends with je to 0x0047e335 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047e308
    cmp dword ptr [eax + field_13ac], 0x0        # 0047e30b
    je.d8 L_0047e335                             # 0047e312
    # block 0x0047e314: entered by fall-through of je at 0x0047e312, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047e335
    mov ecx, dword ptr [ebp - local_c]           # 0047e314
    add ecx, 0x13ac                              # 0047e317
    push ecx                                     # 0047e31d
    mov ecx, 0x5cf659                            # 0047e31e
    call FUN_004c2dfb                            # 0047e323
    mov edx, dword ptr [ebp - local_c]           # 0047e328
    mov dword ptr [edx + field_13ac], 0x0        # 0047e32b
L_0047e335:
    # block 0x0047e335: entered by je at 0x0047e312, 2 instruction(s), ends with forward jump to 0x0047e349
    mov word ptr [ebp - local_8], 0x0            # 0047e335
    jmp.d8 L_0047e349                            # 0047e33b
L_0047e33d:
    # block 0x0047e33d: entered by jmp at 0x0047e3ca, 3 instruction(s), falls into the block at 0x0047e349
    mov ax, word ptr [ebp - local_8]             # 0047e33d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047e341
    mov word ptr [ebp - local_8], ax             # 0047e345
L_0047e349:
    # block 0x0047e349: entered by jmp at 0x0047e33b, 3 instruction(s), ends with jge to 0x0047e3cf (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0047e349
    cmp ecx, 0x14                                # 0047e34d
    jge.d8 L_0047e3cf                            # 0047e350
    # block 0x0047e352: entered by fall-through of jge at 0x0047e350, 2 instruction(s), ends with forward jump to 0x0047e366
    mov word ptr [ebp - local_4], 0x0            # 0047e352
    jmp.d8 L_0047e366                            # 0047e358
L_0047e35a:
    # block 0x0047e35a: entered by jmp at 0x0047e3c8, 3 instruction(s), falls into the block at 0x0047e366
    mov dx, word ptr [ebp - local_4]             # 0047e35a
    add dx, 0x1                                  # 0047e35e
    mov word ptr [ebp - local_4], dx             # 0047e362
L_0047e366:
    # block 0x0047e366: entered by jmp at 0x0047e358, 3 instruction(s), ends with jge to 0x0047e3ca (forward)
    movsx eax, word ptr [ebp - local_4]          # 0047e366
    cmp eax, 0x4                                 # 0047e36a
    jge.d8 L_0047e3ca                            # 0047e36d
    # block 0x0047e36f: entered by fall-through of jge at 0x0047e36d, 8 instruction(s), ends with je to 0x0047e3c8 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0047e36f
    imul ecx, ecx, 0x60                          # 0047e373
    mov edx, dword ptr [ebp - local_c]           # 0047e376
    lea eax, [edx + ecx + field_20]              # 0047e379
    movsx ecx, word ptr [ebp - local_4]          # 0047e37d
    imul ecx, ecx, 0x18                          # 0047e381
    cmp dword ptr [eax + ecx], 0x0               # 0047e384
    je.d8 L_0047e3c8                             # 0047e388
    # block 0x0047e38a: entered by fall-through of je at 0x0047e388, 17 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047e3c8
    movsx edx, word ptr [ebp - local_8]          # 0047e38a
    imul edx, edx, 0x60                          # 0047e38e
    mov eax, dword ptr [ebp - local_c]           # 0047e391
    lea ecx, [eax + edx + field_20]              # 0047e394
    movsx edx, word ptr [ebp - local_4]          # 0047e398
    imul edx, edx, 0x18                          # 0047e39c
    {load} add ecx, edx                          # 0047e39f
    push ecx                                     # 0047e3a1
    mov ecx, 0x5cf659                            # 0047e3a2
    call FUN_004c2dfb                            # 0047e3a7
    movsx eax, word ptr [ebp - local_8]          # 0047e3ac
    imul eax, eax, 0x60                          # 0047e3b0
    mov ecx, dword ptr [ebp - local_c]           # 0047e3b3
    lea edx, [ecx + eax + field_20]              # 0047e3b6
    movsx eax, word ptr [ebp - local_4]          # 0047e3ba
    imul eax, eax, 0x18                          # 0047e3be
    mov dword ptr [edx + eax], 0x0               # 0047e3c1
L_0047e3c8:
    # block 0x0047e3c8: entered by je at 0x0047e388, 1 instruction(s), ends with backward jump to 0x0047e35a
    jmp.d8 L_0047e35a                            # 0047e3c8
L_0047e3ca:
    # block 0x0047e3ca: entered by jge at 0x0047e36d, 1 instruction(s), ends with backward jump to 0x0047e33d
    jmp.d32 L_0047e33d                           # 0047e3ca
L_0047e3cf:
    # block 0x0047e3cf: entered by jge at 0x0047e350, 4 instruction(s), ends with je to 0x0047e3eb (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047e3cf
    movsx edx, word ptr [ecx + field_1c]         # 0047e3d2
    cmp edx, -0x1                                # 0047e3d6
    je.d8 L_0047e3eb                             # 0047e3d9
    # block 0x0047e3db: entered by fall-through of je at 0x0047e3d9, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0047e3eb
    mov eax, dword ptr [ebp - local_c]           # 0047e3db
    mov cx, word ptr [eax + field_1c]            # 0047e3de
    push ecx                                     # 0047e3e2
    call FUN_004d3992                            # 0047e3e3
    add esp, 0x4                                 # 0047e3e8
L_0047e3eb:
    # block 0x0047e3eb: entered by je at 0x0047e3d9, 5 instruction(s), calls FUN_0047e25a, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0047e3eb
    call FUN_0047e25a                            # 0047e3ee
    {load} mov esp, ebp                          # 0047e3f3
    pop ebp                                      # 0047e3f5
    ret                                          # 0047e3f6

