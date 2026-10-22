# FUN_004d9302
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9302
# extent:       0x004d9302-0x004d940a (264 code bytes)
# span:         0x004d9302-0x004d940a (code 264, tables 0, padding 0)
# sha256:       0b358108c69a47e2ff80c326b49f685419c4f0ee770d6ff5208e001d653fee5f
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d9302_lifted
# naming:       native port src/original_methods_fl41.c:m4d9302_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 67/67 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_9414, field_9418, field_94ca, field_94cc; [ecx + n] field_94d0; [edx + n] field_94ce
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d9302_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 67 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_9414, 0x9414  # offset +0x9414
.equ field_9418, 0x9418  # offset +0x9418
.equ field_94ca, 0x94ca  # offset +0x94ca
.equ field_94cc, 0x94cc  # offset +0x94cc
.equ field_94ce, 0x94ce  # offset +0x94ce
.equ field_94d0, 0x94d0  # offset +0x94d0

# --- external targets -----------------------------------------------

.org 0x004d9302 - 0x401000
.globl FUN_004d9302
FUN_004d9302:
    # block 0x004d9302: entry, 67 instruction(s), ends with ret
    push ebp                                     # 004d9302
    {load} mov ebp, esp                          # 004d9303
    push ecx                                     # 004d9305
    push esi                                     # 004d9306
    push edi                                     # 004d9307
    mov dword ptr [ebp - local_4], ecx           # 004d9308
    mov edi, dword ptr [ebp - local_4]           # 004d930b
    add edi, 0x476                               # 004d930e
    mov ecx, 0x1e                                # 004d9314
    mov esi, 0x5839b1                            # 004d9319
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d931e
    mov ecx, 0x8c2                               # 004d9320
    mov esi, 0x583a29                            # 004d9325
    mov edi, dword ptr [ebp - local_4]           # 004d932a
    add edi, 0x4ee                               # 004d932d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9333
    movsw word ptr es:[edi], word ptr [esi]      # 004d9335
    mov edi, dword ptr [ebp - local_4]           # 004d9337
    add edi, 0x27f8                              # 004d933a
    mov ecx, 0x29b                               # 004d9340
    mov esi, 0x585d33                            # 004d9345
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d934a
    movsw word ptr es:[edi], word ptr [esi]      # 004d934c
    mov ecx, 0x4e3                               # 004d934e
    mov esi, 0x5867a1                            # 004d9353
    mov edi, dword ptr [ebp - local_4]           # 004d9358
    add edi, 0x3266                              # 004d935b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9361
    mov ecx, 0x1388                              # 004d9363
    mov esi, 0x587b2d                            # 004d9368
    mov edi, dword ptr [ebp - local_4]           # 004d936d
    add edi, 0x45f2                              # 004d9370
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9376
    movsw word ptr es:[edi], word ptr [esi]      # 004d9378
    mov eax, dword ptr [ebp - local_4]           # 004d937a
    mov ecx, dword ptr [0x58c951]                # 004d937d
    mov dword ptr [eax + field_9414], ecx        # 004d9383
    mov edx, dword ptr [0x58c955]                # 004d9389
    mov dword ptr [eax + field_9418], edx        # 004d938f
    mov edi, dword ptr [ebp - local_4]           # 004d9395
    add edi, 0x941c                              # 004d9398
    mov ecx, 0x12                                # 004d939e
    mov esi, 0x591990                            # 004d93a3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d93a8
    movsw word ptr es:[edi], word ptr [esi]      # 004d93aa
    mov edi, dword ptr [ebp - local_4]           # 004d93ac
    add edi, 0x9466                              # 004d93af
    mov ecx, 0x19                                # 004d93b5
    mov esi, 0x58c959                            # 004d93ba
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d93bf
    mov eax, dword ptr [ebp - local_4]           # 004d93c1
    mov cx, word ptr [0x5bb57f]                  # 004d93c4
    mov word ptr [eax + field_94cc], cx          # 004d93cb
    mov edx, dword ptr [ebp - local_4]           # 004d93d2
    mov ax, word ptr [0x5bb597]                  # 004d93d5
    mov word ptr [edx + field_94ce], ax          # 004d93db
    mov ecx, dword ptr [ebp - local_4]           # 004d93e2
    mov dx, word ptr [0x5bb593]                  # 004d93e5
    mov word ptr [ecx + field_94d0], dx          # 004d93ec
    mov eax, dword ptr [ebp - local_4]           # 004d93f3
    mov cx, word ptr [0x58c94f]                  # 004d93f6
    mov word ptr [eax + field_94ca], cx          # 004d93fd
    pop edi                                      # 004d9404
    pop esi                                      # 004d9405
    {load} mov esp, ebp                          # 004d9406
    pop ebp                                      # 004d9408
    ret                                          # 004d9409

