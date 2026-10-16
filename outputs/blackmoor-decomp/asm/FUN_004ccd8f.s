# FUN_004ccd8f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccd8f
# extent:       0x004ccd8f-0x004ccdab (28 code bytes)
# span:         0x004ccd8f-0x004ccdab (code 28, tables 0, padding 0)
# sha256:       ea00426ee6d5144d1cd819fcda50d6891ea0de96dea52691e96311d95e4f8021
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccd8f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004cd218
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004cd218, .text + (0x004cd218 - 0x401000)

.org 0x004ccd8f - 0x401000
.globl FUN_004ccd8f
FUN_004ccd8f:
    # block 0x004ccd8f: entry, 11 instruction(s), calls FUN_004cd218, ends with ret
    push ebp                                     # 004ccd8f
    {load} mov ebp, esp                          # 004ccd90
    push ecx                                     # 004ccd92
    mov dword ptr [ebp - local_4], ecx           # 004ccd93
    mov eax, dword ptr [ebp - local_4]           # 004ccd96
    mov dword ptr [eax], 0x52e2d0                # 004ccd99
    mov ecx, dword ptr [ebp - local_4]           # 004ccd9f
    call FUN_004cd218                            # 004ccda2
    {load} mov esp, ebp                          # 004ccda7
    pop ebp                                      # 004ccda9
    ret                                          # 004ccdaa

