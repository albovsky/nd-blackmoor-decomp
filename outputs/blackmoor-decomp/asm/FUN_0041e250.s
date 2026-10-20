# FUN_0041e250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e250
# extent:       0x0041e250-0x0041e33b (235 code bytes)
# span:         0x0041e250-0x0041e33b (code 235, tables 0, padding 0)
# sha256:       28fe16f9d2ba495cd2a03299064b8f4e39557efc4a6dde6f7cef06f939f880b2
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41e250_release_slot
# naming:       native port src/original_methods_fl28b.c:m41e250_release_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Releases one slot: free slot early return, the pointer free, four dword calls and the word count decrement with the signed floor at 0; every instruction and both directions of every jump executed. See tasks/fl28b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [ecx + n] field_1c, field_68e; [edx + n] field_6, field_1e, field_68e
# callees:      calls FUN_0051dc6c, FUN_004c2e5b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m41e250_release_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 65 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_68e, 0x68e  # offset +0x68e

# --- external targets -----------------------------------------------
.set FUN_004c2e5b, .text + (0x004c2e5b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041e250 - 0x401000
.globl FUN_0041e250
FUN_0041e250:
    # block 0x0041e250: entry, 10 instruction(s), ends with jne to 0x0041e272 (forward)
    push ebp                                     # 0041e250
    {load} mov ebp, esp                          # 0041e251
    sub esp, 0xc                                 # 0041e253
    mov dword ptr [ebp - local_c], ecx           # 0041e256
    movsx eax, word ptr [ebp + arg_8]            # 0041e259
    imul eax, eax, 0x16                          # 0041e25d
    mov ecx, dword ptr [ebp - local_c]           # 0041e260
    movsx edx, word ptr [ecx + eax + field_1c]   # 0041e263
    cmp edx, -0x1                                # 0041e268
    jne.d8 L_0041e272                            # 0041e26b
    # block 0x0041e26d: entered by fall-through of jne at 0x0041e26b, 1 instruction(s), ends with forward jump to 0x0041e335
    jmp.d32 L_0041e335                           # 0041e26d
L_0041e272:
    # block 0x0041e272: entered by jne at 0x0041e26b, 9 instruction(s), ends with je to 0x0041e2c3 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0041e272
    imul eax, eax, 0x16                          # 0041e276
    mov ecx, dword ptr [ebp - local_c]           # 0041e279
    mov word ptr [ecx + eax + field_1c], 0xffff  # 0041e27c
    movsx edx, word ptr [ebp + arg_8]            # 0041e283
    imul edx, edx, 0x16                          # 0041e287
    mov eax, dword ptr [ebp - local_c]           # 0041e28a
    cmp dword ptr [eax + edx + field_1e], 0x0    # 0041e28d
    je.d8 L_0041e2c3                             # 0041e292
    # block 0x0041e294: entered by fall-through of je at 0x0041e292, 13 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041e2c3
    movsx ecx, word ptr [ebp + arg_8]            # 0041e294
    imul ecx, ecx, 0x16                          # 0041e298
    mov edx, dword ptr [ebp - local_c]           # 0041e29b
    mov eax, dword ptr [edx + ecx + field_1e]    # 0041e29e
    mov dword ptr [ebp - local_8], eax           # 0041e2a2
    mov ecx, dword ptr [ebp - local_8]           # 0041e2a5
    push ecx                                     # 0041e2a8
    call FUN_0051dc6c                            # 0041e2a9
    add esp, 0x4                                 # 0041e2ae
    movsx edx, word ptr [ebp + arg_8]            # 0041e2b1
    imul edx, edx, 0x16                          # 0041e2b5
    mov eax, dword ptr [ebp - local_c]           # 0041e2b8
    mov dword ptr [eax + edx + field_1e], 0x0    # 0041e2bb
L_0041e2c3:
    # block 0x0041e2c3: entered by je at 0x0041e292, 2 instruction(s), ends with forward jump to 0x0041e2d7
    mov word ptr [ebp - local_4], 0x0            # 0041e2c3
    jmp.d8 L_0041e2d7                            # 0041e2c9
L_0041e2cb:
    # block 0x0041e2cb: entered by jmp at 0x0041e301, 3 instruction(s), falls into the block at 0x0041e2d7
    mov cx, word ptr [ebp - local_4]             # 0041e2cb
    add cx, 0x1                                  # 0041e2cf
    mov word ptr [ebp - local_4], cx             # 0041e2d3
L_0041e2d7:
    # block 0x0041e2d7: entered by jmp at 0x0041e2c9, 3 instruction(s), ends with jge to 0x0041e303 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041e2d7
    cmp edx, 0x4                                 # 0041e2db
    jge.d8 L_0041e303                            # 0041e2de
    # block 0x0041e2e0: entered by fall-through of jge at 0x0041e2de, 10 instruction(s), calls FUN_004c2e5b, ends with backward jump to 0x0041e2cb
    movsx eax, word ptr [ebp + arg_8]            # 0041e2e0
    imul eax, eax, 0x16                          # 0041e2e4
    mov ecx, dword ptr [ebp - local_c]           # 0041e2e7
    lea edx, [ecx + eax + field_1c]              # 0041e2ea
    movsx eax, word ptr [ebp - local_4]          # 0041e2ee
    mov ecx, dword ptr [edx + 4*eax + field_6]   # 0041e2f2
    push ecx                                     # 0041e2f6
    mov ecx, 0x5cf659                            # 0041e2f7
    call FUN_004c2e5b                            # 0041e2fc
    jmp.d8 L_0041e2cb                            # 0041e301
L_0041e303:
    # block 0x0041e303: entered by jge at 0x0041e2de, 9 instruction(s), ends with jge to 0x0041e335 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0041e303
    mov ax, word ptr [edx + field_68e]           # 0041e306
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0041e30d
    mov ecx, dword ptr [ebp - local_c]           # 0041e311
    mov word ptr [ecx + field_68e], ax           # 0041e314
    mov edx, dword ptr [ebp - local_c]           # 0041e31b
    movsx eax, word ptr [edx + field_68e]        # 0041e31e
    test eax, eax                                # 0041e325
    jge.d8 L_0041e335                            # 0041e327
    # block 0x0041e329: entered by fall-through of jge at 0x0041e327, 2 instruction(s), falls into the block at 0x0041e335
    mov ecx, dword ptr [ebp - local_c]           # 0041e329
    mov word ptr [ecx + field_68e], 0x0          # 0041e32c
L_0041e335:
    # block 0x0041e335: entered by jmp at 0x0041e26d; jge at 0x0041e327, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041e335
    pop ebp                                      # 0041e337
    ret 0x4                                      # 0041e338

