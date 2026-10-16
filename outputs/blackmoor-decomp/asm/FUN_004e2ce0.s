# FUN_004e2ce0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2ce0
# extent:       0x004e2ce0-0x004e2d63 (131 code bytes)
# span:         0x004e2ce0-0x004e2d63 (code 131, tables 0, padding 0)
# sha256:       3997633f7df571a4857cf9bd14e9f18bd9f6120e9a8ff5f1cf3bc95d1c760c4e
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e2ce0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       [edx + n] field_6b2
# callees:      calls FUN_004eda10, FUN_0050cb26, FUN_004e2dd3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_6b2, 0x6b2  # offset +0x6b2

# --- external targets -----------------------------------------------
.set FUN_004e2dd3, .text + (0x004e2dd3 - 0x401000)
.set FUN_004eda10, .text + (0x004eda10 - 0x401000)
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)

.org 0x004e2ce0 - 0x401000
.globl FUN_004e2ce0
FUN_004e2ce0:
    # block 0x004e2ce0: entry, 34 instruction(s), calls FUN_004eda10, FUN_0050cb26, FUN_004e2dd3, ends with ret
    push ebp                                     # 004e2ce0
    {load} mov ebp, esp                          # 004e2ce1
    push -0x1                                    # 004e2ce3
    push 0x5289c4                                # 004e2ce5
    mov eax, dword ptr fs:[0x0]                  # 004e2cea
    push eax                                     # 004e2cf0
    mov dword ptr fs:[0x0], esp                  # 004e2cf1
    push ecx                                     # 004e2cf8
    mov dword ptr [ebp - local_10], ecx          # 004e2cf9
    mov ecx, dword ptr [ebp - local_10]          # 004e2cfc
    call FUN_004eda10                            # 004e2cff
    mov dword ptr [ebp - local_4], 0x0           # 004e2d04
    push 0x4e1c83                                # 004e2d0b
    push 0x4e1c50                                # 004e2d10
    push 0x1a                                    # 004e2d15
    push 0x18f                                   # 004e2d17
    mov eax, dword ptr [ebp - local_10]          # 004e2d1c
    add eax, 0x1ca2                              # 004e2d1f
    push eax                                     # 004e2d24
    call FUN_0050cb26                            # 004e2d25
    mov byte ptr [ebp - local_4], 0x1            # 004e2d2a
    mov ecx, dword ptr [ebp - local_10]          # 004e2d2e
    mov dword ptr [ecx], 0x52e4ec                # 004e2d31
    mov ecx, dword ptr [ebp - local_10]          # 004e2d37
    call FUN_004e2dd3                            # 004e2d3a
    mov edx, dword ptr [ebp - local_10]          # 004e2d3f
    mov word ptr [edx + field_6b2], 0x270f       # 004e2d42
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e2d4b
    mov eax, dword ptr [ebp - local_10]          # 004e2d52
    mov ecx, dword ptr [ebp - local_c]           # 004e2d55
    mov dword ptr fs:[0x0], ecx                  # 004e2d58
    {load} mov esp, ebp                          # 004e2d5f
    pop ebp                                      # 004e2d61
    ret                                          # 004e2d62

