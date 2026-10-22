# FUN_004030ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004030ba
# extent:       0x004030ba-0x00403229 (367 code bytes)
# span:         0x004030ba-0x00403229 (code 367, tables 0, padding 0)
# sha256:       680c218a2ce4791ab303c9df06c50ac0636154cf8e5ccd4512187f6b3961d5e9
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004030ba
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005217e4, FUN_00401000
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401000, .text + (0x00401000 - 0x401000)
.set FUN_005217e4, .text + (0x005217e4 - 0x401000)

.org 0x004030ba - 0x401000
.globl FUN_004030ba
FUN_004030ba:
    # block 0x004030ba: entry, 86 instruction(s), calls FUN_005217e4, FUN_00401000, ends with ret
    push ebp                                     # 004030ba
    {load} mov ebp, esp                          # 004030bb
    push -0x1                                    # 004030bd
    push 0x526c1e                                # 004030bf
    mov eax, dword ptr fs:[0x0]                  # 004030c4
    push eax                                     # 004030ca
    mov dword ptr fs:[0x0], esp                  # 004030cb
    push ecx                                     # 004030d2
    mov dword ptr [ebp - local_10], ecx          # 004030d3
    push 0x0                                     # 004030d6
    push 0x88                                    # 004030d8
    mov ecx, dword ptr [ebp - local_10]          # 004030dd
    call FUN_005217e4                            # 004030e0
    mov dword ptr [ebp - local_4], 0x0           # 004030e5
    mov ecx, dword ptr [ebp - local_10]          # 004030ec
    add ecx, 0x8c                                # 004030ef
    call FUN_00401000                            # 004030f5
    mov byte ptr [ebp - local_4], 0x1            # 004030fa
    mov ecx, dword ptr [ebp - local_10]          # 004030fe
    add ecx, 0xcc                                # 00403101
    call FUN_00401000                            # 00403107
    mov byte ptr [ebp - local_4], 0x2            # 0040310c
    mov ecx, dword ptr [ebp - local_10]          # 00403110
    add ecx, 0x10c                               # 00403113
    call FUN_00401000                            # 00403119
    mov byte ptr [ebp - local_4], 0x3            # 0040311e
    mov ecx, dword ptr [ebp - local_10]          # 00403122
    add ecx, 0x14c                               # 00403125
    call FUN_00401000                            # 0040312b
    mov byte ptr [ebp - local_4], 0x4            # 00403130
    mov ecx, dword ptr [ebp - local_10]          # 00403134
    add ecx, 0x18c                               # 00403137
    call FUN_00401000                            # 0040313d
    mov byte ptr [ebp - local_4], 0x5            # 00403142
    mov ecx, dword ptr [ebp - local_10]          # 00403146
    add ecx, 0x1cc                               # 00403149
    call FUN_00401000                            # 0040314f
    mov byte ptr [ebp - local_4], 0x6            # 00403154
    mov ecx, dword ptr [ebp - local_10]          # 00403158
    add ecx, 0x20c                               # 0040315b
    call FUN_00401000                            # 00403161
    mov byte ptr [ebp - local_4], 0x7            # 00403166
    mov ecx, dword ptr [ebp - local_10]          # 0040316a
    add ecx, 0x24c                               # 0040316d
    call FUN_00401000                            # 00403173
    mov byte ptr [ebp - local_4], 0x8            # 00403178
    mov ecx, dword ptr [ebp - local_10]          # 0040317c
    add ecx, 0x28c                               # 0040317f
    call FUN_00401000                            # 00403185
    mov byte ptr [ebp - local_4], 0x9            # 0040318a
    mov ecx, dword ptr [ebp - local_10]          # 0040318e
    add ecx, 0x2cc                               # 00403191
    call FUN_00401000                            # 00403197
    mov byte ptr [ebp - local_4], 0xa            # 0040319c
    mov ecx, dword ptr [ebp - local_10]          # 004031a0
    add ecx, 0x30c                               # 004031a3
    call FUN_00401000                            # 004031a9
    mov byte ptr [ebp - local_4], 0xb            # 004031ae
    mov ecx, dword ptr [ebp - local_10]          # 004031b2
    add ecx, 0x34c                               # 004031b5
    call FUN_00401000                            # 004031bb
    mov byte ptr [ebp - local_4], 0xc            # 004031c0
    mov ecx, dword ptr [ebp - local_10]          # 004031c4
    add ecx, 0x38c                               # 004031c7
    call FUN_00401000                            # 004031cd
    mov byte ptr [ebp - local_4], 0xd            # 004031d2
    mov ecx, dword ptr [ebp - local_10]          # 004031d6
    add ecx, 0x3cc                               # 004031d9
    call FUN_00401000                            # 004031df
    mov byte ptr [ebp - local_4], 0xe            # 004031e4
    mov ecx, dword ptr [ebp - local_10]          # 004031e8
    add ecx, 0x40c                               # 004031eb
    call FUN_00401000                            # 004031f1
    mov byte ptr [ebp - local_4], 0xf            # 004031f6
    mov ecx, dword ptr [ebp - local_10]          # 004031fa
    add ecx, 0x44c                               # 004031fd
    call FUN_00401000                            # 00403203
    mov eax, dword ptr [ebp - local_10]          # 00403208
    mov dword ptr [eax], 0x52b268                # 0040320b
    mov dword ptr [ebp - local_4], 0xffffffff    # 00403211
    mov eax, dword ptr [ebp - local_10]          # 00403218
    mov ecx, dword ptr [ebp - local_c]           # 0040321b
    mov dword ptr fs:[0x0], ecx                  # 0040321e
    {load} mov esp, ebp                          # 00403225
    pop ebp                                      # 00403227
    ret                                          # 00403228

