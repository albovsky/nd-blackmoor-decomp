# FUN_0040430e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040430e
# extent:       0x0040430e-0x00404349 (59 code bytes)
# span:         0x0040430e-0x00404349 (code 59, tables 0, padding 0)
# sha256:       3277820b4281cce40709b617e7f227d4208035044c72e548d3698b1d056b758b
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040430e
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

.org 0x0040430e - 0x401000
.globl FUN_0040430e
FUN_0040430e:
    # block 0x0040430e: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 0040430e
    {load} mov ebp, esp                          # 0040430f
    sub esp, 0x18                                # 00404311
    mov dword ptr [ebp - local_18], ecx          # 00404314
    push 0x13                                    # 00404317
    lea eax, [ebp - local_14]                    # 00404319
    push eax                                     # 0040431c
    mov ecx, dword ptr [ebp - local_18]          # 0040431d
    add ecx, 0x18c                               # 00404320
    call FUN_0051d5b2                            # 00404326
    lea ecx, [ebp - local_14]                    # 0040432b
    push ecx                                     # 0040432e
    call FUN_0050cb1b                            # 0040432f
    add esp, 0x4                                 # 00404334
    mov word ptr [0x5e5686], ax                  # 00404337
    mov ecx, dword ptr [ebp - local_18]          # 0040433d
    call FUN_004033db                            # 00404340
    {load} mov esp, ebp                          # 00404345
    pop ebp                                      # 00404347
    ret                                          # 00404348

