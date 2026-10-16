# FUN_004939e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004939e6
# extent:       0x004939e6-0x00493a10 (42 code bytes)
# span:         0x004939e6-0x00493a10 (code 42, tables 0, padding 0)
# sha256:       eec9b6c59f5691762bbd1d9a73a298c4e07f80782e898d82f4f07207fe63e93f
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004939e6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1ef3; [ecx + n] field_201b
# callees:      calls FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1ef3, 0x1ef3  # offset +0x1ef3
.equ field_201b, 0x201b  # offset +0x201b

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004939e6 - 0x401000
.globl FUN_004939e6
FUN_004939e6:
    # block 0x004939e6: entry, 14 instruction(s), calls FUN_0050ce04, ends with ret
    push ebp                                     # 004939e6
    {load} mov ebp, esp                          # 004939e7
    sub esp, 0x8                                 # 004939e9
    mov dword ptr [ebp - local_4], ecx           # 004939ec
    mov eax, dword ptr [ebp - local_4]           # 004939ef
    fild dword ptr [eax + field_1ef3]            # 004939f2
    fstp dword ptr [ebp - local_8]               # 004939f8
    mov ecx, dword ptr [ebp - local_4]           # 004939fb
    fld dword ptr [ebp - local_8]                # 004939fe
    fmul dword ptr [ecx + field_201b]            # 00493a01
    call FUN_0050ce04                            # 00493a07
    {load} mov esp, ebp                          # 00493a0c
    pop ebp                                      # 00493a0e
    ret                                          # 00493a0f

