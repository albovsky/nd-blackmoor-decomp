# FUN_004041d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004041d7
# extent:       0x004041d7-0x004041ec (21 code bytes)
# span:         0x004041d7-0x004041ec (code 21, tables 0, padding 0)
# sha256:       e2a5c45a85872a89dd82cb75247c1d0a385b77d0946d704d30f0715e87f5a2e8
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004041d7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d920c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d920c, .text + (0x004d920c - 0x401000)

.org 0x004041d7 - 0x401000
.globl FUN_004041d7
FUN_004041d7:
    # block 0x004041d7: entry, 9 instruction(s), calls FUN_004d920c, ends with ret
    push ebp                                     # 004041d7
    {load} mov ebp, esp                          # 004041d8
    push ecx                                     # 004041da
    mov dword ptr [ebp - local_4], ecx           # 004041db
    mov ecx, 0x5e2e70                            # 004041de
    call FUN_004d920c                            # 004041e3
    {load} mov esp, ebp                          # 004041e8
    pop ebp                                      # 004041ea
    ret                                          # 004041eb

