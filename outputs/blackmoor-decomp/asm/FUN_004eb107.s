# FUN_004eb107
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb107
# extent:       0x004eb107-0x004eb184 (125 code bytes)
# span:         0x004eb107-0x004eb184 (code 125, tables 0, padding 0)
# sha256:       a5aab32286035918e586e32b4e828757ad67295856d835e72c28011cc64eed5f
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eb107
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_77e
# callees:      calls FUN_004e9e84, FUN_004d36ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_77e, 0x77e  # offset +0x77e

# --- external targets -----------------------------------------------
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)

.org 0x004eb107 - 0x401000
.globl FUN_004eb107
FUN_004eb107:
    # block 0x004eb107: entry, 7 instruction(s), ends with jne to 0x004eb17e (forward)
    push ebp                                     # 004eb107
    {load} mov ebp, esp                          # 004eb108
    push ecx                                     # 004eb10a
    mov dword ptr [ebp - local_4], ecx           # 004eb10b
    movsx eax, word ptr [0x583a29]               # 004eb10e
    cmp eax, dword ptr [ebp + arg_8]             # 004eb115
    jne.d8 L_004eb17e                            # 004eb118
    # block 0x004eb11a: entered by fall-through of jne at 0x004eb118, 6 instruction(s), ends with jne to 0x004eb141 (forward)
    movsx ecx, word ptr [0x583a29]               # 004eb11a
    imul ecx, ecx, 0x16d                         # 004eb121
    mov edx, dword ptr [ebp - local_4]           # 004eb127
    movsx eax, word ptr [edx + ecx + field_77e]  # 004eb12a
    test eax, eax                                # 004eb132
    jne.d8 L_004eb141                            # 004eb134
    # block 0x004eb136: entered by fall-through of jne at 0x004eb134, 2 instruction(s), ends with forward jump to 0x004eb179
    mov word ptr [0x583a29], 0xffff              # 004eb136
    jmp.d8 L_004eb179                            # 004eb13f
L_004eb141:
    # block 0x004eb141: entered by jne at 0x004eb134, 6 instruction(s), ends with jne to 0x004eb179 (forward)
    movsx ecx, word ptr [0x583a29]               # 004eb141
    imul ecx, ecx, 0x16d                         # 004eb148
    mov edx, dword ptr [ebp - local_4]           # 004eb14e
    movsx eax, word ptr [edx + ecx + field_77e]  # 004eb151
    cmp eax, 0x2                                 # 004eb159
    jne.d8 L_004eb179                            # 004eb15c
    # block 0x004eb15e: entered by fall-through of jne at 0x004eb15c, 6 instruction(s), calls FUN_004e9e84, falls into the block at 0x004eb179
    push 0x1                                     # 004eb15e
    mov cx, word ptr [0x583a29]                  # 004eb160
    push ecx                                     # 004eb167
    mov ecx, dword ptr [ebp - local_4]           # 004eb168
    call FUN_004e9e84                            # 004eb16b
    mov word ptr [0x583a29], 0xffff              # 004eb170
L_004eb179:
    # block 0x004eb179: entered by jmp at 0x004eb13f; jne at 0x004eb15c, 1 instruction(s), calls FUN_004d36ed, falls into the block at 0x004eb17e
    call FUN_004d36ed                            # 004eb179
L_004eb17e:
    # block 0x004eb17e: entered by jne at 0x004eb118, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004eb17e
    pop ebp                                      # 004eb180
    ret 0x4                                      # 004eb181

