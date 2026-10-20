# FUN_004e812f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e812f
# extent:       0x004e812f-0x004e85fa (1227 code bytes)
# span:         0x004e812f-0x004e8622 (code 1227, tables 40, padding 0)
# sha256:       de2f5a57144a9b9f78478aa738bd18c36a97911d053e18b7f2d5e671a0c7b4e8
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_inventory_view_rebuild
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_bindings_a7d.h:26 says "the view rebuild 0x4e812f after the item is added back"; src/action_family_7d_runtime.h:31 says "which ends with the view rebuild 0x4e812f"
# name-note:    Rebuilds the inventory view (slots), e.g. after an item is added back.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_77e, field_7fae, field_822e, field_8252, field_825a, field_825e; [ecx + n] field_7fae, field_822e, field_8232, field_8252, field_825a, field_825e; [edx + n] field_7fae, field_822e, field_8232, field_825a, field_8262
# callees:      calls FUN_004ee69e, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:initialize_new_game (function ledger class candidate_port; also inventory_view_sync, native_a78_rebuild_view, native_a79_rebuild_view; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 284 instruction(s), 25 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_77e, 0x77e  # offset +0x77e
.equ field_7fae, 0x7fae  # offset +0x7fae
.equ field_822e, 0x822e  # offset +0x822e
.equ field_8232, 0x8232  # offset +0x8232
.equ field_8252, 0x8252  # offset +0x8252
.equ field_825a, 0x825a  # offset +0x825a
.equ field_825e, 0x825e  # offset +0x825e
.equ field_8262, 0x8262  # offset +0x8262

# --- external targets -----------------------------------------------
.set FUN_004ee69e, .text + (0x004ee69e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004e812f - 0x401000
.globl FUN_004e812f
FUN_004e812f:
    # block 0x004e812f: entry, 7 instruction(s), ends with forward jump to 0x004e815c
    push ebp                                     # 004e812f
    {load} mov ebp, esp                          # 004e8130
    sub esp, 0x20                                # 004e8132
    mov dword ptr [ebp - local_8], ecx           # 004e8135
    mov eax, dword ptr [ebp - local_8]           # 004e8138
    mov dword ptr [eax + field_822e], 0x0        # 004e813b
    jmp.d8 L_004e815c                            # 004e8145
L_004e8147:
    # block 0x004e8147: entered by jmp at 0x004e8182, 5 instruction(s), falls into the block at 0x004e815c
    mov ecx, dword ptr [ebp - local_8]           # 004e8147
    mov edx, dword ptr [ecx + field_822e]        # 004e814a
    add edx, 0x1                                 # 004e8150
    mov eax, dword ptr [ebp - local_8]           # 004e8153
    mov dword ptr [eax + field_822e], edx        # 004e8156
L_004e815c:
    # block 0x004e815c: entered by jmp at 0x004e8145, 3 instruction(s), ends with jge to 0x004e8184 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e815c
    cmp dword ptr [ecx + field_822e], 0x10       # 004e815f
    jge.d8 L_004e8184                            # 004e8166
    # block 0x004e8168: entered by fall-through of jge at 0x004e8166, 6 instruction(s), ends with backward jump to 0x004e8147
    mov edx, dword ptr [ebp - local_8]           # 004e8168
    mov eax, dword ptr [edx + field_822e]        # 004e816b
    imul eax, eax, 0x28                          # 004e8171
    mov ecx, dword ptr [ebp - local_8]           # 004e8174
    mov dword ptr [ecx + eax + field_7fae], 0xffffffff # 004e8177
    jmp.d8 L_004e8147                            # 004e8182
L_004e8184:
    # block 0x004e8184: entered by jge at 0x004e8166, 5 instruction(s), ends with forward jump to 0x004e81ba
    mov word ptr [0x583a2d], 0x0                 # 004e8184
    mov word ptr [0x583a2f], 0x0                 # 004e818d
    mov edx, dword ptr [ebp - local_8]           # 004e8196
    mov dword ptr [edx + field_822e], 0x0        # 004e8199
    jmp.d8 L_004e81ba                            # 004e81a3
L_004e81a5:
    # block 0x004e81a5: entered by jmp at 0x004e81ec, 5 instruction(s), falls into the block at 0x004e81ba
    mov eax, dword ptr [ebp - local_8]           # 004e81a5
    mov ecx, dword ptr [eax + field_822e]        # 004e81a8
    add ecx, 0x1                                 # 004e81ae
    mov edx, dword ptr [ebp - local_8]           # 004e81b1
    mov dword ptr [edx + field_822e], ecx        # 004e81b4
L_004e81ba:
    # block 0x004e81ba: entered by jmp at 0x004e81a3, 3 instruction(s), ends with jge to 0x004e81ee (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e81ba
    cmp dword ptr [eax + field_822e], 0x46       # 004e81bd
    jge.d8 L_004e81ee                            # 004e81c4
    # block 0x004e81c6: entered by fall-through of jge at 0x004e81c4, 7 instruction(s), ends with backward jump to 0x004e81a5
    mov ecx, dword ptr [ebp - local_8]           # 004e81c6
    mov edx, dword ptr [ecx + field_822e]        # 004e81c9
    mov word ptr [2*edx + 0x583abd], 0xffff      # 004e81cf
    mov eax, dword ptr [ebp - local_8]           # 004e81d9
    mov ecx, dword ptr [eax + field_822e]        # 004e81dc
    mov word ptr [2*ecx + 0x583b49], 0xffff      # 004e81e2
    jmp.d8 L_004e81a5                            # 004e81ec
L_004e81ee:
    # block 0x004e81ee: entered by jge at 0x004e81c4, 3 instruction(s), ends with forward jump to 0x004e8212
    mov edx, dword ptr [ebp - local_8]           # 004e81ee
    mov dword ptr [edx + field_822e], 0x0        # 004e81f1
    jmp.d8 L_004e8212                            # 004e81fb
L_004e81fd:
    # block 0x004e81fd: entered by jmp at 0x004e82e9, 5 instruction(s), falls into the block at 0x004e8212
    mov eax, dword ptr [ebp - local_8]           # 004e81fd
    mov ecx, dword ptr [eax + field_822e]        # 004e8200
    add ecx, 0x1                                 # 004e8206
    mov edx, dword ptr [ebp - local_8]           # 004e8209
    mov dword ptr [edx + field_822e], ecx        # 004e820c
L_004e8212:
    # block 0x004e8212: entered by jmp at 0x004e81fb, 4 instruction(s), ends with jge to 0x004e82ee (forward)
    movsx eax, word ptr [0x583a2b]               # 004e8212
    mov ecx, dword ptr [ebp - local_8]           # 004e8219
    cmp dword ptr [ecx + field_822e], eax        # 004e821c
    jge.d32 L_004e82ee                           # 004e8222
    # block 0x004e8228: entered by fall-through of jge at 0x004e8222, 10 instruction(s), ends with jne to 0x004e827a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e8228
    mov eax, dword ptr [edx + field_822e]        # 004e822b
    movsx ecx, word ptr [2*eax + 0x583a31]       # 004e8231
    mov dword ptr [ebp - local_4], ecx           # 004e8239
    mov edx, dword ptr [ebp - local_4]           # 004e823c
    imul edx, edx, 0x16d                         # 004e823f
    mov eax, dword ptr [ebp - local_8]           # 004e8245
    movsx ecx, word ptr [eax + edx + field_77e]  # 004e8248
    cmp ecx, 0x3                                 # 004e8250
    jne.d8 L_004e827a                            # 004e8253
    # block 0x004e8255: entered by fall-through of jne at 0x004e8253, 6 instruction(s), falls into the block at 0x004e827a
    movsx edx, word ptr [0x583a2d]               # 004e8255
    mov ax, word ptr [ebp - local_4]             # 004e825c
    mov word ptr [2*edx + 0x583abd], ax          # 004e8260
    mov cx, word ptr [0x583a2d]                  # 004e8268
    add cx, 0x1                                  # 004e826f
    mov word ptr [0x583a2d], cx                  # 004e8273
L_004e827a:
    # block 0x004e827a: entered by jne at 0x004e8253, 6 instruction(s), ends with je to 0x004e82c4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e827a
    imul edx, edx, 0x16d                         # 004e827d
    mov eax, dword ptr [ebp - local_8]           # 004e8283
    movsx ecx, word ptr [eax + edx + field_77e]  # 004e8286
    test ecx, ecx                                # 004e828e
    je.d8 L_004e82c4                             # 004e8290
    # block 0x004e8292: entered by fall-through of je at 0x004e8290, 6 instruction(s), ends with je to 0x004e82c4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e8292
    imul edx, edx, 0x16d                         # 004e8295
    mov eax, dword ptr [ebp - local_8]           # 004e829b
    movsx ecx, word ptr [eax + edx + field_77e]  # 004e829e
    cmp ecx, 0x1                                 # 004e82a6
    je.d8 L_004e82c4                             # 004e82a9
    # block 0x004e82ab: entered by fall-through of je at 0x004e82a9, 6 instruction(s), ends with jne to 0x004e82e9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e82ab
    imul edx, edx, 0x16d                         # 004e82ae
    mov eax, dword ptr [ebp - local_8]           # 004e82b4
    movsx ecx, word ptr [eax + edx + field_77e]  # 004e82b7
    cmp ecx, 0x2                                 # 004e82bf
    jne.d8 L_004e82e9                            # 004e82c2
L_004e82c4:
    # block 0x004e82c4: entered by je at 0x004e8290; je at 0x004e82a9; fall-through of jne at 0x004e82c2, 6 instruction(s), falls into the block at 0x004e82e9
    movsx edx, word ptr [0x583a2f]               # 004e82c4
    mov ax, word ptr [ebp - local_4]             # 004e82cb
    mov word ptr [2*edx + 0x583b49], ax          # 004e82cf
    mov cx, word ptr [0x583a2f]                  # 004e82d7
    add cx, 0x1                                  # 004e82de
    mov word ptr [0x583a2f], cx                  # 004e82e2
L_004e82e9:
    # block 0x004e82e9: entered by jne at 0x004e82c2, 1 instruction(s), ends with backward jump to 0x004e81fd
    jmp.d32 L_004e81fd                           # 004e82e9
L_004e82ee:
    # block 0x004e82ee: entered by jge at 0x004e8222, 8 instruction(s), ends with ja to 0x004e8313 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e82ee
    mov eax, dword ptr [edx + field_8232]        # 004e82f1
    mov dword ptr [ebp - local_c], eax           # 004e82f7
    mov ecx, dword ptr [ebp - local_c]           # 004e82fa
    sub ecx, 0x65                                # 004e82fd
    mov dword ptr [ebp - local_c], ecx           # 004e8300
    cmp dword ptr [ebp - local_c], 0x4           # 004e8303
    ja.d8 L_004e8313                             # 004e8307
    # block 0x004e8309: entered by fall-through of ja at 0x004e8307, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e85fa]
    mov edx, dword ptr [ebp - local_c]           # 004e8309
    jmp dword ptr [4*edx + SWTAB_004e85fa_VA]    # 004e830c
L_004e8313:
    # block 0x004e8313: entered by ja at 0x004e8307, 3 instruction(s), ends with jne to 0x004e8330 (forward)
    movsx eax, word ptr [0x583a2b]               # 004e8313
    test eax, eax                                # 004e831a
    jne.d8 L_004e8330                            # 004e831c
    # block 0x004e831e: entered by fall-through of jne at 0x004e831c, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov ecx, dword ptr [ebp - local_8]           # 004e831e
    mov dword ptr [ecx + field_825a], 0x0        # 004e8321
    jmp.d32 L_004e85f6                           # 004e832b
L_004e8330:
    # block 0x004e8330: entered by jne at 0x004e831c, 3 instruction(s), ends with jne to 0x004e834b (forward)
    movsx edx, word ptr [0x583a2b]               # 004e8330
    cmp edx, 0x1                                 # 004e8337
    jne.d8 L_004e834b                            # 004e833a
    # block 0x004e833c: entered by fall-through of jne at 0x004e833a, 3 instruction(s), ends with forward jump to 0x004e838a
    mov eax, dword ptr [ebp - local_8]           # 004e833c
    mov dword ptr [eax + field_825a], 0x1        # 004e833f
    jmp.d8 L_004e838a                            # 004e8349
L_004e834b:
    # block 0x004e834b: entered by jne at 0x004e833a, 3 instruction(s), ends with jle to 0x004e8378 (forward)
    movsx ecx, word ptr [0x583a2b]               # 004e834b
    cmp ecx, 0x1                                 # 004e8352
    jle.d8 L_004e8378                            # 004e8355
    # block 0x004e8357: entered by fall-through of jle at 0x004e8355, 10 instruction(s), ends with forward jump to 0x004e838a
    movsx eax, word ptr [0x583a2b]               # 004e8357
    sub eax, 0x1                                 # 004e835e
    cdq                                          # 004e8361
    and edx, 0xf                                 # 004e8362
    {load} add eax, edx                          # 004e8365
    sar eax, 0x4                                 # 004e8367
    add eax, 0x1                                 # 004e836a
    mov edx, dword ptr [ebp - local_8]           # 004e836d
    mov dword ptr [edx + field_825a], eax        # 004e8370
    jmp.d8 L_004e838a                            # 004e8376
L_004e8378:
    # block 0x004e8378: entered by jle at 0x004e8355, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov eax, dword ptr [ebp - local_8]           # 004e8378
    mov dword ptr [eax + field_825a], 0x0        # 004e837b
    jmp.d32 L_004e85f6                           # 004e8385
L_004e838a:
    # block 0x004e838a: entered by jmp at 0x004e8349; jmp at 0x004e8376, 1 instruction(s), ends with forward jump to 0x004e847f
    jmp.d32 L_004e847f                           # 004e838a
L_004e838f:
    # block 0x004e838f: entered by switch case, 3 instruction(s), ends with jne to 0x004e83ac (forward)
    movsx ecx, word ptr [0x583a2d]               # 004e838f
    test ecx, ecx                                # 004e8396
    jne.d8 L_004e83ac                            # 004e8398
    # block 0x004e839a: entered by fall-through of jne at 0x004e8398, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov edx, dword ptr [ebp - local_8]           # 004e839a
    mov dword ptr [edx + field_825a], 0x0        # 004e839d
    jmp.d32 L_004e85f6                           # 004e83a7
L_004e83ac:
    # block 0x004e83ac: entered by jne at 0x004e8398, 3 instruction(s), ends with jne to 0x004e83c7 (forward)
    movsx eax, word ptr [0x583a2d]               # 004e83ac
    cmp eax, 0x1                                 # 004e83b3
    jne.d8 L_004e83c7                            # 004e83b6
    # block 0x004e83b8: entered by fall-through of jne at 0x004e83b6, 3 instruction(s), ends with forward jump to 0x004e8406
    mov ecx, dword ptr [ebp - local_8]           # 004e83b8
    mov dword ptr [ecx + field_825a], 0x1        # 004e83bb
    jmp.d8 L_004e8406                            # 004e83c5
L_004e83c7:
    # block 0x004e83c7: entered by jne at 0x004e83b6, 3 instruction(s), ends with jle to 0x004e83f4 (forward)
    movsx edx, word ptr [0x583a2d]               # 004e83c7
    cmp edx, 0x1                                 # 004e83ce
    jle.d8 L_004e83f4                            # 004e83d1
    # block 0x004e83d3: entered by fall-through of jle at 0x004e83d1, 10 instruction(s), ends with forward jump to 0x004e8406
    movsx eax, word ptr [0x583a2d]               # 004e83d3
    sub eax, 0x1                                 # 004e83da
    cdq                                          # 004e83dd
    and edx, 0xf                                 # 004e83de
    {load} add eax, edx                          # 004e83e1
    sar eax, 0x4                                 # 004e83e3
    add eax, 0x1                                 # 004e83e6
    mov ecx, dword ptr [ebp - local_8]           # 004e83e9
    mov dword ptr [ecx + field_825a], eax        # 004e83ec
    jmp.d8 L_004e8406                            # 004e83f2
L_004e83f4:
    # block 0x004e83f4: entered by jle at 0x004e83d1, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov edx, dword ptr [ebp - local_8]           # 004e83f4
    mov dword ptr [edx + field_825a], 0x0        # 004e83f7
    jmp.d32 L_004e85f6                           # 004e8401
L_004e8406:
    # block 0x004e8406: entered by jmp at 0x004e83c5; jmp at 0x004e83f2, 1 instruction(s), ends with forward jump to 0x004e847f
    jmp.d8 L_004e847f                            # 004e8406
L_004e8408:
    # block 0x004e8408: entered by switch case, 3 instruction(s), ends with jne to 0x004e8425 (forward)
    movsx eax, word ptr [0x583a2f]               # 004e8408
    test eax, eax                                # 004e840f
    jne.d8 L_004e8425                            # 004e8411
    # block 0x004e8413: entered by fall-through of jne at 0x004e8411, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov ecx, dword ptr [ebp - local_8]           # 004e8413
    mov dword ptr [ecx + field_825a], 0x0        # 004e8416
    jmp.d32 L_004e85f6                           # 004e8420
L_004e8425:
    # block 0x004e8425: entered by jne at 0x004e8411, 3 instruction(s), ends with jne to 0x004e8440 (forward)
    movsx edx, word ptr [0x583a2f]               # 004e8425
    cmp edx, 0x1                                 # 004e842c
    jne.d8 L_004e8440                            # 004e842f
    # block 0x004e8431: entered by fall-through of jne at 0x004e842f, 3 instruction(s), ends with forward jump to 0x004e847f
    mov eax, dword ptr [ebp - local_8]           # 004e8431
    mov dword ptr [eax + field_825a], 0x1        # 004e8434
    jmp.d8 L_004e847f                            # 004e843e
L_004e8440:
    # block 0x004e8440: entered by jne at 0x004e842f, 3 instruction(s), ends with jle to 0x004e846d (forward)
    movsx ecx, word ptr [0x583a2f]               # 004e8440
    cmp ecx, 0x1                                 # 004e8447
    jle.d8 L_004e846d                            # 004e844a
    # block 0x004e844c: entered by fall-through of jle at 0x004e844a, 10 instruction(s), ends with forward jump to 0x004e847f
    movsx eax, word ptr [0x583a2f]               # 004e844c
    sub eax, 0x1                                 # 004e8453
    cdq                                          # 004e8456
    and edx, 0xf                                 # 004e8457
    {load} add eax, edx                          # 004e845a
    sar eax, 0x4                                 # 004e845c
    add eax, 0x1                                 # 004e845f
    mov edx, dword ptr [ebp - local_8]           # 004e8462
    mov dword ptr [edx + field_825a], eax        # 004e8465
    jmp.d8 L_004e847f                            # 004e846b
L_004e846d:
    # block 0x004e846d: entered by jle at 0x004e844a, 3 instruction(s), ends with forward jump to 0x004e85f6
    mov eax, dword ptr [ebp - local_8]           # 004e846d
    mov dword ptr [eax + field_825a], 0x0        # 004e8470
    jmp.d32 L_004e85f6                           # 004e847a
L_004e847f:
    # block 0x004e847f: entered by jmp at 0x004e838a; jmp at 0x004e8406; jmp at 0x004e843e; jmp at 0x004e846b; switch case, 31 instruction(s), calls FUN_004ee69e, FUN_0050ce04, ends with forward jump to 0x004e851f
    mov ecx, dword ptr [ebp - local_8]           # 004e847f
    fild dword ptr [ecx + field_825a]            # 004e8482
    fstp qword ptr [ebp - local_14]              # 004e8488
    fld qword ptr [0x52c598]                     # 004e848b
    fdiv qword ptr [ebp - local_14]              # 004e8491
    mov edx, dword ptr [ebp - local_8]           # 004e8494
    fstp dword ptr [edx + field_8262]            # 004e8497
    mov ecx, dword ptr [ebp - local_8]           # 004e849d
    call FUN_004ee69e                            # 004e84a0
    mov dword ptr [ebp - local_18], eax          # 004e84a5
    fild dword ptr [ebp - local_18]              # 004e84a8
    fstp dword ptr [ebp - local_1c]              # 004e84ab
    fld dword ptr [ebp - local_1c]               # 004e84ae
    fdiv dword ptr [0x52cbec]                    # 004e84b1
    mov eax, dword ptr [ebp - local_8]           # 004e84b7
    fstp dword ptr [eax + field_8252]            # 004e84ba
    mov ecx, dword ptr [ebp - local_8]           # 004e84c0
    mov edx, dword ptr [ebp - local_8]           # 004e84c3
    fld dword ptr [ecx + field_8252]             # 004e84c6
    fdiv dword ptr [edx + field_8262]            # 004e84cc
    call FUN_0050ce04                            # 004e84d2
    movsx eax, ax                                # 004e84d7
    mov ecx, dword ptr [ebp - local_8]           # 004e84da
    mov dword ptr [ecx + field_825e], eax        # 004e84dd
    mov edx, dword ptr [ebp - local_8]           # 004e84e3
    mov dword ptr [edx + field_822e], 0x0        # 004e84e6
    mov eax, dword ptr [ebp - local_8]           # 004e84f0
    mov ecx, dword ptr [eax + field_825e]        # 004e84f3
    shl ecx, 0x4                                 # 004e84f9
    mov dword ptr [ebp - local_4], ecx           # 004e84fc
    jmp.d8 L_004e851f                            # 004e84ff
L_004e8501:
    # block 0x004e8501: entered by jmp at 0x004e85f1, 8 instruction(s), falls into the block at 0x004e851f
    mov edx, dword ptr [ebp - local_8]           # 004e8501
    mov eax, dword ptr [edx + field_822e]        # 004e8504
    add eax, 0x1                                 # 004e850a
    mov ecx, dword ptr [ebp - local_8]           # 004e850d
    mov dword ptr [ecx + field_822e], eax        # 004e8510
    mov edx, dword ptr [ebp - local_4]           # 004e8516
    add edx, 0x1                                 # 004e8519
    mov dword ptr [ebp - local_4], edx           # 004e851c
L_004e851f:
    # block 0x004e851f: entered by jmp at 0x004e84ff, 3 instruction(s), ends with jge to 0x004e85f6 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e851f
    cmp dword ptr [eax + field_822e], 0x10       # 004e8522
    jge.d32 L_004e85f6                           # 004e8529
    # block 0x004e852f: entered by fall-through of jge at 0x004e8529, 8 instruction(s), ends with ja to 0x004e8554 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e852f
    mov edx, dword ptr [ecx + field_8232]        # 004e8532
    mov dword ptr [ebp - local_20], edx          # 004e8538
    mov eax, dword ptr [ebp - local_20]          # 004e853b
    sub eax, 0x65                                # 004e853e
    mov dword ptr [ebp - local_20], eax          # 004e8541
    cmp dword ptr [ebp - local_20], 0x4          # 004e8544
    ja.d8 L_004e8554                             # 004e8548
    # block 0x004e854a: entered by fall-through of ja at 0x004e8548, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4e860e]
    mov ecx, dword ptr [ebp - local_20]          # 004e854a
    jmp dword ptr [4*ecx + SWTAB_004e860e_VA]    # 004e854d
L_004e8554:
    # block 0x004e8554: entered by ja at 0x004e8548, 2 instruction(s), ends with jge to 0x004e8587 (forward)
    cmp dword ptr [ebp - local_4], 0x46          # 004e8554
    jge.d8 L_004e8587                            # 004e8558
    # block 0x004e855a: entered by fall-through of jge at 0x004e8558, 3 instruction(s), ends with jge to 0x004e8587 (forward)
    movsx edx, word ptr [0x583a2b]               # 004e855a
    cmp dword ptr [ebp - local_4], edx           # 004e8561
    jge.d8 L_004e8587                            # 004e8564
    # block 0x004e8566: entered by fall-through of jge at 0x004e8564, 7 instruction(s), falls into the block at 0x004e8587
    mov eax, dword ptr [ebp - local_4]           # 004e8566
    movsx ecx, word ptr [2*eax + 0x583a31]       # 004e8569
    mov edx, dword ptr [ebp - local_8]           # 004e8571
    mov eax, dword ptr [edx + field_822e]        # 004e8574
    imul eax, eax, 0x28                          # 004e857a
    mov edx, dword ptr [ebp - local_8]           # 004e857d
    mov dword ptr [edx + eax + field_7fae], ecx  # 004e8580
L_004e8587:
    # block 0x004e8587: entered by jge at 0x004e8558; jge at 0x004e8564, 1 instruction(s), ends with forward jump to 0x004e85f1
    jmp.d8 L_004e85f1                            # 004e8587
L_004e8589:
    # block 0x004e8589: entered by switch case, 2 instruction(s), ends with jge to 0x004e85bc (forward)
    cmp dword ptr [ebp - local_4], 0x46          # 004e8589
    jge.d8 L_004e85bc                            # 004e858d
    # block 0x004e858f: entered by fall-through of jge at 0x004e858d, 3 instruction(s), ends with jge to 0x004e85bc (forward)
    movsx eax, word ptr [0x583a2d]               # 004e858f
    cmp dword ptr [ebp - local_4], eax           # 004e8596
    jge.d8 L_004e85bc                            # 004e8599
    # block 0x004e859b: entered by fall-through of jge at 0x004e8599, 7 instruction(s), falls into the block at 0x004e85bc
    mov ecx, dword ptr [ebp - local_4]           # 004e859b
    movsx edx, word ptr [2*ecx + 0x583abd]       # 004e859e
    mov eax, dword ptr [ebp - local_8]           # 004e85a6
    mov ecx, dword ptr [eax + field_822e]        # 004e85a9
    imul ecx, ecx, 0x28                          # 004e85af
    mov eax, dword ptr [ebp - local_8]           # 004e85b2
    mov dword ptr [eax + ecx + field_7fae], edx  # 004e85b5
L_004e85bc:
    # block 0x004e85bc: entered by jge at 0x004e858d; jge at 0x004e8599, 1 instruction(s), ends with forward jump to 0x004e85f1
    jmp.d8 L_004e85f1                            # 004e85bc
L_004e85be:
    # block 0x004e85be: entered by switch case, 2 instruction(s), ends with jge to 0x004e85f1 (forward)
    cmp dword ptr [ebp - local_4], 0x46          # 004e85be
    jge.d8 L_004e85f1                            # 004e85c2
    # block 0x004e85c4: entered by fall-through of jge at 0x004e85c2, 3 instruction(s), ends with jge to 0x004e85f1 (forward)
    movsx ecx, word ptr [0x583a2f]               # 004e85c4
    cmp dword ptr [ebp - local_4], ecx           # 004e85cb
    jge.d8 L_004e85f1                            # 004e85ce
    # block 0x004e85d0: entered by fall-through of jge at 0x004e85ce, 7 instruction(s), falls into the block at 0x004e85f1
    mov edx, dword ptr [ebp - local_4]           # 004e85d0
    movsx eax, word ptr [2*edx + 0x583b49]       # 004e85d3
    mov ecx, dword ptr [ebp - local_8]           # 004e85db
    mov edx, dword ptr [ecx + field_822e]        # 004e85de
    imul edx, edx, 0x28                          # 004e85e4
    mov ecx, dword ptr [ebp - local_8]           # 004e85e7
    mov dword ptr [ecx + edx + field_7fae], eax  # 004e85ea
L_004e85f1:
    # block 0x004e85f1: entered by jmp at 0x004e8587; jmp at 0x004e85bc; jge at 0x004e85c2; jge at 0x004e85ce; switch case, 1 instruction(s), ends with backward jump to 0x004e8501
    jmp.d32 L_004e8501                           # 004e85f1
L_004e85f6:
    # block 0x004e85f6: entered by jmp at 0x004e832b; jmp at 0x004e8385; jmp at 0x004e83a7; jmp at 0x004e8401; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e85f6
    pop ebp                                      # 004e85f8
    ret                                          # 004e85f9

# --- data items (not part of the function) -------------------------
.org 0x004e85fa - 0x401000
SWTAB_004e85fa:  # 5 case address(es)
    .long L_004e838f - .text + 0x401000
    .long L_004e8408 - .text + 0x401000
    .long L_004e847f - .text + 0x401000
    .long L_004e847f - .text + 0x401000
    .long L_004e847f - .text + 0x401000
.org 0x004e860e - 0x401000
SWTAB_004e860e:  # 5 case address(es)
    .long L_004e8589 - .text + 0x401000
    .long L_004e85be - .text + 0x401000
    .long L_004e85f1 - .text + 0x401000
    .long L_004e85f1 - .text + 0x401000
    .long L_004e85f1 - .text + 0x401000
.set SWTAB_004e85fa_VA, SWTAB_004e85fa - .text + 0x401000
.set SWTAB_004e860e_VA, SWTAB_004e860e - .text + 0x401000

