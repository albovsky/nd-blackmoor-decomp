# FUN_004741eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004741eb
# extent:       0x004741eb-0x0047428c (161 code bytes)
# span:         0x004741eb-0x0047428c (code 161, tables 0, padding 0)
# sha256:       c22d5f4e041b7277a2dbf263aa4465410277f1411d9885a47cff0d770debd8f3
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004741eb
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_a6, field_166; [ecx + n] field_4, field_8, field_c, field_166; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_a6, 0xa6  # offset +0xa6
.equ field_166, 0x166  # offset +0x166

# --- external targets -----------------------------------------------

.org 0x004741eb - 0x401000
.globl FUN_004741eb
FUN_004741eb:
    # block 0x004741eb: entry, 6 instruction(s), ends with forward jump to 0x00474206
    push ebp                                     # 004741eb
    {load} mov ebp, esp                          # 004741ec
    sub esp, 0x8                                 # 004741ee
    mov dword ptr [ebp - local_8], ecx           # 004741f1
    mov dword ptr [ebp - local_4], 0x0           # 004741f4
    jmp.d8 L_00474206                            # 004741fb
L_004741fd:
    # block 0x004741fd: entered by jmp at 0x00474283, 3 instruction(s), falls into the block at 0x00474206
    mov eax, dword ptr [ebp - local_4]           # 004741fd
    add eax, 0x1                                 # 00474200
    mov dword ptr [ebp - local_4], eax           # 00474203
L_00474206:
    # block 0x00474206: entered by jmp at 0x004741fb, 2 instruction(s), ends with jge to 0x00474288 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00474206
    jge.d8 L_00474288                            # 0047420a
    # block 0x0047420c: entered by fall-through of jge at 0x0047420a, 3 instruction(s), ends with je to 0x00474251 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047420c
    cmp dword ptr [4*ecx + 0x5a4b4e], 0x0        # 0047420f
    je.d8 L_00474251                             # 00474217
    # block 0x00474219: entered by fall-through of je at 0x00474217, 17 instruction(s), ends with forward jump to 0x00474283
    mov edx, dword ptr [ebp - local_4]           # 00474219
    imul edx, edx, 0x38                          # 0047421c
    mov eax, dword ptr [ebp - local_8]           # 0047421f
    lea ecx, [eax + edx + field_a6]              # 00474222
    mov edx, dword ptr [ebp - local_4]           # 00474229
    shl edx, 0x4                                 # 0047422c
    mov eax, dword ptr [ebp - local_8]           # 0047422f
    lea edx, [eax + edx + field_166]             # 00474232
    mov eax, dword ptr [ecx]                     # 00474239
    mov dword ptr [edx], eax                     # 0047423b
    mov eax, dword ptr [ecx + field_4]           # 0047423d
    mov dword ptr [edx + field_4], eax           # 00474240
    mov eax, dword ptr [ecx + field_8]           # 00474243
    mov dword ptr [edx + field_8], eax           # 00474246
    mov ecx, dword ptr [ecx + field_c]           # 00474249
    mov dword ptr [edx + field_c], ecx           # 0047424c
    jmp.d8 L_00474283                            # 0047424f
L_00474251:
    # block 0x00474251: entered by je at 0x00474217, 15 instruction(s), falls into the block at 0x00474283
    mov edx, dword ptr [ebp - local_4]           # 00474251
    shl edx, 0x4                                 # 00474254
    add edx, 0x5a4b5e                            # 00474257
    mov eax, dword ptr [ebp - local_4]           # 0047425d
    shl eax, 0x4                                 # 00474260
    mov ecx, dword ptr [ebp - local_8]           # 00474263
    lea eax, [ecx + eax + field_166]             # 00474266
    mov ecx, dword ptr [edx]                     # 0047426d
    mov dword ptr [eax], ecx                     # 0047426f
    mov ecx, dword ptr [edx + field_4]           # 00474271
    mov dword ptr [eax + field_4], ecx           # 00474274
    mov ecx, dword ptr [edx + field_8]           # 00474277
    mov dword ptr [eax + field_8], ecx           # 0047427a
    mov edx, dword ptr [edx + field_c]           # 0047427d
    mov dword ptr [eax + field_c], edx           # 00474280
L_00474283:
    # block 0x00474283: entered by jmp at 0x0047424f, 1 instruction(s), ends with backward jump to 0x004741fd
    jmp.d32 L_004741fd                           # 00474283
L_00474288:
    # block 0x00474288: entered by jge at 0x0047420a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00474288
    pop ebp                                      # 0047428a
    ret                                          # 0047428b

