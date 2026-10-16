# FUN_004042d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004042d3
# extent:       0x004042d3-0x0040430e (59 code bytes)
# span:         0x004042d3-0x0040430e (code 59, tables 0, padding 0)
# sha256:       436c11b5a79c0cc59c2f5612b10fa84e94fc38c6f1ea8a61fa54c269f283807b
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004042d3
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

.org 0x004042d3 - 0x401000
.globl FUN_004042d3
FUN_004042d3:
    # block 0x004042d3: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004042d3
    {load} mov ebp, esp                          # 004042d4
    sub esp, 0x18                                # 004042d6
    mov dword ptr [ebp - local_18], ecx          # 004042d9
    push 0x13                                    # 004042dc
    lea eax, [ebp - local_14]                    # 004042de
    push eax                                     # 004042e1
    mov ecx, dword ptr [ebp - local_18]          # 004042e2
    add ecx, 0x1cc                               # 004042e5
    call FUN_0051d5b2                            # 004042eb
    lea ecx, [ebp - local_14]                    # 004042f0
    push ecx                                     # 004042f3
    call FUN_0050cb1b                            # 004042f4
    add esp, 0x4                                 # 004042f9
    mov word ptr [0x5e5688], ax                  # 004042fc
    mov ecx, dword ptr [ebp - local_18]          # 00404302
    call FUN_004033db                            # 00404305
    {load} mov esp, ebp                          # 0040430a
    pop ebp                                      # 0040430c
    ret                                          # 0040430d

