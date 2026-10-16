# FUN_0047d734
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d734
# extent:       0x0047d734-0x0047d77d (73 code bytes)
# span:         0x0047d734-0x0047d77d (code 73, tables 0, padding 0)
# sha256:       0fc7266b0f4fb4b88be1752afc9bd634476b1f6945388becec1b1b3b3910d256
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047d734
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1d, field_57; [ecx + n] field_27; [edx + n] field_25
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.h:d9_pointer_move (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1d, 0x1d  # offset +0x1d
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------

.org 0x0047d734 - 0x401000
.globl FUN_0047d734
FUN_0047d734:
    # block 0x0047d734: entry, 14 instruction(s), ends with je to 0x0047d775 (forward)
    push ebp                                     # 0047d734
    {load} mov ebp, esp                          # 0047d735
    sub esp, 0x8                                 # 0047d737
    mov dword ptr [ebp - local_8], ecx           # 0047d73a
    mov eax, dword ptr [ebp - local_8]           # 0047d73d
    movsx ecx, word ptr [eax + field_1d]         # 0047d740
    imul ecx, ecx, 0x8d                          # 0047d744
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047d74a
    mov dword ptr [ebp - local_4], edx           # 0047d750
    mov eax, dword ptr [ebp - local_8]           # 0047d753
    {load} xor ecx, ecx                          # 0047d756
    mov cl, byte ptr [eax + field_57]            # 0047d758
    test ecx, ecx                                # 0047d75b
    je.d8 L_0047d775                             # 0047d75d
    # block 0x0047d75f: entered by fall-through of je at 0x0047d75d, 6 instruction(s), falls into the block at 0x0047d775
    mov edx, dword ptr [ebp - local_8]           # 0047d75f
    mov ax, word ptr [ebp + arg_8]               # 0047d762
    mov word ptr [edx + field_25], ax            # 0047d766
    mov ecx, dword ptr [ebp - local_8]           # 0047d76a
    mov dx, word ptr [ebp + arg_c]               # 0047d76d
    mov word ptr [ecx + field_27], dx            # 0047d771
L_0047d775:
    # block 0x0047d775: entered by je at 0x0047d75d, 4 instruction(s), ends with ret 0x8
    {load} xor eax, eax                          # 0047d775
    {load} mov esp, ebp                          # 0047d777
    pop ebp                                      # 0047d779
    ret 0x8                                      # 0047d77a

