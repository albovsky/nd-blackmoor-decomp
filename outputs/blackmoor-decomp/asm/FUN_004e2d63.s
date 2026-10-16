# FUN_004e2d63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2d63
# extent:       0x004e2d63-0x004e2dd3 (112 code bytes)
# span:         0x004e2d63-0x004e2dd3 (code 112, tables 0, padding 0)
# sha256:       a87e42f4774c158146eba0692df940863a0e92904d8340b00675d420009ea710
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e2d63
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2faa, FUN_0050cba8, FUN_004eda7c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e2faa, .text + (0x004e2faa - 0x401000)
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x004e2d63 - 0x401000
.globl FUN_004e2d63
FUN_004e2d63:
    # block 0x004e2d63: entry, 30 instruction(s), calls FUN_004e2faa, FUN_0050cba8, FUN_004eda7c, ends with ret
    push ebp                                     # 004e2d63
    {load} mov ebp, esp                          # 004e2d64
    push -0x1                                    # 004e2d66
    push 0x5289f2                                # 004e2d68
    mov eax, dword ptr fs:[0x0]                  # 004e2d6d
    push eax                                     # 004e2d73
    mov dword ptr fs:[0x0], esp                  # 004e2d74
    push ecx                                     # 004e2d7b
    mov dword ptr [ebp - local_10], ecx          # 004e2d7c
    mov eax, dword ptr [ebp - local_10]          # 004e2d7f
    mov dword ptr [eax], 0x52e4ec                # 004e2d82
    mov dword ptr [ebp - local_4], 0x1           # 004e2d88
    mov ecx, dword ptr [ebp - local_10]          # 004e2d8f
    call FUN_004e2faa                            # 004e2d92
    mov byte ptr [ebp - local_4], 0x0            # 004e2d97
    push 0x4e1c83                                # 004e2d9b
    push 0x1a                                    # 004e2da0
    push 0x18f                                   # 004e2da2
    mov ecx, dword ptr [ebp - local_10]          # 004e2da7
    add ecx, 0x1ca2                              # 004e2daa
    push ecx                                     # 004e2db0
    call FUN_0050cba8                            # 004e2db1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e2db6
    mov ecx, dword ptr [ebp - local_10]          # 004e2dbd
    call FUN_004eda7c                            # 004e2dc0
    mov ecx, dword ptr [ebp - local_c]           # 004e2dc5
    mov dword ptr fs:[0x0], ecx                  # 004e2dc8
    {load} mov esp, ebp                          # 004e2dcf
    pop ebp                                      # 004e2dd1
    ret                                          # 004e2dd2

