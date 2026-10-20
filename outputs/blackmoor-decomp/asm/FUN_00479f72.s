# FUN_00479f72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00479f72
# extent:       0x00479f72-0x0047a03c (202 code bytes)
# span:         0x00479f72-0x0047a03c (code 202, tables 0, padding 0)
# sha256:       8fd14dcccb8b3b05b644b7a92471ca47461d469daf9ce82b80aa6f0716b5ab77
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00479f72
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_159a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_159a, 0x159a  # offset +0x159a

# --- external targets -----------------------------------------------

.org 0x00479f72 - 0x401000
.globl FUN_00479f72
FUN_00479f72:
    # block 0x00479f72: entry, 7 instruction(s), ends with jne to 0x00479fd8 (forward)
    push ebp                                     # 00479f72
    {load} mov ebp, esp                          # 00479f73
    push ecx                                     # 00479f75
    mov dword ptr [ebp - local_4], ecx           # 00479f76
    movsx eax, word ptr [ebp + arg_8]            # 00479f79
    cmp eax, 0x279d                              # 00479f7d
    jne.d8 L_00479fd8                            # 00479f82
    # block 0x00479f84: entered by fall-through of jne at 0x00479f82, 14 instruction(s), ends with forward jump to 0x0047a036
    mov dword ptr [0x5b44f0], 0x9                # 00479f84
    mov dword ptr [0x5b44f4], 0x1                # 00479f8e
    mov ecx, dword ptr [0x5d0377]                # 00479f98
    mov dword ptr [0x5d162d], ecx                # 00479f9e
    mov edx, dword ptr [0x5b44f0]                # 00479fa4
    shl edx, 0x5                                 # 00479faa
    mov eax, dword ptr [0x5b44f4]                # 00479fad
    shl eax, 0x4                                 # 00479fb2
    lea ecx, [edx + eax + 0x5b160c]              # 00479fb5
    mov dword ptr [0x5d1631], ecx                # 00479fbc
    mov dword ptr [0x5d1639], 0x1                # 00479fc2
    movsx edx, word ptr [ebp + arg_8]            # 00479fcc
    mov dword ptr [0x5c39e5], edx                # 00479fd0
    jmp.d8 L_0047a036                            # 00479fd6
L_00479fd8:
    # block 0x00479fd8: entered by jne at 0x00479f82, 16 instruction(s), falls into the block at 0x0047a036
    mov dword ptr [0x5b44f0], 0x0                # 00479fd8
    mov dword ptr [0x5b44f4], 0x1                # 00479fe2
    mov eax, dword ptr [0x5d0377]                # 00479fec
    mov dword ptr [0x5d162d], eax                # 00479ff1
    mov ecx, dword ptr [0x5b44f0]                # 00479ff6
    shl ecx, 0x5                                 # 00479ffc
    mov edx, dword ptr [0x5b44f4]                # 00479fff
    shl edx, 0x4                                 # 0047a005
    lea eax, [ecx + edx + 0x5b160c]              # 0047a008
    mov dword ptr [0x5d1631], eax                # 0047a00f
    mov dword ptr [0x5d1639], 0x1                # 0047a014
    movsx ecx, word ptr [ebp + arg_8]            # 0047a01e
    mov dword ptr [0x5c39e5], ecx                # 0047a022
    mov edx, dword ptr [ebp - local_4]           # 0047a028
    mov ax, word ptr [ebp + arg_c]               # 0047a02b
    mov word ptr [edx + field_159a], ax          # 0047a02f
L_0047a036:
    # block 0x0047a036: entered by jmp at 0x00479fd6, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0047a036
    pop ebp                                      # 0047a038
    ret 0x8                                      # 0047a039

