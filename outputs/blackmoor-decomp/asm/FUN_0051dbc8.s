# FUN_0051dbc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dbc8
# extent:       0x0051dbc8-0x0051dc29 (97 code bytes)
# span:         0x0051dbc8-0x0051dc29 (code 97, tables 0, padding 0)
# sha256:       0a64eb86bec36a24bf42c9e2ac69d0a3a27f76eaaec6b7d1655a50dd8de3d6ed
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dbc8
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_8
# fields:       [eax + n] field_c; [edx + n] field_c; [esi + n] field_4, field_18
# callees:      none direct; 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0051dbc8 - 0x401000
.globl FUN_0051dbc8
FUN_0051dbc8:
    # block 0x0051dbc8: entry, 11 instruction(s), ends with je to 0x0051dc20 (forward)
    push ebp                                     # 0051dbc8
    {load} mov ebp, esp                          # 0051dbc9
    push ecx                                     # 0051dbcb
    push ecx                                     # 0051dbcc
    push ebx                                     # 0051dbcd
    push esi                                     # 0051dbce
    {load} mov esi, ecx                          # 0051dbcf
    {load} xor ebx, ebx                          # 0051dbd1
    mov eax, dword ptr [esi + field_4]           # 0051dbd3
    {load} cmp eax, ebx                          # 0051dbd6
    je.d8 L_0051dc20                             # 0051dbd8
    # block 0x0051dbda: entered by fall-through of je at 0x0051dbd8, 2 instruction(s), ends with je to 0x0051dc20 (forward)
    .insn 0x66, 0x3d, 0xffff{:u16}               # 0051dbda
    je.d8 L_0051dc20                             # 0051dbde
    # block 0x0051dbe0: entered by fall-through of je at 0x0051dbde, 13 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x0051dc1a (forward)
    push edi                                     # 0051dbe0
    mov edi, dword ptr [ebp + arg_8]             # 0051dbe1
    push ebx                                     # 0051dbe4
    mov dword ptr [esi + field_18], ebx          # 0051dbe5
    mov edx, dword ptr [edi]                     # 0051dbe8
    push esi                                     # 0051dbea
    push -0x1                                    # 0051dbeb
    push eax                                     # 0051dbed
    {load} mov ecx, edi                          # 0051dbee
    call dword ptr [edx + field_c]               # 0051dbf0
    cmp dword ptr [ebp + arg_c], ebx             # 0051dbf3
    mov dword ptr [ebp + arg_8], eax             # 0051dbf6
    je.d8 L_0051dc1a                             # 0051dbf9
    # block 0x0051dbfb: entered by fall-through of je at 0x0051dbf9, 2 instruction(s), ends with jne to 0x0051dc1a (forward)
    cmp dword ptr [esi + field_18], ebx          # 0051dbfb
    jne.d8 L_0051dc1a                            # 0051dbfe
    # block 0x0051dc00: entered by fall-through of jne at 0x0051dbfe, 13 instruction(s), calls indirect dword ptr [eax + 0xc], indirect dword ptr [edx], falls into the block at 0x0051dc1a
    mov eax, dword ptr [edi]                     # 0051dc00
    lea ecx, [ebp - local_8]                     # 0051dc02
    push ecx                                     # 0051dc05
    push esi                                     # 0051dc06
    push ebx                                     # 0051dc07
    {load} mov ecx, edi                          # 0051dc08
    push dword ptr [esi + field_4]               # 0051dc0a
    mov dword ptr [ebp - local_8], ebx           # 0051dc0d
    call dword ptr [eax + field_c]               # 0051dc10
    mov edx, dword ptr [esi]                     # 0051dc13
    push eax                                     # 0051dc15
    {load} mov ecx, esi                          # 0051dc16
    call dword ptr [edx]                         # 0051dc18
L_0051dc1a:
    # block 0x0051dc1a: entered by je at 0x0051dbf9; jne at 0x0051dbfe, 3 instruction(s), ends with forward jump to 0x0051dc23
    mov eax, dword ptr [ebp + arg_8]             # 0051dc1a
    pop edi                                      # 0051dc1d
    jmp.d8 L_0051dc23                            # 0051dc1e
L_0051dc20:
    # block 0x0051dc20: entered by je at 0x0051dbd8; je at 0x0051dbde, 2 instruction(s), falls into the block at 0x0051dc23
    push 0x1                                     # 0051dc20
    pop eax                                      # 0051dc22
L_0051dc23:
    # block 0x0051dc23: entered by jmp at 0x0051dc1e, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 0051dc23
    pop ebx                                      # 0051dc24
    leave                                        # 0051dc25
    ret 0x8                                      # 0051dc26

