# FUN_00516885
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516885
# extent:       0x00516885-0x005168ba (53 code bytes)
# span:         0x00516885-0x005168ba (code 53, tables 0, padding 0)
# sha256:       2a0b18660fd0afee522ea1b3514e12d3c8c86309534c43ad0f32821e23cd0174
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516885
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005168d0, FUN_00516962
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_005168d0, .text + (0x005168d0 - 0x401000)
.set FUN_00516962, .text + (0x00516962 - 0x401000)

.org 0x00516885 - 0x401000
.globl FUN_00516885
FUN_00516885:
    # block 0x00516885: entry, 25 instruction(s), calls FUN_005168d0, FUN_00516962, ends with ret
    push ebp                                     # 00516885
    {load} mov ebp, esp                          # 00516886
    push ecx                                     # 00516888
    push esi                                     # 00516889
    wait                                         # 0051688a
    fnstcw word ptr [ebp - local_4]              # 0051688b
    push dword ptr [ebp - local_4]               # 0051688e
    call FUN_005168d0                            # 00516891
    {load} mov esi, eax                          # 00516896
    mov eax, dword ptr [ebp + arg_c]             # 00516898
    not eax                                      # 0051689b
    {load} and esi, eax                          # 0051689d
    mov eax, dword ptr [ebp + arg_8]             # 0051689f
    and eax, dword ptr [ebp + arg_c]             # 005168a2
    {load} or esi, eax                           # 005168a5
    push esi                                     # 005168a7
    call FUN_00516962                            # 005168a8
    pop ecx                                      # 005168ad
    mov dword ptr [ebp + arg_c], eax             # 005168ae
    pop ecx                                      # 005168b1
    fldcw word ptr [ebp + arg_c]                 # 005168b2
    {load} mov eax, esi                          # 005168b5
    pop esi                                      # 005168b7
    leave                                        # 005168b8
    ret                                          # 005168b9

