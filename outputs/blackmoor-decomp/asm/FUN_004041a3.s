# FUN_004041a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004041a3
# extent:       0x004041a3-0x004041d7 (52 code bytes)
# span:         0x004041a3-0x004041d7 (code 52, tables 0, padding 0)
# sha256:       463975b03251cf4473c68665fb0941bf6f1cf11cd40b0e2e96b9467a0ce57e58
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004041a3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d912a, FUN_0052139c, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_004d912a, .text + (0x004d912a - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004041a3 - 0x401000
.globl FUN_004041a3
FUN_004041a3:
    # block 0x004041a3: entry, 9 instruction(s), calls FUN_004d912a, ends with jne to 0x004041cb (forward)
    push ebp                                     # 004041a3
    {load} mov ebp, esp                          # 004041a4
    push ecx                                     # 004041a6
    mov dword ptr [ebp - local_4], ecx           # 004041a7
    mov ecx, 0x5e2e70                            # 004041aa
    call FUN_004d912a                            # 004041af
    movsx eax, ax                                # 004041b4
    test eax, eax                                # 004041b7
    jne.d8 L_004041cb                            # 004041b9
    # block 0x004041bb: entered by fall-through of jne at 0x004041b9, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004041d3
    push 0x0                                     # 004041bb
    push 0x0                                     # 004041bd
    push 0x53e8f0                                # 004041bf
    call FUN_0052139c                            # 004041c4
    jmp.d8 L_004041d3                            # 004041c9
L_004041cb:
    # block 0x004041cb: entered by jne at 0x004041b9, 2 instruction(s), calls FUN_004033db, falls into the block at 0x004041d3
    mov ecx, dword ptr [ebp - local_4]           # 004041cb
    call FUN_004033db                            # 004041ce
L_004041d3:
    # block 0x004041d3: entered by jmp at 0x004041c9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004041d3
    pop ebp                                      # 004041d5
    ret                                          # 004041d6

