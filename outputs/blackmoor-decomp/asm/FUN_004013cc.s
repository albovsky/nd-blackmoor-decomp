# FUN_004013cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004013cc
# extent:       0x004013cc-0x0040141f (83 code bytes)
# span:         0x004013cc-0x00401420 (code 83, tables 0, padding 1)
# sha256:       ef0f379f9ce052d739788dda994e7635b31487d476856ffb14625dd6010d5824
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004013cc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043dbd5, FUN_004db870, USER32.dll!ShowCursor, FUN_004dad60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)

.org 0x004013cc - 0x401000
.globl FUN_004013cc
FUN_004013cc:
    # block 0x004013cc: entry, 11 instruction(s), calls FUN_0043dbd5, FUN_004db870, USER32.dll!ShowCursor, falls into the block at 0x004013f4
    push ebp                                     # 004013cc
    {load} mov ebp, esp                          # 004013cd
    push ecx                                     # 004013cf
    mov eax, dword ptr [0x583985]                # 004013d0
    mov dword ptr [0x583981], eax                # 004013d5
    call FUN_0043dbd5                            # 004013da
    mov ecx, 0x5830ce                            # 004013df
    call FUN_004db870                            # 004013e4
    push 0x0                                     # 004013e9
    call dword ptr [0x52a4cc]                    # 004013eb
    mov dword ptr [ebp - local_4], eax           # 004013f1
L_004013f4:
    # block 0x004013f4: entered by jmp at 0x00401405, 2 instruction(s), ends with jl to 0x00401407 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004013f4
    jl.d8 L_00401407                             # 004013f8
    # block 0x004013fa: entered by fall-through of jl at 0x004013f8, 4 instruction(s), calls USER32.dll!ShowCursor, ends with backward jump to 0x004013f4
    push 0x0                                     # 004013fa
    call dword ptr [0x52a4cc]                    # 004013fc
    mov dword ptr [ebp - local_4], eax           # 00401402
    jmp.d8 L_004013f4                            # 00401405
L_00401407:
    # block 0x00401407: entered by jl at 0x004013f8, 6 instruction(s), calls FUN_004dad60, ends with ret
    mov dword ptr [0x583985], 0x10               # 00401407
    mov ecx, 0x5830a6                            # 00401411
    call FUN_004dad60                            # 00401416
    {load} mov esp, ebp                          # 0040141b
    pop ebp                                      # 0040141d
    ret                                          # 0040141e

# --- data items (not part of the function) -------------------------
.org 0x0040141f - 0x401000
PAD_0040141f:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

