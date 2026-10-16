# FUN_004b8193
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8193
# extent:       0x004b8193-0x004b81ff (108 code bytes)
# span:         0x004b8193-0x004b81ff (code 108, tables 0, padding 0)
# sha256:       7fdadd5ee8c4822265ea8ab0504cb7dcbacdd69af7e34efe7ef5e86c50b48a70
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b8193
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6, field_14, field_636; [ecx + n] field_10; [edx + n] field_637
# callees:      calls FUN_00437ea1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_636, 0x636  # offset +0x636
.equ field_637, 0x637  # offset +0x637

# --- external targets -----------------------------------------------
.set FUN_00437ea1, .text + (0x00437ea1 - 0x401000)

.org 0x004b8193 - 0x401000
.globl FUN_004b8193
FUN_004b8193:
    # block 0x004b8193: entry, 7 instruction(s), ends with je to 0x004b81f9 (forward)
    push ebp                                     # 004b8193
    {load} mov ebp, esp                          # 004b8194
    push ecx                                     # 004b8196
    mov dword ptr [ebp - local_4], ecx           # 004b8197
    mov eax, dword ptr [ebp - local_4]           # 004b819a
    cmp dword ptr [eax + field_14], 0x0          # 004b819d
    je.d8 L_004b81f9                             # 004b81a1
    # block 0x004b81a3: entered by fall-through of je at 0x004b81a1, 3 instruction(s), ends with jne to 0x004b81f9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b81a3
    cmp dword ptr [ecx + field_10], 0x0          # 004b81a6
    jne.d8 L_004b81f9                            # 004b81aa
    # block 0x004b81ac: entered by fall-through of jne at 0x004b81aa, 3 instruction(s), ends with jne to 0x004b81f9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b81ac
    cmp dword ptr [edx + field_637], 0x0         # 004b81af
    jne.d8 L_004b81f9                            # 004b81b6
    # block 0x004b81b8: entered by fall-through of jne at 0x004b81b6, 5 instruction(s), ends with jne to 0x004b81f9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b81b8
    movsx ecx, word ptr [eax + field_6]          # 004b81bb
    imul ecx, ecx, 0x8d                          # 004b81bf
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004b81c5
    jne.d8 L_004b81f9                            # 004b81cc
    # block 0x004b81ce: entered by fall-through of jne at 0x004b81cc, 6 instruction(s), calls FUN_00437ea1, ends with je to 0x004b81f9 (forward)
    mov dl, byte ptr [ebp + arg_8]               # 004b81ce
    push edx                                     # 004b81d1
    mov ecx, 0x583208                            # 004b81d2
    call FUN_00437ea1                            # 004b81d7
    test eax, eax                                # 004b81dc
    je.d8 L_004b81f9                             # 004b81de
    # block 0x004b81e0: entered by fall-through of je at 0x004b81de, 5 instruction(s), falls into the block at 0x004b81f9
    mov eax, dword ptr [ebp - local_4]           # 004b81e0
    mov cl, byte ptr [ebp + arg_8]               # 004b81e3
    mov byte ptr [eax + field_636], cl           # 004b81e6
    mov edx, dword ptr [ebp - local_4]           # 004b81ec
    mov dword ptr [edx + field_637], 0x1         # 004b81ef
L_004b81f9:
    # block 0x004b81f9: entered by je at 0x004b81a1; jne at 0x004b81aa; jne at 0x004b81b6; jne at 0x004b81cc; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004b81f9
    pop ebp                                      # 004b81fb
    ret 0x4                                      # 004b81fc

