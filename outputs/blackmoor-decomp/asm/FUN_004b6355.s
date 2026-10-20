# FUN_004b6355
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b6355
# extent:       0x004b6355-0x004b642d (216 code bytes)
# span:         0x004b6355-0x004b642d (code 216, tables 0, padding 0)
# sha256:       a4b9ee6370d0b14edfdf342a3cb3235a987d95adc50e01b7e08e5576a5c71c01
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         d1_geometry
# naming:       native port src/action_family_d1_runtime.c:d1_geometry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    d1_geometry reproduces the four-word rectangle (x from origin, frame*w*substeps, step*w; y with row flag * tile*h; -2+w and -2+h), 32-bit wrapping;
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_1e; [ecx + n] field_25, field_247, field_248, field_24c, field_250, field_252, field_minus_2
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d1_runtime.c:d1_geometry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 62 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_247, 0x247  # offset +0x247
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_252, 0x252  # offset +0x252

# --- external targets -----------------------------------------------

.org 0x004b6355 - 0x401000
.globl FUN_004b6355
FUN_004b6355:
    # block 0x004b6355: entry, 38 instruction(s), ends with jne to 0x004b63eb (forward)
    push ebp                                     # 004b6355
    {load} mov ebp, esp                          # 004b6356
    sub esp, 0x8                                 # 004b6358
    mov dword ptr [ebp - local_8], ecx           # 004b635b
    mov eax, dword ptr [ebp - local_8]           # 004b635e
    movsx ecx, word ptr [eax + field_1e]         # 004b6361
    imul ecx, ecx, 0x8d                          # 004b6365
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b636b
    mov dword ptr [ebp - local_4], edx           # 004b6371
    movsx eax, word ptr [ebp + arg_c]            # 004b6374
    mov ecx, dword ptr [ebp - local_4]           # 004b6378
    movsx edx, word ptr [ecx + field_250]        # 004b637b
    imul eax, edx                                # 004b6382
    mov ecx, dword ptr [ebp - local_4]           # 004b6385
    movsx edx, word ptr [ecx + field_25]         # 004b6388
    imul eax, edx                                # 004b638c
    mov ecx, dword ptr [ebp - local_4]           # 004b638f
    mov edx, dword ptr [ecx + field_248]         # 004b6392
    {load} add edx, eax                          # 004b6398
    movsx eax, word ptr [ebp + arg_10]           # 004b639a
    mov ecx, dword ptr [ebp - local_4]           # 004b639e
    movsx ecx, word ptr [ecx + field_250]        # 004b63a1
    imul eax, ecx                                # 004b63a8
    {load} add edx, eax                          # 004b63ab
    mov eax, dword ptr [ebp + arg_14]            # 004b63ad
    mov dword ptr [eax], edx                     # 004b63b0
    mov ecx, dword ptr [ebp - local_4]           # 004b63b2
    movsx edx, word ptr [ecx + field_250]        # 004b63b5
    mov eax, dword ptr [ebp + arg_14]            # 004b63bc
    mov ecx, dword ptr [eax]                     # 004b63bf
    lea edx, [ecx + edx - field_minus_2]         # 004b63c1
    mov eax, dword ptr [ebp + arg_14]            # 004b63c5
    mov dword ptr [eax + field_8], edx           # 004b63c8
    mov ecx, dword ptr [ebp - local_4]           # 004b63cb
    {load} xor edx, edx                          # 004b63ce
    mov dl, byte ptr [ecx + field_247]           # 004b63d0
    test edx, edx                                # 004b63d6
    jne.d8 L_004b63eb                            # 004b63d8
    # block 0x004b63da: entered by fall-through of jne at 0x004b63d8, 5 instruction(s), ends with forward jump to 0x004b640d
    mov eax, dword ptr [ebp + arg_14]            # 004b63da
    mov ecx, dword ptr [ebp - local_4]           # 004b63dd
    mov edx, dword ptr [ecx + field_24c]         # 004b63e0
    mov dword ptr [eax + field_4], edx           # 004b63e6
    jmp.d8 L_004b640d                            # 004b63e9
L_004b63eb:
    # block 0x004b63eb: entered by jne at 0x004b63d8, 9 instruction(s), falls into the block at 0x004b640d
    movsx eax, word ptr [ebp + arg_8]            # 004b63eb
    mov ecx, dword ptr [ebp - local_4]           # 004b63ef
    movsx edx, word ptr [ecx + field_252]        # 004b63f2
    imul eax, edx                                # 004b63f9
    mov ecx, dword ptr [ebp - local_4]           # 004b63fc
    mov edx, dword ptr [ecx + field_24c]         # 004b63ff
    {load} add edx, eax                          # 004b6405
    mov eax, dword ptr [ebp + arg_14]            # 004b6407
    mov dword ptr [eax + field_4], edx           # 004b640a
L_004b640d:
    # block 0x004b640d: entered by jmp at 0x004b63e9, 10 instruction(s), ends with ret 0x10
    mov ecx, dword ptr [ebp - local_4]           # 004b640d
    movsx edx, word ptr [ecx + field_252]        # 004b6410
    mov eax, dword ptr [ebp + arg_14]            # 004b6417
    mov ecx, dword ptr [eax + field_4]           # 004b641a
    lea edx, [ecx + edx - field_minus_2]         # 004b641d
    mov eax, dword ptr [ebp + arg_14]            # 004b6421
    mov dword ptr [eax + field_c], edx           # 004b6424
    {load} mov esp, ebp                          # 004b6427
    pop ebp                                      # 004b6429
    ret 0x10                                     # 004b642a

