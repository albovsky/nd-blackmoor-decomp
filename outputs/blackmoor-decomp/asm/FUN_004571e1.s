# FUN_004571e1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004571e1
# extent:       0x004571e1-0x0045741d (572 code bytes)
# span:         0x004571e1-0x0045741d (code 572, tables 0, padding 0)
# sha256:       d476e8318bd1bdbb9e82ec64aacce23fccfd7f8efb4ed8f0920e56fdfb000660
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004571e1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_37, field_3b, field_3e, field_43, field_63, field_26b; [ecx + n] field_25, field_2a, field_2c, field_47, field_4b, field_4f, field_53, field_5b, field_5f, field_277; [edx + n] field_1e, field_3f, field_57, field_97, field_9b, field_9f, field_a3, field_26f, field_273
# callees:      calls FUN_0045741d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 166 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_37, 0x37  # offset +0x37
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3e, 0x3e  # offset +0x3e
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_47, 0x47  # offset +0x47
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_57, 0x57  # offset +0x57
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_63, 0x63  # offset +0x63
.equ field_97, 0x97  # offset +0x97
.equ field_9b, 0x9b  # offset +0x9b
.equ field_9f, 0x9f  # offset +0x9f
.equ field_a3, 0xa3  # offset +0xa3
.equ field_26b, 0x26b  # offset +0x26b
.equ field_26f, 0x26f  # offset +0x26f
.equ field_273, 0x273  # offset +0x273
.equ field_277, 0x277  # offset +0x277

# --- external targets -----------------------------------------------
.set FUN_0045741d, .text + (0x0045741d - 0x401000)

.org 0x004571e1 - 0x401000
.globl FUN_004571e1
FUN_004571e1:
    # block 0x004571e1: entry, 7 instruction(s), ends with je to 0x00457415 (forward)
    push ebp                                     # 004571e1
    {load} mov ebp, esp                          # 004571e2
    sub esp, 0xc                                 # 004571e4
    mov dword ptr [ebp - local_c], ecx           # 004571e7
    mov eax, dword ptr [ebp - local_c]           # 004571ea
    cmp dword ptr [eax + field_3e], 0x0          # 004571ed
    je.d32 L_00457415                            # 004571f1
    # block 0x004571f7: entered by fall-through of je at 0x004571f1, 3 instruction(s), ends with jne to 0x00457415 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004571f7
    cmp dword ptr [ecx + field_2c], 0x0          # 004571fa
    jne.d32 L_00457415                           # 004571fe
    # block 0x00457204: entered by fall-through of jne at 0x004571fe, 11 instruction(s), ends with jl to 0x0045726d (forward)
    mov edx, dword ptr [ebp - local_c]           # 00457204
    movsx eax, word ptr [edx + field_1e]         # 00457207
    imul eax, eax, 0x8d                          # 0045720b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00457211
    mov dword ptr [ebp - local_4], ecx           # 00457217
    movsx edx, word ptr [ebp + arg_c]            # 0045721a
    mov eax, dword ptr [ebp - local_4]           # 0045721e
    mov ecx, dword ptr [eax + field_3b]          # 00457221
    sub ecx, 0x5                                 # 00457224
    {load} cmp edx, ecx                          # 00457227
    jl.d8 L_0045726d                             # 00457229
    # block 0x0045722b: entered by fall-through of jl at 0x00457229, 6 instruction(s), ends with jg to 0x0045726d (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045722b
    mov eax, dword ptr [ebp - local_4]           # 0045722f
    mov ecx, dword ptr [eax + field_43]          # 00457232
    add ecx, 0x5                                 # 00457235
    {load} cmp edx, ecx                          # 00457238
    jg.d8 L_0045726d                             # 0045723a
    # block 0x0045723c: entered by fall-through of jg at 0x0045723a, 4 instruction(s), ends with jl to 0x0045726d (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0045723c
    mov eax, dword ptr [ebp - local_4]           # 00457240
    cmp edx, dword ptr [eax + field_37]          # 00457243
    jl.d8 L_0045726d                             # 00457246
    # block 0x00457248: entered by fall-through of jl at 0x00457246, 4 instruction(s), ends with jg to 0x0045726d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00457248
    mov edx, dword ptr [ebp - local_4]           # 0045724c
    cmp ecx, dword ptr [edx + field_3f]          # 0045724f
    jg.d8 L_0045726d                             # 00457252
    # block 0x00457254: entered by fall-through of jg at 0x00457252, 6 instruction(s), calls FUN_0045741d, ends with forward jump to 0x00457417
    push 0x0                                     # 00457254
    push 0x27bc                                  # 00457256
    mov ecx, dword ptr [ebp - local_c]           # 0045725b
    call FUN_0045741d                            # 0045725e
    mov eax, 0x1                                 # 00457263
    jmp.d32 L_00457417                           # 00457268
L_0045726d:
    # block 0x0045726d: entered by jl at 0x00457229; jg at 0x0045723a; jl at 0x00457246; jg at 0x00457252, 6 instruction(s), ends with jl to 0x004572ca (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045726d
    mov ecx, dword ptr [ebp - local_4]           # 00457271
    mov edx, dword ptr [ecx + field_4b]          # 00457274
    add edx, 0x5                                 # 00457277
    {load} cmp eax, edx                          # 0045727a
    jl.d8 L_004572ca                             # 0045727c
    # block 0x0045727e: entered by fall-through of jl at 0x0045727c, 6 instruction(s), ends with jg to 0x004572ca (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045727e
    mov ecx, dword ptr [ebp - local_4]           # 00457282
    mov edx, dword ptr [ecx + field_53]          # 00457285
    add edx, 0x5                                 # 00457288
    {load} cmp eax, edx                          # 0045728b
    jg.d8 L_004572ca                             # 0045728d
    # block 0x0045728f: entered by fall-through of jg at 0x0045728d, 6 instruction(s), ends with jl to 0x004572ca (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045728f
    mov ecx, dword ptr [ebp - local_4]           # 00457293
    mov edx, dword ptr [ecx + field_47]          # 00457296
    add edx, 0xa                                 # 00457299
    {load} cmp eax, edx                          # 0045729c
    jl.d8 L_004572ca                             # 0045729e
    # block 0x004572a0: entered by fall-through of jl at 0x0045729e, 6 instruction(s), ends with jg to 0x004572ca (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004572a0
    mov ecx, dword ptr [ebp - local_4]           # 004572a4
    mov edx, dword ptr [ecx + field_4f]          # 004572a7
    sub edx, 0xa                                 # 004572aa
    {load} cmp eax, edx                          # 004572ad
    jg.d8 L_004572ca                             # 004572af
    # block 0x004572b1: entered by fall-through of jg at 0x004572af, 6 instruction(s), calls FUN_0045741d, ends with forward jump to 0x00457417
    push 0x1                                     # 004572b1
    push 0x27bc                                  # 004572b3
    mov ecx, dword ptr [ebp - local_c]           # 004572b8
    call FUN_0045741d                            # 004572bb
    mov eax, 0x1                                 # 004572c0
    jmp.d32 L_00457417                           # 004572c5
L_004572ca:
    # block 0x004572ca: entered by jl at 0x0045727c; jg at 0x0045728d; jl at 0x0045729e; jg at 0x004572af, 4 instruction(s), ends with jl to 0x00457313 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004572ca
    mov ecx, dword ptr [ebp - local_4]           # 004572ce
    cmp eax, dword ptr [ecx + field_5b]          # 004572d1
    jl.d8 L_00457313                             # 004572d4
    # block 0x004572d6: entered by fall-through of jl at 0x004572d4, 4 instruction(s), ends with jg to 0x00457313 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004572d6
    mov eax, dword ptr [ebp - local_4]           # 004572da
    cmp edx, dword ptr [eax + field_63]          # 004572dd
    jg.d8 L_00457313                             # 004572e0
    # block 0x004572e2: entered by fall-through of jg at 0x004572e0, 4 instruction(s), ends with jl to 0x00457313 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004572e2
    mov edx, dword ptr [ebp - local_4]           # 004572e6
    cmp ecx, dword ptr [edx + field_57]          # 004572e9
    jl.d8 L_00457313                             # 004572ec
    # block 0x004572ee: entered by fall-through of jl at 0x004572ec, 4 instruction(s), ends with jg to 0x00457313 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004572ee
    mov ecx, dword ptr [ebp - local_4]           # 004572f2
    cmp eax, dword ptr [ecx + field_5f]          # 004572f5
    jg.d8 L_00457313                             # 004572f8
    # block 0x004572fa: entered by fall-through of jg at 0x004572f8, 6 instruction(s), calls FUN_0045741d, ends with forward jump to 0x00457417
    push 0x2                                     # 004572fa
    push 0x27bc                                  # 004572fc
    mov ecx, dword ptr [ebp - local_c]           # 00457301
    call FUN_0045741d                            # 00457304
    mov eax, 0x1                                 # 00457309
    jmp.d32 L_00457417                           # 0045730e
L_00457313:
    # block 0x00457313: entered by jl at 0x004572d4; jg at 0x004572e0; jl at 0x004572ec; jg at 0x004572f8, 2 instruction(s), ends with forward jump to 0x00457327
    mov word ptr [ebp - local_8], 0x0            # 00457313
    jmp.d8 L_00457327                            # 00457319
L_0045731b:
    # block 0x0045731b: entered by jmp at 0x004573be, 3 instruction(s), falls into the block at 0x00457327
    mov dx, word ptr [ebp - local_8]             # 0045731b
    add dx, 0x1                                  # 0045731f
    mov word ptr [ebp - local_8], dx             # 00457323
L_00457327:
    # block 0x00457327: entered by jmp at 0x00457319, 5 instruction(s), ends with jge to 0x004573c3 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00457327
    mov ecx, dword ptr [ebp - local_4]           # 0045732b
    movsx edx, word ptr [ecx + field_25]         # 0045732e
    {load} cmp eax, edx                          # 00457332
    jge.d32 L_004573c3                           # 00457334
    # block 0x0045733a: entered by fall-through of jge at 0x00457334, 6 instruction(s), ends with jl to 0x004573be (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045733a
    movsx ecx, word ptr [ebp - local_8]          # 0045733e
    shl ecx, 0x4                                 # 00457342
    mov edx, dword ptr [ebp - local_4]           # 00457345
    cmp eax, dword ptr [edx + ecx + field_9b]    # 00457348
    jl.d8 L_004573be                             # 0045734f
    # block 0x00457351: entered by fall-through of jl at 0x0045734f, 6 instruction(s), ends with jg to 0x004573be (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00457351
    movsx ecx, word ptr [ebp - local_8]          # 00457355
    shl ecx, 0x4                                 # 00457359
    mov edx, dword ptr [ebp - local_4]           # 0045735c
    cmp eax, dword ptr [edx + ecx + field_a3]    # 0045735f
    jg.d8 L_004573be                             # 00457366
    # block 0x00457368: entered by fall-through of jg at 0x00457366, 6 instruction(s), ends with jl to 0x004573be (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00457368
    movsx ecx, word ptr [ebp - local_8]          # 0045736c
    shl ecx, 0x4                                 # 00457370
    mov edx, dword ptr [ebp - local_4]           # 00457373
    cmp eax, dword ptr [edx + ecx + field_97]    # 00457376
    jl.d8 L_004573be                             # 0045737d
    # block 0x0045737f: entered by fall-through of jl at 0x0045737d, 6 instruction(s), ends with jg to 0x004573be (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045737f
    movsx ecx, word ptr [ebp - local_8]          # 00457383
    shl ecx, 0x4                                 # 00457387
    mov edx, dword ptr [ebp - local_4]           # 0045738a
    cmp eax, dword ptr [edx + ecx + field_9f]    # 0045738d
    jg.d8 L_004573be                             # 00457394
    # block 0x00457396: entered by fall-through of jg at 0x00457394, 5 instruction(s), ends with je to 0x004573b7 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00457396
    mov ecx, dword ptr [ebp - local_c]           # 0045739a
    movsx edx, word ptr [ecx + field_2a]         # 0045739d
    {load} cmp eax, edx                          # 004573a1
    je.d8 L_004573b7                             # 004573a3
    # block 0x004573a5: entered by fall-through of je at 0x004573a3, 5 instruction(s), calls FUN_0045741d, falls into the block at 0x004573b7
    mov ax, word ptr [ebp - local_8]             # 004573a5
    push eax                                     # 004573a9
    push 0x27be                                  # 004573aa
    mov ecx, dword ptr [ebp - local_c]           # 004573af
    call FUN_0045741d                            # 004573b2
L_004573b7:
    # block 0x004573b7: entered by je at 0x004573a3, 2 instruction(s), ends with forward jump to 0x00457417
    mov eax, 0x1                                 # 004573b7
    jmp.d8 L_00457417                            # 004573bc
L_004573be:
    # block 0x004573be: entered by jl at 0x0045734f; jg at 0x00457366; jl at 0x0045737d; jg at 0x00457394, 1 instruction(s), ends with backward jump to 0x0045731b
    jmp.d32 L_0045731b                           # 004573be
L_004573c3:
    # block 0x004573c3: entered by jge at 0x00457334, 4 instruction(s), ends with jl to 0x00457415 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004573c3
    mov edx, dword ptr [ebp - local_4]           # 004573c7
    cmp ecx, dword ptr [edx + field_26f]         # 004573ca
    jl.d8 L_00457415                             # 004573d0
    # block 0x004573d2: entered by fall-through of jl at 0x004573d0, 4 instruction(s), ends with jg to 0x00457415 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004573d2
    mov ecx, dword ptr [ebp - local_4]           # 004573d6
    cmp eax, dword ptr [ecx + field_277]         # 004573d9
    jg.d8 L_00457415                             # 004573df
    # block 0x004573e1: entered by fall-through of jg at 0x004573df, 4 instruction(s), ends with jl to 0x00457415 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004573e1
    mov eax, dword ptr [ebp - local_4]           # 004573e5
    cmp edx, dword ptr [eax + field_26b]         # 004573e8
    jl.d8 L_00457415                             # 004573ee
    # block 0x004573f0: entered by fall-through of jl at 0x004573ee, 4 instruction(s), ends with jg to 0x00457415 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004573f0
    mov edx, dword ptr [ebp - local_4]           # 004573f4
    cmp ecx, dword ptr [edx + field_273]         # 004573f7
    jg.d8 L_00457415                             # 004573fd
    # block 0x004573ff: entered by fall-through of jg at 0x004573fd, 6 instruction(s), calls FUN_0045741d, ends with forward jump to 0x00457417
    push 0x0                                     # 004573ff
    push 0x27bd                                  # 00457401
    mov ecx, dword ptr [ebp - local_c]           # 00457406
    call FUN_0045741d                            # 00457409
    mov eax, 0x1                                 # 0045740e
    jmp.d8 L_00457417                            # 00457413
L_00457415:
    # block 0x00457415: entered by je at 0x004571f1; jne at 0x004571fe; jl at 0x004573d0; jg at 0x004573df; more, 1 instruction(s), falls into the block at 0x00457417
    {load} xor eax, eax                          # 00457415
L_00457417:
    # block 0x00457417: entered by jmp at 0x00457268; jmp at 0x004572c5; jmp at 0x0045730e; jmp at 0x004573bc; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00457417
    pop ebp                                      # 00457419
    ret 0x8                                      # 0045741a

