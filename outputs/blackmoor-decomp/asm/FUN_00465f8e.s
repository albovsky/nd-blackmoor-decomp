# FUN_00465f8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465f8e
# extent:       0x00465f8e-0x00466073 (229 code bytes)
# span:         0x00465f8e-0x00466073 (code 229, tables 0, padding 0)
# sha256:       a386631b30afb0132dac7f6a2c1eb8dc4e7c7ae0ba344e2485c5e5251f22e6c5
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00465f8e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_28; [edx + n] field_28
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------

.org 0x00465f8e - 0x401000
.globl FUN_00465f8e
FUN_00465f8e:
    # block 0x00465f8e: entry, 7 instruction(s), ends with jne to 0x00465ffe (forward)
    push ebp                                     # 00465f8e
    {load} mov ebp, esp                          # 00465f8f
    push ecx                                     # 00465f91
    mov dword ptr [ebp - local_4], ecx           # 00465f92
    movsx eax, word ptr [ebp + arg_8]            # 00465f95
    cmp eax, 0x27d2                              # 00465f99
    jne.d8 L_00465ffe                            # 00465f9e
    # block 0x00465fa0: entered by fall-through of jne at 0x00465f9e, 18 instruction(s), ends with forward jump to 0x00466064
    movsx ecx, word ptr [ebp + arg_c]            # 00465fa0
    mov dword ptr [0x5b44f0], ecx                # 00465fa4
    mov edx, dword ptr [0x5d0377]                # 00465faa
    mov dword ptr [0x5d162d], edx                # 00465fb0
    mov dword ptr [0x5b44f8], 0x1                # 00465fb6
    mov eax, dword ptr [0x5b44f0]                # 00465fc0
    shl eax, 0x5                                 # 00465fc5
    mov ecx, dword ptr [0x5b44f4]                # 00465fc8
    shl ecx, 0x4                                 # 00465fce
    lea edx, [eax + ecx + 0x5b160c]              # 00465fd1
    mov dword ptr [0x5d1631], edx                # 00465fd8
    mov dword ptr [0x5d1639], 0x1                # 00465fde
    movsx eax, word ptr [ebp + arg_8]            # 00465fe8
    mov dword ptr [0x5c39e5], eax                # 00465fec
    mov ecx, dword ptr [ebp - local_4]           # 00465ff1
    mov dx, word ptr [ebp + arg_10]              # 00465ff4
    mov word ptr [ecx + field_28], dx            # 00465ff8
    jmp.d8 L_00466064                            # 00465ffc
L_00465ffe:
    # block 0x00465ffe: entered by jne at 0x00465f9e, 3 instruction(s), ends with jne to 0x00466064 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00465ffe
    cmp eax, 0x27d3                              # 00466002
    jne.d8 L_00466064                            # 00466007
    # block 0x00466009: entered by fall-through of jne at 0x00466007, 14 instruction(s), falls into the block at 0x00466064
    mov dword ptr [0x5b44f4], 0x1                # 00466009
    mov dword ptr [0x5b44f0], 0x9                # 00466013
    mov ecx, dword ptr [0x5d0377]                # 0046601d
    mov dword ptr [0x5d162d], ecx                # 00466023
    mov edx, dword ptr [0x5b44f0]                # 00466029
    shl edx, 0x5                                 # 0046602f
    mov eax, dword ptr [0x5b44f4]                # 00466032
    shl eax, 0x4                                 # 00466037
    lea ecx, [edx + eax + 0x5b160c]              # 0046603a
    mov dword ptr [0x5d1631], ecx                # 00466041
    mov dword ptr [0x5d1639], 0x1                # 00466047
    mov dword ptr [0x5c39e5], 0x27d3             # 00466051
    mov edx, dword ptr [ebp - local_4]           # 0046605b
    mov word ptr [edx + field_28], 0x0           # 0046605e
L_00466064:
    # block 0x00466064: entered by jmp at 0x00465ffc; jne at 0x00466007, 5 instruction(s), ends with ret 0xc
    movsx eax, word ptr [ebp + arg_8]            # 00466064
    mov dword ptr [0x5c39e5], eax                # 00466068
    {load} mov esp, ebp                          # 0046606d
    pop ebp                                      # 0046606f
    ret 0xc                                      # 00466070

