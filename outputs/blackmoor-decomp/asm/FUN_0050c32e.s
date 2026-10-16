# FUN_0050c32e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c32e
# extent:       0x0050c32e-0x0050c366 (56 code bytes)
# span:         0x0050c32e-0x0050c366 (code 56, tables 0, padding 0)
# sha256:       474338476ff741d20cd877956a13bc85cc80252723bb16d2f2b1dd48604959dd
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c32e
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; ret 0x20 (callee pops 32 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_4
# callees:      calls USER32.dll!TabbedTextOutA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c366
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0050c32e - 0x401000
.globl FUN_0050c32e
FUN_0050c32e:
    # block 0x0050c32e: entry, 20 instruction(s), calls USER32.dll!TabbedTextOutA, ends with ret 0x20
    push ebp                                     # 0050c32e
    {load} mov ebp, esp                          # 0050c32f
    push dword ptr [ebp + arg_24]                # 0050c331
    push dword ptr [ebp + arg_20]                # 0050c334
    push dword ptr [ebp + arg_1c]                # 0050c337
    push dword ptr [ebp + arg_18]                # 0050c33a
    push dword ptr [ebp + arg_14]                # 0050c33d
    push dword ptr [ebp + arg_10]                # 0050c340
    push dword ptr [ebp + arg_c]                 # 0050c343
    push dword ptr [ecx + field_4]               # 0050c346
    call dword ptr [0x52a3ac]                    # 0050c349
    mov ecx, dword ptr [ebp + arg_8]             # 0050c34f
    movsx edx, ax                                # 0050c352
    shr eax, 0x10                                # 0050c355
    movsx eax, ax                                # 0050c358
    mov dword ptr [ecx + field_4], eax           # 0050c35b
    mov dword ptr [ecx], edx                     # 0050c35e
    {load} mov eax, ecx                          # 0050c360
    pop ebp                                      # 0050c362
    ret 0x20                                     # 0050c363

