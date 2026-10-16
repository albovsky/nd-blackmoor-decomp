# FUN_004d0abc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0abc
# extent:       0x004d0abc-0x004d0afc (64 code bytes)
# span:         0x004d0abc-0x004d0afc (code 64, tables 0, padding 0)
# sha256:       fda39eb9290397494a87b9351aa976f176fb851a909b8356c1907c75a6080701
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d0abc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0abc - 0x401000
.globl FUN_004d0abc
FUN_004d0abc:
    # block 0x004d0abc: entry, 17 instruction(s), calls FUN_004c5377, ends with ret
    push ebp                                     # 004d0abc
    {load} mov ebp, esp                          # 004d0abd
    push 0x55a05c                                # 004d0abf
    mov eax, dword ptr [0x5d2a27]                # 004d0ac4
    push eax                                     # 004d0ac9
    mov ecx, dword ptr [0x5d2a23]                # 004d0aca
    push ecx                                     # 004d0ad0
    mov edx, dword ptr [0x5cf665]                # 004d0ad1
    push edx                                     # 004d0ad7
    mov eax, dword ptr [0x5d2a1f]                # 004d0ad8
    push eax                                     # 004d0add
    mov ecx, 0x5cf659                            # 004d0ade
    call FUN_004c5377                            # 004d0ae3
    mov word ptr [0x5bb1c4], 0x2                 # 004d0ae8
    mov word ptr [0x63a97c], 0x0                 # 004d0af1
    pop ebp                                      # 004d0afa
    ret                                          # 004d0afb

