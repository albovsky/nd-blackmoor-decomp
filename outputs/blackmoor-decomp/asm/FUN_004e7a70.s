# FUN_004e7a70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7a70
# extent:       0x004e7a70-0x004e7b37 (199 code bytes)
# span:         0x004e7a70-0x004e7b37 (code 199, tables 0, padding 0)
# sha256:       0c2c903161e84be8ef21471f7a7a9ffb6a00e374b6af510919438f63f48c63f6
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7a70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       [eax + n] field_695; [ecx + n] field_691; [edx + n] field_699
# callees:      calls FUN_004eda10, FUN_0050cb26, FUN_004e7ba7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_691, 0x691  # offset +0x691
.equ field_695, 0x695  # offset +0x695
.equ field_699, 0x699  # offset +0x699

# --- external targets -----------------------------------------------
.set FUN_004e7ba7, .text + (0x004e7ba7 - 0x401000)
.set FUN_004eda10, .text + (0x004eda10 - 0x401000)
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)

.org 0x004e7a70 - 0x401000
.globl FUN_004e7a70
FUN_004e7a70:
    # block 0x004e7a70: entry, 52 instruction(s), calls FUN_004eda10, FUN_0050cb26, FUN_004e7ba7, ends with ret
    push ebp                                     # 004e7a70
    {load} mov ebp, esp                          # 004e7a71
    push -0x1                                    # 004e7a73
    push 0x528a54                                # 004e7a75
    mov eax, dword ptr fs:[0x0]                  # 004e7a7a
    push eax                                     # 004e7a80
    mov dword ptr fs:[0x0], esp                  # 004e7a81
    push ecx                                     # 004e7a88
    push edi                                     # 004e7a89
    mov dword ptr [ebp - local_10], ecx          # 004e7a8a
    mov ecx, dword ptr [ebp - local_10]          # 004e7a8d
    call FUN_004eda10                            # 004e7a90
    mov dword ptr [ebp - local_4], 0x0           # 004e7a95
    push 0x4e1c83                                # 004e7a9c
    push 0x4e1c50                                # 004e7aa1
    push 0x6                                     # 004e7aa6
    push 0x18f                                   # 004e7aa8
    mov eax, dword ptr [ebp - local_10]          # 004e7aad
    add eax, 0x7654                              # 004e7ab0
    push eax                                     # 004e7ab5
    call FUN_0050cb26                            # 004e7ab6
    mov byte ptr [ebp - local_4], 0x1            # 004e7abb
    mov ecx, dword ptr [ebp - local_10]          # 004e7abf
    mov dword ptr [ecx], 0x52e4f4                # 004e7ac2
    mov edx, dword ptr [ebp - local_10]          # 004e7ac8
    mov dword ptr [edx + field_699], 0x0         # 004e7acb
    mov eax, dword ptr [ebp - local_10]          # 004e7ad5
    mov dword ptr [eax + field_695], 0x0         # 004e7ad8
    mov ecx, dword ptr [ebp - local_10]          # 004e7ae2
    mov dword ptr [ecx + field_691], 0x0         # 004e7ae5
    mov ecx, 0x2cb                               # 004e7aef
    {load} xor eax, eax                          # 004e7af4
    mov edi, dword ptr [ebp - local_10]          # 004e7af6
    add edi, 0x6b20                              # 004e7af9
    rep stosd dword ptr es:[edi], eax            # 004e7aff
    mov ecx, 0x191f                              # 004e7b01
    {load} xor eax, eax                          # 004e7b06
    mov edi, dword ptr [ebp - local_10]          # 004e7b08
    add edi, 0x69d                               # 004e7b0b
    rep stosd dword ptr es:[edi], eax            # 004e7b11
    stosw word ptr es:[edi], ax                  # 004e7b13
    stosb byte ptr es:[edi], al                  # 004e7b15
    mov ecx, dword ptr [ebp - local_10]          # 004e7b16
    call FUN_004e7ba7                            # 004e7b19
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e7b1e
    mov eax, dword ptr [ebp - local_10]          # 004e7b25
    mov ecx, dword ptr [ebp - local_c]           # 004e7b28
    mov dword ptr fs:[0x0], ecx                  # 004e7b2b
    pop edi                                      # 004e7b32
    {load} mov esp, ebp                          # 004e7b33
    pop ebp                                      # 004e7b35
    ret                                          # 004e7b36

