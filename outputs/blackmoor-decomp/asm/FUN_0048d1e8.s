# FUN_0048d1e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d1e8
# extent:       0x0048d1e8-0x0048d3cb (483 code bytes)
# span:         0x0048d1e8-0x0048d3cb (code 483, tables 0, padding 0)
# sha256:       b2ed89cebeda856c985443892513c937b076e3ff8f20fbfdaa1ce4ad3f465a32
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48d1e8_hit_test
# naming:       native port src/original_methods_fl19a.c:m48d1e8_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48d1e8_hit_test. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 483 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_33, field_113, field_117, field_11b, field_11f, field_7b7; [ecx + n] field_1e, field_21, field_24, field_26, field_7af, field_7b3; [edx + n] field_21, field_27, field_203, field_207, field_20b, field_20f, field_7ab
# callees:      calls FUN_0048d3cb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19a.c:m48d1e8_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 134 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_33, 0x33  # offset +0x33
.equ field_113, 0x113  # offset +0x113
.equ field_117, 0x117  # offset +0x117
.equ field_11b, 0x11b  # offset +0x11b
.equ field_11f, 0x11f  # offset +0x11f
.equ field_203, 0x203  # offset +0x203
.equ field_207, 0x207  # offset +0x207
.equ field_20b, 0x20b  # offset +0x20b
.equ field_20f, 0x20f  # offset +0x20f
.equ field_7ab, 0x7ab  # offset +0x7ab
.equ field_7af, 0x7af  # offset +0x7af
.equ field_7b3, 0x7b3  # offset +0x7b3
.equ field_7b7, 0x7b7  # offset +0x7b7

# --- external targets -----------------------------------------------
.set FUN_0048d3cb, .text + (0x0048d3cb - 0x401000)

.org 0x0048d1e8 - 0x401000
.globl FUN_0048d1e8
FUN_0048d1e8:
    # block 0x0048d1e8: entry, 7 instruction(s), ends with je to 0x0048d3c3 (forward)
    push ebp                                     # 0048d1e8
    {load} mov ebp, esp                          # 0048d1e9
    sub esp, 0xc                                 # 0048d1eb
    mov dword ptr [ebp - local_c], ecx           # 0048d1ee
    mov eax, dword ptr [ebp - local_c]           # 0048d1f1
    cmp dword ptr [eax + field_33], 0x0          # 0048d1f4
    je.d32 L_0048d3c3                            # 0048d1f8
    # block 0x0048d1fe: entered by fall-through of je at 0x0048d1f8, 10 instruction(s), ends with jne to 0x0048d275 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048d1fe
    movsx edx, word ptr [ecx + field_1e]         # 0048d201
    imul edx, edx, 0x8d                          # 0048d205
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0048d20b
    mov dword ptr [ebp - local_4], eax           # 0048d211
    mov ecx, dword ptr [ebp - local_c]           # 0048d214
    {load} xor edx, edx                          # 0048d217
    mov dl, byte ptr [ecx + field_26]            # 0048d219
    test edx, edx                                # 0048d21c
    jne.d8 L_0048d275                            # 0048d21e
    # block 0x0048d220: entered by fall-through of jne at 0x0048d21e, 4 instruction(s), ends with jl to 0x0048d275 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048d220
    mov ecx, dword ptr [ebp - local_4]           # 0048d224
    cmp eax, dword ptr [ecx + field_7af]         # 0048d227
    jl.d8 L_0048d275                             # 0048d22d
    # block 0x0048d22f: entered by fall-through of jl at 0x0048d22d, 4 instruction(s), ends with jg to 0x0048d275 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048d22f
    mov eax, dword ptr [ebp - local_4]           # 0048d233
    cmp edx, dword ptr [eax + field_7b7]         # 0048d236
    jg.d8 L_0048d275                             # 0048d23c
    # block 0x0048d23e: entered by fall-through of jg at 0x0048d23c, 4 instruction(s), ends with jl to 0x0048d275 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048d23e
    mov edx, dword ptr [ebp - local_4]           # 0048d242
    cmp ecx, dword ptr [edx + field_7ab]         # 0048d245
    jl.d8 L_0048d275                             # 0048d24b
    # block 0x0048d24d: entered by fall-through of jl at 0x0048d24b, 4 instruction(s), ends with jg to 0x0048d275 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048d24d
    mov ecx, dword ptr [ebp - local_4]           # 0048d251
    cmp eax, dword ptr [ecx + field_7b3]         # 0048d254
    jg.d8 L_0048d275                             # 0048d25a
    # block 0x0048d25c: entered by fall-through of jg at 0x0048d25a, 6 instruction(s), calls FUN_0048d3cb, ends with forward jump to 0x0048d3c5
    push 0x0                                     # 0048d25c
    push 0x2766                                  # 0048d25e
    mov ecx, dword ptr [ebp - local_c]           # 0048d263
    call FUN_0048d3cb                            # 0048d266
    mov eax, 0x1                                 # 0048d26b
    jmp.d32 L_0048d3c5                           # 0048d270
L_0048d275:
    # block 0x0048d275: entered by jne at 0x0048d21e; jl at 0x0048d22d; jg at 0x0048d23c; jl at 0x0048d24b; jg at 0x0048d25a, 2 instruction(s), ends with forward jump to 0x0048d289
    mov word ptr [ebp - local_8], 0x0            # 0048d275
    jmp.d8 L_0048d289                            # 0048d27b
L_0048d27d:
    # block 0x0048d27d: entered by jmp at 0x0048d310, 3 instruction(s), falls into the block at 0x0048d289
    mov dx, word ptr [ebp - local_8]             # 0048d27d
    add dx, 0x1                                  # 0048d281
    mov word ptr [ebp - local_8], dx             # 0048d285
L_0048d289:
    # block 0x0048d289: entered by jmp at 0x0048d27b, 5 instruction(s), ends with jge to 0x0048d315 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0048d289
    mov ecx, dword ptr [ebp - local_4]           # 0048d28d
    movsx edx, word ptr [ecx + field_21]         # 0048d290
    {load} cmp eax, edx                          # 0048d294
    jge.d8 L_0048d315                            # 0048d296
    # block 0x0048d298: entered by fall-through of jge at 0x0048d296, 6 instruction(s), ends with jl to 0x0048d310 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048d298
    movsx ecx, word ptr [ebp - local_8]          # 0048d29c
    shl ecx, 0x4                                 # 0048d2a0
    mov edx, dword ptr [ebp - local_4]           # 0048d2a3
    cmp eax, dword ptr [edx + ecx + field_207]   # 0048d2a6
    jl.d8 L_0048d310                             # 0048d2ad
    # block 0x0048d2af: entered by fall-through of jl at 0x0048d2ad, 6 instruction(s), ends with jg to 0x0048d310 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048d2af
    movsx ecx, word ptr [ebp - local_8]          # 0048d2b3
    shl ecx, 0x4                                 # 0048d2b7
    mov edx, dword ptr [ebp - local_4]           # 0048d2ba
    cmp eax, dword ptr [edx + ecx + field_20f]   # 0048d2bd
    jg.d8 L_0048d310                             # 0048d2c4
    # block 0x0048d2c6: entered by fall-through of jg at 0x0048d2c4, 6 instruction(s), ends with jl to 0x0048d310 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048d2c6
    movsx ecx, word ptr [ebp - local_8]          # 0048d2ca
    shl ecx, 0x4                                 # 0048d2ce
    mov edx, dword ptr [ebp - local_4]           # 0048d2d1
    cmp eax, dword ptr [edx + ecx + field_203]   # 0048d2d4
    jl.d8 L_0048d310                             # 0048d2db
    # block 0x0048d2dd: entered by fall-through of jl at 0x0048d2db, 6 instruction(s), ends with jg to 0x0048d310 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048d2dd
    movsx ecx, word ptr [ebp - local_8]          # 0048d2e1
    shl ecx, 0x4                                 # 0048d2e5
    mov edx, dword ptr [ebp - local_4]           # 0048d2e8
    cmp eax, dword ptr [edx + ecx + field_20b]   # 0048d2eb
    jg.d8 L_0048d310                             # 0048d2f2
    # block 0x0048d2f4: entered by fall-through of jg at 0x0048d2f2, 7 instruction(s), calls FUN_0048d3cb, ends with forward jump to 0x0048d3c5
    mov ax, word ptr [ebp - local_8]             # 0048d2f4
    push eax                                     # 0048d2f8
    push 0x2765                                  # 0048d2f9
    mov ecx, dword ptr [ebp - local_c]           # 0048d2fe
    call FUN_0048d3cb                            # 0048d301
    mov eax, 0x1                                 # 0048d306
    jmp.d32 L_0048d3c5                           # 0048d30b
L_0048d310:
    # block 0x0048d310: entered by jl at 0x0048d2ad; jg at 0x0048d2c4; jl at 0x0048d2db; jg at 0x0048d2f2, 1 instruction(s), ends with backward jump to 0x0048d27d
    jmp.d32 L_0048d27d                           # 0048d310
L_0048d315:
    # block 0x0048d315: entered by jge at 0x0048d296, 5 instruction(s), ends with je to 0x0048d3c3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048d315
    {load} xor edx, edx                          # 0048d318
    mov dl, byte ptr [ecx + field_26]            # 0048d31a
    test edx, edx                                # 0048d31d
    je.d32 L_0048d3c3                            # 0048d31f
    # block 0x0048d325: entered by fall-through of je at 0x0048d31f, 2 instruction(s), ends with forward jump to 0x0048d339
    mov word ptr [ebp - local_8], 0x0            # 0048d325
    jmp.d8 L_0048d339                            # 0048d32b
L_0048d32d:
    # block 0x0048d32d: entered by jmp at 0x0048d3be, 3 instruction(s), falls into the block at 0x0048d339
    mov ax, word ptr [ebp - local_8]             # 0048d32d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0048d331
    mov word ptr [ebp - local_8], ax             # 0048d335
L_0048d339:
    # block 0x0048d339: entered by jmp at 0x0048d32b, 5 instruction(s), ends with jge to 0x0048d3c3 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0048d339
    mov edx, dword ptr [ebp - local_4]           # 0048d33d
    movsx eax, word ptr [edx + field_21]         # 0048d340
    {load} cmp ecx, eax                          # 0048d344
    jge.d8 L_0048d3c3                            # 0048d346
    # block 0x0048d348: entered by fall-through of jge at 0x0048d346, 6 instruction(s), ends with jl to 0x0048d3be (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048d348
    movsx edx, word ptr [ebp - local_8]          # 0048d34c
    shl edx, 0x4                                 # 0048d350
    mov eax, dword ptr [ebp - local_4]           # 0048d353
    cmp ecx, dword ptr [eax + edx + field_117]   # 0048d356
    jl.d8 L_0048d3be                             # 0048d35d
    # block 0x0048d35f: entered by fall-through of jl at 0x0048d35d, 6 instruction(s), ends with jg to 0x0048d3be (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048d35f
    movsx edx, word ptr [ebp - local_8]          # 0048d363
    shl edx, 0x4                                 # 0048d367
    mov eax, dword ptr [ebp - local_4]           # 0048d36a
    cmp ecx, dword ptr [eax + edx + field_11f]   # 0048d36d
    jg.d8 L_0048d3be                             # 0048d374
    # block 0x0048d376: entered by fall-through of jg at 0x0048d374, 6 instruction(s), ends with jl to 0x0048d3be (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048d376
    movsx edx, word ptr [ebp - local_8]          # 0048d37a
    shl edx, 0x4                                 # 0048d37e
    mov eax, dword ptr [ebp - local_4]           # 0048d381
    cmp ecx, dword ptr [eax + edx + field_113]   # 0048d384
    jl.d8 L_0048d3be                             # 0048d38b
    # block 0x0048d38d: entered by fall-through of jl at 0x0048d38b, 6 instruction(s), ends with jg to 0x0048d3be (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048d38d
    movsx edx, word ptr [ebp - local_8]          # 0048d391
    shl edx, 0x4                                 # 0048d395
    mov eax, dword ptr [ebp - local_4]           # 0048d398
    cmp ecx, dword ptr [eax + edx + field_11b]   # 0048d39b
    jg.d8 L_0048d3be                             # 0048d3a2
    # block 0x0048d3a4: entered by fall-through of jg at 0x0048d3a2, 5 instruction(s), ends with jne to 0x0048d3be (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0048d3a4
    mov edx, dword ptr [ebp - local_c]           # 0048d3a8
    movsx eax, word ptr [edx + field_27]         # 0048d3ab
    {load} cmp ecx, eax                          # 0048d3af
    jne.d8 L_0048d3be                            # 0048d3b1
    # block 0x0048d3b3: entered by fall-through of jne at 0x0048d3b1, 4 instruction(s), ends with forward jump to 0x0048d3c5
    mov ecx, dword ptr [ebp - local_c]           # 0048d3b3
    mov byte ptr [ecx + field_24], 0x1           # 0048d3b6
    {load} xor eax, eax                          # 0048d3ba
    jmp.d8 L_0048d3c5                            # 0048d3bc
L_0048d3be:
    # block 0x0048d3be: entered by jl at 0x0048d35d; jg at 0x0048d374; jl at 0x0048d38b; jg at 0x0048d3a2; jne at 0x0048d3b1, 1 instruction(s), ends with backward jump to 0x0048d32d
    jmp.d32 L_0048d32d                           # 0048d3be
L_0048d3c3:
    # block 0x0048d3c3: entered by je at 0x0048d1f8; je at 0x0048d31f; jge at 0x0048d346, 1 instruction(s), falls into the block at 0x0048d3c5
    {load} xor eax, eax                          # 0048d3c3
L_0048d3c5:
    # block 0x0048d3c5: entered by jmp at 0x0048d270; jmp at 0x0048d30b; jmp at 0x0048d3bc, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048d3c5
    pop ebp                                      # 0048d3c7
    ret 0x8                                      # 0048d3c8

