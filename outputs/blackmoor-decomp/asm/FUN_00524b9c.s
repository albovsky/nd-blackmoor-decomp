# FUN_00524b9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524b9c
# extent:       0x00524b9c-0x00524bce (50 code bytes)
# span:         0x00524b9c-0x00524bce (code 50, tables 0, padding 0)
# sha256:       b839e78f6177966ae69c60593e13306ccb70f29799052c20f1ef88f898368ccd
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524b9c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c, field_20, field_24, field_28, field_2c, field_34, field_54, field_58, field_5c, field_64
# callees:      calls USER32.dll!GetCursorPos
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524bce
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_34, 0x34  # offset +0x34
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x00524b9c - 0x401000
.globl FUN_00524b9c
FUN_00524b9c:
    # block 0x00524b9c: entry, 19 instruction(s), calls USER32.dll!GetCursorPos, ends with ret
    push esi                                     # 00524b9c
    {load} mov esi, ecx                          # 00524b9d
    push edi                                     # 00524b9f
    {load} xor edi, edi                          # 00524ba0
    lea eax, [esi + field_5c]                    # 00524ba2
    mov dword ptr [esi + field_1c], edi          # 00524ba5
    push eax                                     # 00524ba8
    mov dword ptr [esi + field_20], edi          # 00524ba9
    mov dword ptr [esi + field_28], edi          # 00524bac
    mov dword ptr [esi + field_2c], edi          # 00524baf
    mov dword ptr [esi + field_34], edi          # 00524bb2
    mov dword ptr [esi + field_64], edi          # 00524bb5
    call dword ptr [0x52a484]                    # 00524bb8
    mov dword ptr [esi + field_58], edi          # 00524bbe
    mov dword ptr [esi + field_54], edi          # 00524bc1
    mov dword ptr [esi + field_24], 0x1          # 00524bc4
    pop edi                                      # 00524bcb
    pop esi                                      # 00524bcc
    ret                                          # 00524bcd

