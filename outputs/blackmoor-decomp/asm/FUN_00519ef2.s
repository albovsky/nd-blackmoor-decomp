# FUN_00519ef2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519ef2
# extent:       0x00519ef2-0x00519f30 (62 code bytes)
# span:         0x00519ef2-0x00519f30 (code 62, tables 0, padding 0)
# sha256:       f4c5ac3f5768b0c8669d93c6dfc32666608a6b3b9b88dffbc9fdaae897cce9df
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519ef2
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_c; [ecx + n] field_5c
# callees:      calls FUN_0051e52f, KERNEL32.dll!GlobalLock, FUN_0051e828
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)

.org 0x00519ef2 - 0x401000
.globl FUN_00519ef2
FUN_00519ef2:
    # block 0x00519ef2: entry, 8 instruction(s), ends with jne to 0x00519f13 (forward)
    push ebp                                     # 00519ef2
    {load} mov ebp, esp                          # 00519ef3
    push ecx                                     # 00519ef5
    mov eax, dword ptr [ecx + field_5c]          # 00519ef6
    and dword ptr [ebp - local_4], 0x0           # 00519ef9
    mov eax, dword ptr [eax + field_c]           # 00519efd
    test eax, eax                                # 00519f00
    jne.d8 L_00519f13                            # 00519f02
    # block 0x00519f04: entered by fall-through of jne at 0x00519f02, 4 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x00519f29
    mov ecx, dword ptr [ebp + arg_8]             # 00519f04
    push 0x5679b0                                # 00519f07
    call FUN_0051e52f                            # 00519f0c
    jmp.d8 L_00519f29                            # 00519f11
L_00519f13:
    # block 0x00519f13: entered by jne at 0x00519f02, 7 instruction(s), calls KERNEL32.dll!GlobalLock, FUN_0051e828, falls into the block at 0x00519f29
    push eax                                     # 00519f13
    call dword ptr [0x52a204]                    # 00519f14
    movzx ecx, word ptr [eax + field_4]          # 00519f1a
    {load} add ecx, eax                          # 00519f1e
    push ecx                                     # 00519f20
    mov ecx, dword ptr [ebp + arg_8]             # 00519f21
    call FUN_0051e828                            # 00519f24
L_00519f29:
    # block 0x00519f29: entered by jmp at 0x00519f11, 3 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp + arg_8]             # 00519f29
    leave                                        # 00519f2c
    ret 0x4                                      # 00519f2d

