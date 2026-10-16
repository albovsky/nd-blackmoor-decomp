# FUN_004f81fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f81fa
# extent:       0x004f81fa-0x004f8364 (362 code bytes)
# span:         0x004f81fa-0x004f8364 (code 362, tables 0, padding 0)
# sha256:       c38d582234c87a597438e840a4f7f2fdaeb669776fa0287ff33f07cf3f782fb0
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f81fa
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_10, field_15e, field_28f, field_3ca; [ecx + n] field_8, field_10, field_166, field_28f, field_3ca; [edx + n] field_8, field_10, field_162, field_28f, field_3ca, field_3ce
# callees:      calls FUN_004f709c; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 106 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f81fa - 0x401000
.globl FUN_004f81fa
FUN_004f81fa:
    # block 0x004f81fa: entry, 19 instruction(s), calls FUN_004f709c, ends with jne to 0x004f8247 (forward)
    push ebp                                     # 004f81fa
    {load} mov ebp, esp                          # 004f81fb
    sub esp, 0x18                                # 004f81fd
    mov dword ptr [ebp - local_14], ecx          # 004f8200
    mov eax, dword ptr [ebp - local_14]          # 004f8203
    mov dword ptr [eax + field_3ca], 0x0         # 004f8206
    mov ecx, dword ptr [ebp + arg_8]             # 004f8210
    imul ecx, ecx, 0x5bb                         # 004f8213
    mov edx, dword ptr [ebp - local_14]          # 004f8219
    mov eax, dword ptr [edx + field_3ce]         # 004f821c
    {load} add eax, ecx                          # 004f8222
    mov dword ptr [ebp - local_10], eax          # 004f8224
    mov ecx, dword ptr [ebp - local_10]          # 004f8227
    add ecx, 0x18a                               # 004f822a
    mov dword ptr [ebp - local_8], ecx           # 004f8230
    mov ecx, dword ptr [ebp - local_14]          # 004f8233
    call FUN_004f709c                            # 004f8236
    test eax, eax                                # 004f823b
    jne.d8 L_004f8247                            # 004f823d
    # block 0x004f823f: entered by fall-through of jne at 0x004f823d, 2 instruction(s), ends with forward jump to 0x004f835e
    or eax, -0x1                                 # 004f823f
    jmp.d32 L_004f835e                           # 004f8242
L_004f8247:
    # block 0x004f8247: entered by jne at 0x004f823d, 3 instruction(s), ends with je to 0x004f825f (forward)
    mov edx, dword ptr [ebp - local_10]          # 004f8247
    cmp dword ptr [edx + field_162], 0x0         # 004f824a
    je.d8 L_004f825f                             # 004f8251
    # block 0x004f8253: entered by fall-through of je at 0x004f8251, 3 instruction(s), ends with jne to 0x004f8267 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004f8253
    cmp dword ptr [eax + field_28f], 0x0         # 004f8256
    jne.d8 L_004f8267                            # 004f825d
L_004f825f:
    # block 0x004f825f: entered by je at 0x004f8251; fall-through of jne at 0x004f825d, 2 instruction(s), ends with forward jump to 0x004f835e
    or eax, -0x1                                 # 004f825f
    jmp.d32 L_004f835e                           # 004f8262
L_004f8267:
    # block 0x004f8267: entered by jne at 0x004f825d, 3 instruction(s), ends with je to 0x004f8323 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004f8267
    cmp dword ptr [ecx + field_166], 0x0         # 004f826a
    je.d32 L_004f8323                            # 004f8271
    # block 0x004f8277: entered by fall-through of je at 0x004f8271, 15 instruction(s), calls indirect dword ptr [edx + 0x10], ends with je to 0x004f82b2 (forward)
    push 0x0                                     # 004f8277
    lea edx, [ebp - local_4]                     # 004f8279
    push edx                                     # 004f827c
    mov eax, dword ptr [ebp - local_10]          # 004f827d
    mov ecx, dword ptr [eax + field_28f]         # 004f8280
    mov edx, dword ptr [ebp - local_10]          # 004f8286
    mov eax, dword ptr [edx + field_28f]         # 004f8289
    mov edx, dword ptr [eax]                     # 004f828f
    push ecx                                     # 004f8291
    call dword ptr [edx + field_10]              # 004f8292
    mov ecx, dword ptr [ebp - local_14]          # 004f8295
    mov dword ptr [ecx + field_3ca], eax         # 004f8298
    mov edx, dword ptr [ebp - local_14]          # 004f829e
    cmp dword ptr [edx + field_3ca], 0x0         # 004f82a1
    je.d8 L_004f82b2                             # 004f82a8
    # block 0x004f82aa: entered by fall-through of je at 0x004f82a8, 2 instruction(s), ends with forward jump to 0x004f835e
    or eax, -0x1                                 # 004f82aa
    jmp.d32 L_004f835e                           # 004f82ad
L_004f82b2:
    # block 0x004f82b2: entered by je at 0x004f82a8, 7 instruction(s), ends with jae to 0x004f82d5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f82b2
    mov ecx, dword ptr [ebp - local_4]           # 004f82b5
    mov dword ptr [eax + field_4], ecx           # 004f82b8
    mov edx, dword ptr [ebp - local_8]           # 004f82bb
    mov eax, dword ptr [ebp - local_4]           # 004f82be
    cmp eax, dword ptr [edx + field_8]           # 004f82c1
    jae.d8 L_004f82d5                            # 004f82c4
    # block 0x004f82c6: entered by fall-through of jae at 0x004f82c4, 5 instruction(s), falls into the block at 0x004f82d5
    mov ecx, dword ptr [ebp - local_8]           # 004f82c6
    mov edx, dword ptr [ecx + field_10]          # 004f82c9
    add edx, 0x1                                 # 004f82cc
    mov eax, dword ptr [ebp - local_8]           # 004f82cf
    mov dword ptr [eax + field_10], edx          # 004f82d2
L_004f82d5:
    # block 0x004f82d5: entered by jae at 0x004f82c4, 14 instruction(s), ends with jge to 0x004f830c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f82d5
    mov edx, dword ptr [ebp - local_4]           # 004f82d8
    mov dword ptr [ecx + field_8], edx           # 004f82db
    mov eax, dword ptr [ebp - local_8]           # 004f82de
    mov ecx, dword ptr [eax + field_10]          # 004f82e1
    imul ecx, ecx, 0x56220                       # 004f82e4
    mov dword ptr [ebp - local_c], ecx           # 004f82ea
    mov edx, dword ptr [ebp - local_c]           # 004f82ed
    add edx, dword ptr [ebp - local_4]           # 004f82f0
    mov dword ptr [ebp - local_c], edx           # 004f82f3
    mov eax, dword ptr [ebp - local_10]          # 004f82f6
    mov ecx, dword ptr [ebp - local_c]           # 004f82f9
    cmp ecx, dword ptr [eax + field_15e]         # 004f82fc
    jge.d8 L_004f830c                            # 004f8302
    # block 0x004f8304: entered by fall-through of jge at 0x004f8302, 3 instruction(s), ends with forward jump to 0x004f8318
    mov edx, dword ptr [ebp - local_c]           # 004f8304
    mov dword ptr [ebp - local_18], edx          # 004f8307
    jmp.d8 L_004f8318                            # 004f830a
L_004f830c:
    # block 0x004f830c: entered by jge at 0x004f8302, 3 instruction(s), falls into the block at 0x004f8318
    mov eax, dword ptr [ebp - local_10]          # 004f830c
    mov ecx, dword ptr [eax + field_15e]         # 004f830f
    mov dword ptr [ebp - local_18], ecx          # 004f8315
L_004f8318:
    # block 0x004f8318: entered by jmp at 0x004f830a, 4 instruction(s), ends with forward jump to 0x004f835e
    mov edx, dword ptr [ebp - local_18]          # 004f8318
    mov dword ptr [ebp - local_c], edx           # 004f831b
    mov eax, dword ptr [ebp - local_c]           # 004f831e
    jmp.d8 L_004f835e                            # 004f8321
L_004f8323:
    # block 0x004f8323: entered by je at 0x004f8271, 15 instruction(s), calls indirect dword ptr [eax + 0x10], ends with jne to 0x004f835b (forward)
    push 0x0                                     # 004f8323
    lea eax, [ebp - local_4]                     # 004f8325
    push eax                                     # 004f8328
    mov ecx, dword ptr [ebp - local_10]          # 004f8329
    mov edx, dword ptr [ecx + field_28f]         # 004f832c
    mov eax, dword ptr [ebp - local_10]          # 004f8332
    mov ecx, dword ptr [eax + field_28f]         # 004f8335
    mov eax, dword ptr [ecx]                     # 004f833b
    push edx                                     # 004f833d
    call dword ptr [eax + field_10]              # 004f833e
    mov ecx, dword ptr [ebp - local_14]          # 004f8341
    mov dword ptr [ecx + field_3ca], eax         # 004f8344
    mov edx, dword ptr [ebp - local_14]          # 004f834a
    cmp dword ptr [edx + field_3ca], 0x0         # 004f834d
    jne.d8 L_004f835b                            # 004f8354
    # block 0x004f8356: entered by fall-through of jne at 0x004f8354, 2 instruction(s), ends with forward jump to 0x004f835e
    mov eax, dword ptr [ebp - local_4]           # 004f8356
    jmp.d8 L_004f835e                            # 004f8359
L_004f835b:
    # block 0x004f835b: entered by jne at 0x004f8354, 1 instruction(s), falls into the block at 0x004f835e
    or eax, -0x1                                 # 004f835b
L_004f835e:
    # block 0x004f835e: entered by jmp at 0x004f8242; jmp at 0x004f8262; jmp at 0x004f82ad; jmp at 0x004f8321; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f835e
    pop ebp                                      # 004f8360
    ret 0x4                                      # 004f8361

