# FUN_0042e693
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e693
# extent:       0x0042e693-0x0042e72c (153 code bytes)
# span:         0x0042e693-0x0042e72c (code 153, tables 0, padding 0)
# sha256:       6543690671b928d292808b913ae8778bd857758e0f0575d92400f411cc1efa87
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042e693
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)

.org 0x0042e693 - 0x401000
.globl FUN_0042e693
FUN_0042e693:
    # block 0x0042e693: entry, 6 instruction(s), ends with je to 0x0042e6a9 (forward)
    push ebp                                     # 0042e693
    {load} mov ebp, esp                          # 0042e694
    push ecx                                     # 0042e696
    mov eax, 0x1                                 # 0042e697
    test eax, eax                                # 0042e69c
    je.d8 L_0042e6a9                             # 0042e69e
    # block 0x0042e6a0: entered by fall-through of je at 0x0042e69e, 2 instruction(s), ends with forward jump to 0x0042e6c7
    mov dword ptr [ebp - local_4], 0x0           # 0042e6a0
    jmp.d8 L_0042e6c7                            # 0042e6a7
L_0042e6a9:
    # block 0x0042e6a9: entered by je at 0x0042e69e, 8 instruction(s), calls FUN_00427a40, falls into the block at 0x0042e6c7
    mov ecx, dword ptr [0x5bb57f]                # 0042e6a9
    push ecx                                     # 0042e6af
    mov edx, dword ptr [0x5bb57b]                # 0042e6b0
    push edx                                     # 0042e6b6
    push 0x545a5c                                # 0042e6b7
    call FUN_00427a40                            # 0042e6bc
    add esp, 0xc                                 # 0042e6c1
    mov dword ptr [ebp - local_4], eax           # 0042e6c4
L_0042e6c7:
    # block 0x0042e6c7: entered by jmp at 0x0042e6a7, 19 instruction(s), ends with ret
    mov ax, word ptr [0x5bb57b]                  # 0042e6c7
    mov word ptr [0x5c3a31], ax                  # 0042e6cd
    mov cx, word ptr [0x5bb57f]                  # 0042e6d3
    mov word ptr [0x5c3a33], cx                  # 0042e6da
    mov dx, word ptr [0x5bb50b]                  # 0042e6e1
    mov word ptr [0x5c3a35], dx                  # 0042e6e8
    mov ax, word ptr [0x5bb593]                  # 0042e6ef
    mov word ptr [0x5c3a37], ax                  # 0042e6f5
    mov cx, word ptr [ebp + arg_8]               # 0042e6fb
    mov word ptr [0x5c3a39], cx                  # 0042e6ff
    mov edx, dword ptr [0x5bb5a7]                # 0042e706
    mov dword ptr [0x5c3a3b], edx                # 0042e70c
    mov eax, dword ptr [0x5bb5ab]                # 0042e712
    mov dword ptr [0x5c3a3f], eax                # 0042e717
    mov ecx, dword ptr [0x5bb5af]                # 0042e71c
    mov dword ptr [0x5c3a3f], ecx                # 0042e722
    {load} mov esp, ebp                          # 0042e728
    pop ebp                                      # 0042e72a
    ret                                          # 0042e72b

