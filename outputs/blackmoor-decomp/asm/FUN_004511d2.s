# FUN_004511d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004511d2
# extent:       0x004511d2-0x00451310 (318 code bytes)
# span:         0x004511d2-0x0045133d (code 318, tables 45, padding 0)
# sha256:       5927d4406ff2f6289c64807181a627566d118b9d03ecee3fc03074a245a3df63
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4511d2_lifted
# naming:       native port src/original_methods_fl40.c:m4511d2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 10 seeds; oracle 91/91 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_188; [ecx + n] field_184, field_188; [edx + n] field_4, field_8, field_184
# callees:      calls FUN_0044c223, FUN_0045133d, FUN_0044bf8b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4511d2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 1 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_184, 0x184  # offset +0x184
.equ field_188, 0x188  # offset +0x188

# --- external targets -----------------------------------------------
.set FUN_0044bf8b, .text + (0x0044bf8b - 0x401000)
.set FUN_0044c223, .text + (0x0044c223 - 0x401000)
.set FUN_0045133d, .text + (0x0045133d - 0x401000)

.org 0x004511d2 - 0x401000
.globl FUN_004511d2
FUN_004511d2:
    # block 0x004511d2: entry, 17 instruction(s), ends with ja to 0x00451218 (forward)
    push ebp                                     # 004511d2
    {load} mov ebp, esp                          # 004511d3
    sub esp, 0x14                                # 004511d5
    mov dword ptr [ebp - local_10], ecx          # 004511d8
    mov eax, dword ptr [ebp - local_10]          # 004511db
    add eax, 0xe8                                # 004511de
    mov ecx, dword ptr [eax]                     # 004511e3
    mov dword ptr [ebp - local_c], ecx           # 004511e5
    mov edx, dword ptr [eax + field_4]           # 004511e8
    mov dword ptr [ebp - local_8], edx           # 004511eb
    mov eax, dword ptr [eax + field_8]           # 004511ee
    mov dword ptr [ebp - local_4], eax           # 004511f1
    mov ecx, dword ptr [ebp - local_10]          # 004511f4
    mov edx, dword ptr [ecx + field_184]         # 004511f7
    mov dword ptr [ebp - local_14], edx          # 004511fd
    cmp dword ptr [ebp - local_14], 0x10         # 00451200
    ja.d8 L_00451218                             # 00451204
    # block 0x00451206: entered by fall-through of ja at 0x00451204, 4 instruction(s), ends with indirect jump dword ptr [4*eax + 0x451310]
    mov ecx, dword ptr [ebp - local_14]          # 00451206
    {load} xor eax, eax                          # 00451209
    mov al, byte ptr [ecx + IDXTAB_0045132c_VA]  # 0045120b
    jmp dword ptr [4*eax + SWTAB_00451310_VA]    # 00451211
L_00451218:
    # block 0x00451218: entered by ja at 0x00451204, 1 instruction(s), ends with forward jump to 0x0045130c
    jmp.d32 L_0045130c                           # 00451218
L_0045121d:
    # block 0x0045121d: entered by switch case, 16 instruction(s), calls FUN_0044c223, ends with forward jump to 0x0045130c
    push 0x1                                     # 0045121d
    mov edx, dword ptr [ebp - local_10]          # 0045121f
    mov eax, dword ptr [edx + field_184]         # 00451222
    imul eax, eax, 0xc                           # 00451228
    mov ecx, dword ptr [ebp - local_10]          # 0045122b
    lea edx, [ecx + eax + field_188]             # 0045122e
    push edx                                     # 00451235
    mov eax, dword ptr [ebp - local_10]          # 00451236
    add eax, 0xe8                                # 00451239
    push eax                                     # 0045123e
    mov ecx, dword ptr [ebp - local_10]          # 0045123f
    add ecx, 0xe8                                # 00451242
    push ecx                                     # 00451248
    mov ecx, 0x61f860                            # 00451249
    call FUN_0044c223                            # 0045124e
    jmp.d32 L_0045130c                           # 00451253
L_00451258:
    # block 0x00451258: entered by switch case, 14 instruction(s), ends with forward jump to 0x0045130c
    mov edx, dword ptr [ebp - local_10]          # 00451258
    mov eax, dword ptr [edx + field_184]         # 0045125b
    imul eax, eax, 0xc                           # 00451261
    mov ecx, dword ptr [ebp - local_10]          # 00451264
    lea edx, [ecx + eax + field_188]             # 00451267
    mov eax, dword ptr [ebp - local_10]          # 0045126e
    add eax, 0xe8                                # 00451271
    mov ecx, dword ptr [edx]                     # 00451276
    mov dword ptr [eax], ecx                     # 00451278
    mov ecx, dword ptr [edx + field_4]           # 0045127a
    mov dword ptr [eax + field_4], ecx           # 0045127d
    mov edx, dword ptr [edx + field_8]           # 00451280
    mov dword ptr [eax + field_8], edx           # 00451283
    jmp.d32 L_0045130c                           # 00451286
L_0045128b:
    # block 0x0045128b: entered by switch case, 3 instruction(s), calls FUN_0045133d, ends with forward jump to 0x0045130c
    mov ecx, dword ptr [ebp - local_10]          # 0045128b
    call FUN_0045133d                            # 0045128e
    jmp.d8 L_0045130c                            # 00451293
L_00451295:
    # block 0x00451295: entered by switch case, 6 instruction(s), calls FUN_0044bf8b, ends with forward jump to 0x0045130c
    mov eax, dword ptr [ebp - local_10]          # 00451295
    add eax, 0xe8                                # 00451298
    push eax                                     # 0045129d
    mov ecx, 0x61f860                            # 0045129e
    call FUN_0044bf8b                            # 004512a3
    jmp.d8 L_0045130c                            # 004512a8
L_004512aa:
    # block 0x004512aa: entered by switch case, 16 instruction(s), calls FUN_0044c223, ends with forward jump to 0x0045130c
    push 0x1                                     # 004512aa
    mov ecx, dword ptr [ebp - local_10]          # 004512ac
    mov edx, dword ptr [ecx + field_184]         # 004512af
    imul edx, edx, 0xc                           # 004512b5
    mov eax, dword ptr [ebp - local_10]          # 004512b8
    lea ecx, [eax + edx + field_188]             # 004512bb
    push ecx                                     # 004512c2
    mov edx, dword ptr [ebp - local_10]          # 004512c3
    add edx, 0xe8                                # 004512c6
    push edx                                     # 004512cc
    mov eax, dword ptr [ebp - local_10]          # 004512cd
    add eax, 0xe8                                # 004512d0
    push eax                                     # 004512d5
    mov ecx, 0x61f860                            # 004512d6
    call FUN_0044c223                            # 004512db
    jmp.d8 L_0045130c                            # 004512e0
L_004512e2:
    # block 0x004512e2: entered by switch case, 6 instruction(s), calls FUN_0044bf8b, ends with forward jump to 0x0045130c
    mov ecx, dword ptr [ebp - local_10]          # 004512e2
    add ecx, 0xe8                                # 004512e5
    push ecx                                     # 004512eb
    mov ecx, 0x61f860                            # 004512ec
    call FUN_0044bf8b                            # 004512f1
    jmp.d8 L_0045130c                            # 004512f6
L_004512f8:
    # block 0x004512f8: entered by switch case, 5 instruction(s), calls FUN_0044bf8b, falls into the block at 0x0045130c
    mov edx, dword ptr [ebp - local_10]          # 004512f8
    add edx, 0xe8                                # 004512fb
    push edx                                     # 00451301
    mov ecx, 0x61f860                            # 00451302
    call FUN_0044bf8b                            # 00451307
L_0045130c:
    # block 0x0045130c: entered by jmp at 0x00451218; jmp at 0x00451253; jmp at 0x00451286; jmp at 0x00451293; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045130c
    pop ebp                                      # 0045130e
    ret                                          # 0045130f

# --- data items (not part of the function) -------------------------
.org 0x00451310 - 0x401000
SWTAB_00451310:  # 7 case address(es)
    .long L_0045128b - .text + 0x401000
    .long L_00451295 - .text + 0x401000
    .long L_0045121d - .text + 0x401000
    .long L_004512aa - .text + 0x401000
    .long L_00451258 - .text + 0x401000
    .long L_004512e2 - .text + 0x401000
    .long L_004512f8 - .text + 0x401000
.org 0x0045132c - 0x401000
IDXTAB_0045132c:  # index table of FUN_004511d2 for the switch jump at 0x00451211 (17 byte(s))
    .byte 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5
    .byte 6
.set SWTAB_00451310_VA, SWTAB_00451310 - .text + 0x401000
.set IDXTAB_0045132c_VA, IDXTAB_0045132c - .text + 0x401000

