# FUN_00519e77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519e77
# extent:       0x00519e77-0x00519eb4 (61 code bytes)
# span:         0x00519e77-0x00519eb4 (code 61, tables 0, padding 0)
# sha256:       f71d8dd92d84aaedc690233c7d07ec6087f3ff5fb3ac89f5a890da5e33748e9e
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519e77
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c; [ecx + n] field_5c
# callees:      calls FUN_0051e52f, KERNEL32.dll!GlobalLock, FUN_0051e828
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)

.org 0x00519e77 - 0x401000
.globl FUN_00519e77
FUN_00519e77:
    # block 0x00519e77: entry, 8 instruction(s), ends with jne to 0x00519e98 (forward)
    push ebp                                     # 00519e77
    {load} mov ebp, esp                          # 00519e78
    push ecx                                     # 00519e7a
    mov eax, dword ptr [ecx + field_5c]          # 00519e7b
    and dword ptr [ebp - local_4], 0x0           # 00519e7e
    mov eax, dword ptr [eax + field_c]           # 00519e82
    test eax, eax                                # 00519e85
    jne.d8 L_00519e98                            # 00519e87
    # block 0x00519e89: entered by fall-through of jne at 0x00519e87, 4 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x00519ead
    mov ecx, dword ptr [ebp + arg_8]             # 00519e89
    push 0x5679b0                                # 00519e8c
    call FUN_0051e52f                            # 00519e91
    jmp.d8 L_00519ead                            # 00519e96
L_00519e98:
    # block 0x00519e98: entered by jne at 0x00519e87, 7 instruction(s), calls KERNEL32.dll!GlobalLock, FUN_0051e828, falls into the block at 0x00519ead
    push eax                                     # 00519e98
    call dword ptr [0x52a204]                    # 00519e99
    movzx ecx, word ptr [eax]                    # 00519e9f
    {load} add ecx, eax                          # 00519ea2
    push ecx                                     # 00519ea4
    mov ecx, dword ptr [ebp + arg_8]             # 00519ea5
    call FUN_0051e828                            # 00519ea8
L_00519ead:
    # block 0x00519ead: entered by jmp at 0x00519e96, 3 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp + arg_8]             # 00519ead
    leave                                        # 00519eb0
    ret 0x4                                      # 00519eb1

