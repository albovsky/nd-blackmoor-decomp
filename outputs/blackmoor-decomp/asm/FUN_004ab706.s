# FUN_004ab706
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab706
# extent:       0x004ab706-0x004ab85a (340 code bytes)
# span:         0x004ab706-0x004ab85a (code 340, tables 0, padding 0)
# sha256:       c41094ab915d6939e49bb07e67d2cd13a9c61c8d7a6613b906cb6e27e93e25e5
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab706_lifted
# naming:       native port src/original_methods_fl39d.c:m4ab706_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_32; [ecx + n] field_32; [edx + n] field_32
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ab706_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_32, 0x32  # offset +0x32

# --- external targets -----------------------------------------------

.org 0x004ab706 - 0x401000
.globl FUN_004ab706
FUN_004ab706:
    # block 0x004ab706: entry, 7 instruction(s), ends with jne to 0x004ab77a (forward)
    push ebp                                     # 004ab706
    {load} mov ebp, esp                          # 004ab707
    push ecx                                     # 004ab709
    mov dword ptr [ebp - local_4], ecx           # 004ab70a
    movsx eax, word ptr [ebp + arg_8]            # 004ab70d
    cmp eax, 0x27ce                              # 004ab711
    jne.d8 L_004ab77a                            # 004ab716
    # block 0x004ab718: entered by fall-through of jne at 0x004ab716, 16 instruction(s), ends with forward jump to 0x004ab84a
    mov dword ptr [0x5b44f0], 0x16               # 004ab718
    mov dword ptr [0x5b44f4], 0x1                # 004ab722
    mov ecx, dword ptr [0x5d0377]                # 004ab72c
    mov dword ptr [0x5d162d], ecx                # 004ab732
    mov edx, dword ptr [0x5b44f0]                # 004ab738
    shl edx, 0x5                                 # 004ab73e
    mov eax, dword ptr [0x5b44f4]                # 004ab741
    shl eax, 0x4                                 # 004ab746
    lea ecx, [edx + eax + 0x5b160c]              # 004ab749
    mov dword ptr [0x5d1631], ecx                # 004ab750
    mov dword ptr [0x5d1639], 0x1                # 004ab756
    mov dword ptr [0x5c39e5], 0x27ce             # 004ab760
    mov edx, dword ptr [ebp - local_4]           # 004ab76a
    mov ax, word ptr [ebp + arg_c]               # 004ab76d
    mov word ptr [edx + field_32], ax            # 004ab771
    jmp.d32 L_004ab84a                           # 004ab775
L_004ab77a:
    # block 0x004ab77a: entered by jne at 0x004ab716, 3 instruction(s), ends with jne to 0x004ab7e5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ab77a
    cmp ecx, 0x27cf                              # 004ab77e
    jne.d8 L_004ab7e5                            # 004ab784
    # block 0x004ab786: entered by fall-through of jne at 0x004ab784, 16 instruction(s), ends with forward jump to 0x004ab84a
    mov dword ptr [0x5b44f0], 0x12               # 004ab786
    mov dword ptr [0x5b44f4], 0x1                # 004ab790
    mov edx, dword ptr [0x5d0377]                # 004ab79a
    mov dword ptr [0x5d162d], edx                # 004ab7a0
    mov eax, dword ptr [0x5b44f0]                # 004ab7a6
    shl eax, 0x5                                 # 004ab7ab
    mov ecx, dword ptr [0x5b44f4]                # 004ab7ae
    shl ecx, 0x4                                 # 004ab7b4
    lea edx, [eax + ecx + 0x5b160c]              # 004ab7b7
    mov dword ptr [0x5d1631], edx                # 004ab7be
    mov dword ptr [0x5d1639], 0x1                # 004ab7c4
    mov dword ptr [0x5c39e5], 0x27cf             # 004ab7ce
    mov eax, dword ptr [ebp - local_4]           # 004ab7d8
    mov cx, word ptr [ebp + arg_c]               # 004ab7db
    mov word ptr [eax + field_32], cx            # 004ab7df
    jmp.d8 L_004ab84a                            # 004ab7e3
L_004ab7e5:
    # block 0x004ab7e5: entered by jne at 0x004ab784, 3 instruction(s), ends with jne to 0x004ab84a (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004ab7e5
    cmp edx, 0x27d0                              # 004ab7e9
    jne.d8 L_004ab84a                            # 004ab7ef
    # block 0x004ab7f1: entered by fall-through of jne at 0x004ab7ef, 14 instruction(s), falls into the block at 0x004ab84a
    mov dword ptr [0x5b44f0], 0x9                # 004ab7f1
    mov dword ptr [0x5b44f4], 0x1                # 004ab7fb
    mov eax, dword ptr [0x5d0377]                # 004ab805
    mov dword ptr [0x5d162d], eax                # 004ab80a
    mov ecx, dword ptr [0x5b44f0]                # 004ab80f
    shl ecx, 0x5                                 # 004ab815
    mov edx, dword ptr [0x5b44f4]                # 004ab818
    shl edx, 0x4                                 # 004ab81e
    lea eax, [ecx + edx + 0x5b160c]              # 004ab821
    mov dword ptr [0x5d1631], eax                # 004ab828
    mov dword ptr [0x5d1639], 0x1                # 004ab82d
    mov dword ptr [0x5c39e5], 0x27d0             # 004ab837
    mov ecx, dword ptr [ebp - local_4]           # 004ab841
    mov word ptr [ecx + field_32], 0xffff        # 004ab844
L_004ab84a:
    # block 0x004ab84a: entered by jmp at 0x004ab775; jmp at 0x004ab7e3; jne at 0x004ab7ef, 5 instruction(s), ends with ret 0x8
    movsx edx, word ptr [ebp + arg_8]            # 004ab84a
    mov dword ptr [0x5c39e5], edx                # 004ab84e
    {load} mov esp, ebp                          # 004ab854
    pop ebp                                      # 004ab856
    ret 0x8                                      # 004ab857

