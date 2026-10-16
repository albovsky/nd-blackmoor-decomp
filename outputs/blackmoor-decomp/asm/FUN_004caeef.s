# FUN_004caeef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caeef
# extent:       0x004caeef-0x004caf03 (20 code bytes)
# span:         0x004caeef-0x004caf03 (code 20, tables 0, padding 0)
# sha256:       7b7b1c0914e07876616e5637b27a6836b8cdc17015edba04ef09b25aaecb2048
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004caeef
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004caeef - 0x401000
.globl FUN_004caeef
FUN_004caeef:
    # block 0x004caeef: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004caeef
    {load} mov ebp, esp                          # 004caef0
    push ecx                                     # 004caef2
    mov dword ptr [ebp - local_4], ecx           # 004caef3
    mov eax, dword ptr [ebp - local_4]           # 004caef6
    mov dword ptr [eax], 0x52e23c                # 004caef9
    {load} mov esp, ebp                          # 004caeff
    pop ebp                                      # 004caf01
    ret                                          # 004caf02

