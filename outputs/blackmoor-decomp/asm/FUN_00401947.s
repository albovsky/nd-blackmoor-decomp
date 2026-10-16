# FUN_00401947
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401947
# extent:       0x00401947-0x00401964 (29 code bytes)
# span:         0x00401947-0x00401964 (code 29, tables 0, padding 0)
# sha256:       63a8a3657d3ad81e8860a8254e312452faee9e38b23fb2e670c0d2203f912f3a
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401947
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401947 - 0x401000
.globl FUN_00401947
FUN_00401947:
    # block 0x00401947: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401947
    {load} mov ebp, esp                          # 00401948
    push ecx                                     # 0040194a
    mov dword ptr [ebp - local_4], ecx           # 0040194b
    mov dword ptr [0x569138], 0x18               # 0040194e
    mov ecx, dword ptr [ebp - local_4]           # 00401958
    call FUN_00401526                            # 0040195b
    {load} mov esp, ebp                          # 00401960
    pop ebp                                      # 00401962
    ret                                          # 00401963

