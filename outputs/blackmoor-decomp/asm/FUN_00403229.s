# FUN_00403229
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00403229
# extent:       0x00403229-0x0040338e (357 code bytes)
# span:         0x00403229-0x0040338e (code 357, tables 0, padding 0)
# sha256:       7a49905f52223954df5627f7b67fa2cf0f49567a6aa631c406b0049a7112d31e
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00403229
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401032, FUN_005218ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 83 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00403229 - 0x401000
.globl FUN_00403229
FUN_00403229:
    # block 0x00403229: entry, 83 instruction(s), calls FUN_00401032, FUN_005218ea, ends with ret
    push ebp                                     # 00403229
    {load} mov ebp, esp                          # 0040322a
    push -0x1                                    # 0040322c
    push 0x526d12                                # 0040322e
    mov eax, dword ptr fs:[0x0]                  # 00403233
    push eax                                     # 00403239
    mov dword ptr fs:[0x0], esp                  # 0040323a
    push ecx                                     # 00403241
    mov dword ptr [ebp - local_10], ecx          # 00403242
    mov eax, dword ptr [ebp - local_10]          # 00403245
    mov dword ptr [eax], 0x52b268                # 00403248
    mov dword ptr [ebp - local_4], 0xf           # 0040324e
    mov ecx, dword ptr [ebp - local_10]          # 00403255
    add ecx, 0x44c                               # 00403258
    call FUN_00401032                            # 0040325e
    mov byte ptr [ebp - local_4], 0xe            # 00403263
    mov ecx, dword ptr [ebp - local_10]          # 00403267
    add ecx, 0x40c                               # 0040326a
    call FUN_00401032                            # 00403270
    mov byte ptr [ebp - local_4], 0xd            # 00403275
    mov ecx, dword ptr [ebp - local_10]          # 00403279
    add ecx, 0x3cc                               # 0040327c
    call FUN_00401032                            # 00403282
    mov byte ptr [ebp - local_4], 0xc            # 00403287
    mov ecx, dword ptr [ebp - local_10]          # 0040328b
    add ecx, 0x38c                               # 0040328e
    call FUN_00401032                            # 00403294
    mov byte ptr [ebp - local_4], 0xb            # 00403299
    mov ecx, dword ptr [ebp - local_10]          # 0040329d
    add ecx, 0x34c                               # 004032a0
    call FUN_00401032                            # 004032a6
    mov byte ptr [ebp - local_4], 0xa            # 004032ab
    mov ecx, dword ptr [ebp - local_10]          # 004032af
    add ecx, 0x30c                               # 004032b2
    call FUN_00401032                            # 004032b8
    mov byte ptr [ebp - local_4], 0x9            # 004032bd
    mov ecx, dword ptr [ebp - local_10]          # 004032c1
    add ecx, 0x2cc                               # 004032c4
    call FUN_00401032                            # 004032ca
    mov byte ptr [ebp - local_4], 0x8            # 004032cf
    mov ecx, dword ptr [ebp - local_10]          # 004032d3
    add ecx, 0x28c                               # 004032d6
    call FUN_00401032                            # 004032dc
    mov byte ptr [ebp - local_4], 0x7            # 004032e1
    mov ecx, dword ptr [ebp - local_10]          # 004032e5
    add ecx, 0x24c                               # 004032e8
    call FUN_00401032                            # 004032ee
    mov byte ptr [ebp - local_4], 0x6            # 004032f3
    mov ecx, dword ptr [ebp - local_10]          # 004032f7
    add ecx, 0x20c                               # 004032fa
    call FUN_00401032                            # 00403300
    mov byte ptr [ebp - local_4], 0x5            # 00403305
    mov ecx, dword ptr [ebp - local_10]          # 00403309
    add ecx, 0x1cc                               # 0040330c
    call FUN_00401032                            # 00403312
    mov byte ptr [ebp - local_4], 0x4            # 00403317
    mov ecx, dword ptr [ebp - local_10]          # 0040331b
    add ecx, 0x18c                               # 0040331e
    call FUN_00401032                            # 00403324
    mov byte ptr [ebp - local_4], 0x3            # 00403329
    mov ecx, dword ptr [ebp - local_10]          # 0040332d
    add ecx, 0x14c                               # 00403330
    call FUN_00401032                            # 00403336
    mov byte ptr [ebp - local_4], 0x2            # 0040333b
    mov ecx, dword ptr [ebp - local_10]          # 0040333f
    add ecx, 0x10c                               # 00403342
    call FUN_00401032                            # 00403348
    mov byte ptr [ebp - local_4], 0x1            # 0040334d
    mov ecx, dword ptr [ebp - local_10]          # 00403351
    add ecx, 0xcc                                # 00403354
    call FUN_00401032                            # 0040335a
    mov byte ptr [ebp - local_4], 0x0            # 0040335f
    mov ecx, dword ptr [ebp - local_10]          # 00403363
    add ecx, 0x8c                                # 00403366
    call FUN_00401032                            # 0040336c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00403371
    mov ecx, dword ptr [ebp - local_10]          # 00403378
    call FUN_005218ea                            # 0040337b
    mov ecx, dword ptr [ebp - local_c]           # 00403380
    mov dword ptr fs:[0x0], ecx                  # 00403383
    {load} mov esp, ebp                          # 0040338a
    pop ebp                                      # 0040338c
    ret                                          # 0040338d

