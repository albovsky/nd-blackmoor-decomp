# FUN_004d5260
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5260
# extent:       0x004d5260-0x004d527f (31 code bytes)
# span:         0x004d5260-0x004d527f (code 31, tables 0, padding 0)
# sha256:       594e87525a6dfc523f0d5a0caa0dd02255753a45e1c80cbc6473a22c51085078
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5260
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d529b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d529b, .text + (0x004d529b - 0x401000)

.org 0x004d5260 - 0x401000
.globl FUN_004d5260
FUN_004d5260:
    # block 0x004d5260: entry, 12 instruction(s), calls FUN_004d529b, ends with ret
    push ebp                                     # 004d5260
    {load} mov ebp, esp                          # 004d5261
    push ecx                                     # 004d5263
    mov dword ptr [ebp - local_4], ecx           # 004d5264
    mov eax, dword ptr [ebp - local_4]           # 004d5267
    mov dword ptr [eax], 0x52e450                # 004d526a
    mov ecx, dword ptr [ebp - local_4]           # 004d5270
    call FUN_004d529b                            # 004d5273
    mov eax, dword ptr [ebp - local_4]           # 004d5278
    {load} mov esp, ebp                          # 004d527b
    pop ebp                                      # 004d527d
    ret                                          # 004d527e

