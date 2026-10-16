# FUN_00407112
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407112
# extent:       0x00407112-0x00407159 (71 code bytes)
# span:         0x00407112-0x00407159 (code 71, tables 0, padding 0)
# sha256:       c462c0d72e76779c9e4cf066c87b1cd59fec3ff7a7249d95f792fd79a1fc2036
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407112
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407112 - 0x401000
.globl FUN_00407112
FUN_00407112:
    # block 0x00407112: entry, 6 instruction(s), ends with jne to 0x0040712e (forward)
    push ebp                                     # 00407112
    {load} mov ebp, esp                          # 00407113
    push ecx                                     # 00407115
    mov dword ptr [ebp - local_4], ecx           # 00407116
    cmp dword ptr [0x5e3592], 0x1                # 00407119
    jne.d8 L_0040712e                            # 00407120
    # block 0x00407122: entered by fall-through of jne at 0x00407120, 2 instruction(s), ends with forward jump to 0x0040714d
    mov dword ptr [0x5e3592], 0x0                # 00407122
    jmp.d8 L_0040714d                            # 0040712c
L_0040712e:
    # block 0x0040712e: entered by jne at 0x00407120, 4 instruction(s), ends with jne to 0x0040714d (forward)
    mov dword ptr [0x5e3592], 0x1                # 0040712e
    movsx eax, word ptr [0x5e335e]               # 00407138
    cmp eax, 0x22                                # 0040713f
    jne.d8 L_0040714d                            # 00407142
    # block 0x00407144: entered by fall-through of jne at 0x00407142, 1 instruction(s), falls into the block at 0x0040714d
    mov word ptr [0x5e335e], 0xffff              # 00407144
L_0040714d:
    # block 0x0040714d: entered by jmp at 0x0040712c; jne at 0x00407142, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040714d
    call FUN_00404be1                            # 00407150
    {load} mov esp, ebp                          # 00407155
    pop ebp                                      # 00407157
    ret                                          # 00407158

