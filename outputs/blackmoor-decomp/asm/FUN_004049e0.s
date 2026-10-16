# FUN_004049e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004049e0
# extent:       0x004049e0-0x00404a1b (59 code bytes)
# span:         0x004049e0-0x00404a20 (code 59, tables 0, padding 5)
# sha256:       ca7192872b03412191ea25dcc9932a3ae2210e4e9b65ffed037f9ecba3e31c62
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004049e0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x004049e0 - 0x401000
.globl FUN_004049e0
FUN_004049e0:
    # block 0x004049e0: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004049e0
    {load} mov ebp, esp                          # 004049e1
    sub esp, 0x18                                # 004049e3
    mov dword ptr [ebp - local_18], ecx          # 004049e6
    push 0x13                                    # 004049e9
    lea eax, [ebp - local_14]                    # 004049eb
    push eax                                     # 004049ee
    mov ecx, dword ptr [ebp - local_18]          # 004049ef
    add ecx, 0x40c                               # 004049f2
    call FUN_0051d5b2                            # 004049f8
    lea ecx, [ebp - local_14]                    # 004049fd
    push ecx                                     # 00404a00
    call FUN_0050cb1b                            # 00404a01
    add esp, 0x4                                 # 00404a06
    mov word ptr [0x5ec286], ax                  # 00404a09
    mov ecx, dword ptr [ebp - local_18]          # 00404a0f
    call FUN_004033db                            # 00404a12
    {load} mov esp, ebp                          # 00404a17
    pop ebp                                      # 00404a19
    ret                                          # 00404a1a

# --- data items (not part of the function) -------------------------
.org 0x00404a1b - 0x401000
PAD_00404a1b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

