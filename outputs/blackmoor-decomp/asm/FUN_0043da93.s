# FUN_0043da93
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043da93
# extent:       0x0043da93-0x0043dbd5 (322 code bytes)
# span:         0x0043da93-0x0043dbd5 (code 322, tables 0, padding 0)
# sha256:       83e58c3c9f6ddad132a207663d61d2154e887d1ea3edf5edd6d45a92b739d74e
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043da93
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d3cba, FUN_004d3c9a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d3c9a, .text + (0x004d3c9a - 0x401000)
.set FUN_004d3cba, .text + (0x004d3cba - 0x401000)

.org 0x0043da93 - 0x401000
.globl FUN_0043da93
FUN_0043da93:
    # block 0x0043da93: entry, 14 instruction(s), calls FUN_004d3cba, FUN_004d3c9a, ends with jne to 0x0043dafa (forward)
    push ebp                                     # 0043da93
    {load} mov ebp, esp                          # 0043da94
    push ecx                                     # 0043da96
    mov dword ptr [0x5d15a5], 0x0                # 0043da97
    mov dword ptr [0x5d15ef], 0x0                # 0043daa1
    mov dword ptr [0x5d1639], 0x0                # 0043daab
    mov dword ptr [0x5d1683], 0x0                # 0043dab5
    mov dword ptr [0x5d16cd], 0x0                # 0043dabf
    mov ecx, 0x61c387                            # 0043dac9
    call FUN_004d3cba                            # 0043dace
    mov ecx, 0x61c387                            # 0043dad3
    call FUN_004d3c9a                            # 0043dad8
    cmp dword ptr [0x5bb1d2], 0x0                # 0043dadd
    jne.d8 L_0043dafa                            # 0043dae4
    # block 0x0043dae6: entered by fall-through of jne at 0x0043dae4, 3 instruction(s), falls into the block at 0x0043dafa
    mov eax, dword ptr [0x5b15d6]                # 0043dae6
    mov dword ptr [0x5bb1ce], eax                # 0043daeb
    mov dword ptr [0x5bb1d2], 0x1                # 0043daf0
L_0043dafa:
    # block 0x0043dafa: entered by jne at 0x0043dae4, 3 instruction(s), ends with jne to 0x0043db23 (forward)
    mov dword ptr [0x5b15d6], 0x0                # 0043dafa
    cmp dword ptr [0x5bb1da], 0x0                # 0043db04
    jne.d8 L_0043db23                            # 0043db0b
    # block 0x0043db0d: entered by fall-through of jne at 0x0043db0b, 3 instruction(s), falls into the block at 0x0043db23
    mov ecx, dword ptr [0x5b1606]                # 0043db0d
    mov dword ptr [0x5bb1d6], ecx                # 0043db13
    mov dword ptr [0x5bb1da], 0x1                # 0043db19
L_0043db23:
    # block 0x0043db23: entered by jne at 0x0043db0b, 13 instruction(s), ends with forward jump to 0x0043dba5
    mov dword ptr [0x5b1606], 0x0                # 0043db23
    mov dword ptr [0x5d191d], 0x0                # 0043db2d
    mov dword ptr [0x5d1967], 0x0                # 0043db37
    mov dword ptr [0x5d19b1], 0x0                # 0043db41
    mov dword ptr [0x5d19fb], 0x0                # 0043db4b
    mov dword ptr [0x5d1a8f], 0x0                # 0043db55
    mov dword ptr [0x5d1ad9], 0x0                # 0043db5f
    mov dword ptr [0x5d1b23], 0x0                # 0043db69
    mov dword ptr [0x5d1bb7], 0x0                # 0043db73
    mov dword ptr [0x5d1c01], 0x0                # 0043db7d
    mov dword ptr [0x5d1b6d], 0x0                # 0043db87
    mov word ptr [ebp - local_4], 0x18           # 0043db91
    jmp.d8 L_0043dba5                            # 0043db97
L_0043db99:
    # block 0x0043db99: entered by jmp at 0x0043dbcf, 3 instruction(s), falls into the block at 0x0043dba5
    mov dx, word ptr [ebp - local_4]             # 0043db99
    add dx, 0x1                                  # 0043db9d
    mov word ptr [ebp - local_4], dx             # 0043dba1
L_0043dba5:
    # block 0x0043dba5: entered by jmp at 0x0043db97, 3 instruction(s), ends with jg to 0x0043dbd1 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0043dba5
    cmp eax, 0x3f                                # 0043dba9
    jg.d8 L_0043dbd1                             # 0043dbac
    # block 0x0043dbae: entered by fall-through of jg at 0x0043dbac, 4 instruction(s), ends with je to 0x0043dbcf (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0043dbae
    imul ecx, ecx, 0x4a                          # 0043dbb2
    cmp dword ptr [ecx + 0x5d15a9], 0x0          # 0043dbb5
    je.d8 L_0043dbcf                             # 0043dbbc
    # block 0x0043dbbe: entered by fall-through of je at 0x0043dbbc, 3 instruction(s), falls into the block at 0x0043dbcf
    movsx edx, word ptr [ebp - local_4]          # 0043dbbe
    imul edx, edx, 0x4a                          # 0043dbc2
    mov dword ptr [edx + 0x5d15a5], 0x0          # 0043dbc5
L_0043dbcf:
    # block 0x0043dbcf: entered by je at 0x0043dbbc, 1 instruction(s), ends with backward jump to 0x0043db99
    jmp.d8 L_0043db99                            # 0043dbcf
L_0043dbd1:
    # block 0x0043dbd1: entered by jg at 0x0043dbac, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0043dbd1
    pop ebp                                      # 0043dbd3
    ret                                          # 0043dbd4

