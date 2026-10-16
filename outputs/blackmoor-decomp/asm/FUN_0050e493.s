# FUN_0050e493
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e493
# extent:       0x0050e493-0x0050e4c2 (47 code bytes)
# span:         0x0050e493-0x0050e4c2 (code 47, tables 0, padding 0)
# sha256:       14015062d028d7a4fd6266c3d9648dda5b1c7434de796de29f786a1447f96d0b
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e493
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005120d4, FUN_0050e4c2, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050e4c2, .text + (0x0050e4c2 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050e493 - 0x401000
.globl FUN_0050e493
FUN_0050e493:
    # block 0x0050e493: entry, 18 instruction(s), calls FUN_005120d4, FUN_0050e4c2, FUN_00512126, ends with ret
    push ebp                                     # 0050e493
    {load} mov ebp, esp                          # 0050e494
    push esi                                     # 0050e496
    push dword ptr [ebp + arg_14]                # 0050e497
    call FUN_005120d4                            # 0050e49a
    push dword ptr [ebp + arg_14]                # 0050e49f
    push dword ptr [ebp + arg_10]                # 0050e4a2
    push dword ptr [ebp + arg_c]                 # 0050e4a5
    push dword ptr [ebp + arg_8]                 # 0050e4a8
    call FUN_0050e4c2                            # 0050e4ab
    push dword ptr [ebp + arg_14]                # 0050e4b0
    {load} mov esi, eax                          # 0050e4b3
    call FUN_00512126                            # 0050e4b5
    add esp, 0x18                                # 0050e4ba
    {load} mov eax, esi                          # 0050e4bd
    pop esi                                      # 0050e4bf
    pop ebp                                      # 0050e4c0
    ret                                          # 0050e4c1

