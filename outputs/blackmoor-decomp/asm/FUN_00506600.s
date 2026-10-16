# FUN_00506600
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506600
# extent:       0x00506600-0x00506631 (49 code bytes)
# span:         0x00506600-0x00506640 (code 49, tables 0, padding 15)
# sha256:       2d064c82600abf3932d3d5f2ccc45b309f7f60ac1616e11409d3f8cb18c2a9a1
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506600
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c, field_10; [edx + n] field_4, field_8, field_c, field_10; [esp + n] stk_4, stk_8, stk_c
# callees:      calls FUN_00504fc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00504fc0, .text + (0x00504fc0 - 0x401000)

.org 0x00506600 - 0x401000
.globl FUN_00506600
FUN_00506600:
    # block 0x00506600: entry, 18 instruction(s), calls FUN_00504fc0, ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00506600
    {load} xor ecx, ecx                          # 00506604
    {load} mov edx, eax                          # 00506606
    mov dword ptr [edx], ecx                     # 00506608
    mov dword ptr [edx + field_4], ecx           # 0050660a
    mov dword ptr [edx + field_8], ecx           # 0050660d
    mov dword ptr [edx + field_c], ecx           # 00506610
    mov dword ptr [edx + field_10], ecx          # 00506613
    mov ecx, dword ptr [esp + stk_8]             # 00506616
    mov edx, dword ptr [esp + stk_c]             # 0050661a
    mov dword ptr [eax + field_c], ecx           # 0050661e
    {load} add ecx, ecx                          # 00506621
    mov dword ptr [eax + field_10], edx          # 00506623
    push ecx                                     # 00506626
    push eax                                     # 00506627
    call FUN_00504fc0                            # 00506628
    add esp, 0x8                                 # 0050662d
    ret                                          # 00506630

# --- data items (not part of the function) -------------------------
.org 0x00506631 - 0x401000
PAD_00506631:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

