# FUN_00406e93
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406e93
# extent:       0x00406e93-0x00406eda (71 code bytes)
# span:         0x00406e93-0x00406eda (code 71, tables 0, padding 0)
# sha256:       142fe015a73f05f594375e435d6c69964bd5a51633856d0286826869f9a673b9
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406e93
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

.org 0x00406e93 - 0x401000
.globl FUN_00406e93
FUN_00406e93:
    # block 0x00406e93: entry, 6 instruction(s), ends with jne to 0x00406eaf (forward)
    push ebp                                     # 00406e93
    {load} mov ebp, esp                          # 00406e94
    push ecx                                     # 00406e96
    mov dword ptr [ebp - local_4], ecx           # 00406e97
    cmp dword ptr [0x5e356e], 0x1                # 00406e9a
    jne.d8 L_00406eaf                            # 00406ea1
    # block 0x00406ea3: entered by fall-through of jne at 0x00406ea1, 2 instruction(s), ends with forward jump to 0x00406ece
    mov dword ptr [0x5e356e], 0x0                # 00406ea3
    jmp.d8 L_00406ece                            # 00406ead
L_00406eaf:
    # block 0x00406eaf: entered by jne at 0x00406ea1, 4 instruction(s), ends with jne to 0x00406ece (forward)
    mov dword ptr [0x5e356e], 0x1                # 00406eaf
    movsx eax, word ptr [0x5e335e]               # 00406eb9
    cmp eax, 0x19                                # 00406ec0
    jne.d8 L_00406ece                            # 00406ec3
    # block 0x00406ec5: entered by fall-through of jne at 0x00406ec3, 1 instruction(s), falls into the block at 0x00406ece
    mov word ptr [0x5e335e], 0xffff              # 00406ec5
L_00406ece:
    # block 0x00406ece: entered by jmp at 0x00406ead; jne at 0x00406ec3, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406ece
    call FUN_00404be1                            # 00406ed1
    {load} mov esp, ebp                          # 00406ed6
    pop ebp                                      # 00406ed8
    ret                                          # 00406ed9

