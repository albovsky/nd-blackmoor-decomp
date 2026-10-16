# FUN_00519eb4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519eb4
# extent:       0x00519eb4-0x00519ef2 (62 code bytes)
# span:         0x00519eb4-0x00519ef2 (code 62, tables 0, padding 0)
# sha256:       624755711e01b2a973775c33d39a5c1d19d007bd135a35c2d6bfb116055b854f
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519eb4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2, field_c; [ecx + n] field_5c
# callees:      calls FUN_0051e52f, KERNEL32.dll!GlobalLock, FUN_0051e828
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)

.org 0x00519eb4 - 0x401000
.globl FUN_00519eb4
FUN_00519eb4:
    # block 0x00519eb4: entry, 8 instruction(s), ends with jne to 0x00519ed5 (forward)
    push ebp                                     # 00519eb4
    {load} mov ebp, esp                          # 00519eb5
    push ecx                                     # 00519eb7
    mov eax, dword ptr [ecx + field_5c]          # 00519eb8
    and dword ptr [ebp - local_4], 0x0           # 00519ebb
    mov eax, dword ptr [eax + field_c]           # 00519ebf
    test eax, eax                                # 00519ec2
    jne.d8 L_00519ed5                            # 00519ec4
    # block 0x00519ec6: entered by fall-through of jne at 0x00519ec4, 4 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x00519eeb
    mov ecx, dword ptr [ebp + arg_8]             # 00519ec6
    push 0x5679b0                                # 00519ec9
    call FUN_0051e52f                            # 00519ece
    jmp.d8 L_00519eeb                            # 00519ed3
L_00519ed5:
    # block 0x00519ed5: entered by jne at 0x00519ec4, 7 instruction(s), calls KERNEL32.dll!GlobalLock, FUN_0051e828, falls into the block at 0x00519eeb
    push eax                                     # 00519ed5
    call dword ptr [0x52a204]                    # 00519ed6
    movzx ecx, word ptr [eax + field_2]          # 00519edc
    {load} add ecx, eax                          # 00519ee0
    push ecx                                     # 00519ee2
    mov ecx, dword ptr [ebp + arg_8]             # 00519ee3
    call FUN_0051e828                            # 00519ee6
L_00519eeb:
    # block 0x00519eeb: entered by jmp at 0x00519ed3, 3 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp + arg_8]             # 00519eeb
    leave                                        # 00519eee
    ret 0x4                                      # 00519eef

