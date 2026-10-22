# FUN_0048ef40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ef40
# extent:       0x0048ef40-0x0048efe8 (168 code bytes)
# span:         0x0048ef40-0x0048efe8 (code 168, tables 0, padding 0)
# sha256:       382fcb32934a529051b1cf8fef6dfeb6b5d69f55b548b7a7c26894a012bb34b4
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ef40_advance_slot
# naming:       native port src/original_methods_fl39f.c:m48ef40_advance_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Advances the word cursor [self+0x3fe] modulo the word [descriptor+0xb0] (signed idiv remainders: negative cursors give negative remainders) while the dword slots at [self+0x46a+cursor*4]. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_3fe, field_46a; [ecx + n] field_b0, field_3fe; [edx + n] field_b0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m48ef40_advance_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_b0, 0xb0  # offset +0xb0
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_46a, 0x46a  # offset +0x46a

# --- external targets -----------------------------------------------

.org 0x0048ef40 - 0x401000
.globl FUN_0048ef40
FUN_0048ef40:
    # block 0x0048ef40: entry, 19 instruction(s), falls into the block at 0x0048ef89
    push ebp                                     # 0048ef40
    {load} mov ebp, esp                          # 0048ef41
    sub esp, 0xc                                 # 0048ef43
    mov dword ptr [ebp - local_c], ecx           # 0048ef46
    mov eax, dword ptr [ebp - local_c]           # 0048ef49
    movsx ecx, word ptr [eax + field_1e]         # 0048ef4c
    imul ecx, ecx, 0x8d                          # 0048ef50
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048ef56
    mov dword ptr [ebp - local_8], edx           # 0048ef5c
    mov eax, dword ptr [ebp - local_c]           # 0048ef5f
    movsx eax, word ptr [eax + field_3fe]        # 0048ef62
    add eax, 0x1                                 # 0048ef69
    mov ecx, dword ptr [ebp - local_8]           # 0048ef6c
    movsx ecx, word ptr [ecx + field_b0]         # 0048ef6f
    cdq                                          # 0048ef76
    idiv ecx                                     # 0048ef77
    mov eax, dword ptr [ebp - local_c]           # 0048ef79
    mov word ptr [eax + field_3fe], dx           # 0048ef7c
    mov word ptr [ebp - local_4], 0x1            # 0048ef83
L_0048ef89:
    # block 0x0048ef89: entered by jmp at 0x0048efe2, 5 instruction(s), ends with jge to 0x0048efe4 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048ef89
    mov edx, dword ptr [ebp - local_8]           # 0048ef8d
    movsx eax, word ptr [edx + field_b0]         # 0048ef90
    {load} cmp ecx, eax                          # 0048ef97
    jge.d8 L_0048efe4                            # 0048ef99
    # block 0x0048ef9b: entered by fall-through of jge at 0x0048ef99, 5 instruction(s), ends with je to 0x0048efe4 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048ef9b
    movsx edx, word ptr [ecx + field_3fe]        # 0048ef9e
    mov eax, dword ptr [ebp - local_c]           # 0048efa5
    cmp dword ptr [eax + 4*edx + field_46a], 0x0 # 0048efa8
    je.d8 L_0048efe4                             # 0048efb0
    # block 0x0048efb2: entered by fall-through of je at 0x0048efb0, 13 instruction(s), ends with backward jump to 0x0048ef89
    mov ecx, dword ptr [ebp - local_c]           # 0048efb2
    movsx eax, word ptr [ecx + field_3fe]        # 0048efb5
    add eax, 0x1                                 # 0048efbc
    mov edx, dword ptr [ebp - local_8]           # 0048efbf
    movsx ecx, word ptr [edx + field_b0]         # 0048efc2
    cdq                                          # 0048efc9
    idiv ecx                                     # 0048efca
    mov eax, dword ptr [ebp - local_c]           # 0048efcc
    mov word ptr [eax + field_3fe], dx           # 0048efcf
    mov cx, word ptr [ebp - local_4]             # 0048efd6
    add cx, 0x1                                  # 0048efda
    mov word ptr [ebp - local_4], cx             # 0048efde
    jmp.d8 L_0048ef89                            # 0048efe2
L_0048efe4:
    # block 0x0048efe4: entered by jge at 0x0048ef99; je at 0x0048efb0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048efe4
    pop ebp                                      # 0048efe6
    ret                                          # 0048efe7

