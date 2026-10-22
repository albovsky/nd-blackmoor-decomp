# FUN_0043ef3b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ef3b
# extent:       0x0043ef3b-0x0043ef77 (60 code bytes)
# span:         0x0043ef3b-0x0043ef77 (code 60, tables 0, padding 0)
# sha256:       7ac72514af985e24441d05ae0d777aa7d1ec6c5bb44d4c83c40b5ddc0e685eff
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43ef3b_lifted
# naming:       native port src/original_methods_fl40.c:m43ef3b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 22/22 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43ef3b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0043ef3b - 0x401000
.globl FUN_0043ef3b
FUN_0043ef3b:
    # block 0x0043ef3b: entry, 8 instruction(s), ends with forward jump to 0x0043ef5c
    push ebp                                     # 0043ef3b
    {load} mov ebp, esp                          # 0043ef3c
    sub esp, 0xc                                 # 0043ef3e
    mov dword ptr [ebp - local_c], ecx           # 0043ef41
    mov eax, dword ptr [ebp + arg_8]             # 0043ef44
    mov dword ptr [ebp - local_4], eax           # 0043ef47
    mov dword ptr [ebp - local_8], 0x0           # 0043ef4a
    jmp.d8 L_0043ef5c                            # 0043ef51
L_0043ef53:
    # block 0x0043ef53: entered by jmp at 0x0043ef6f, 3 instruction(s), falls into the block at 0x0043ef5c
    mov ecx, dword ptr [ebp - local_8]           # 0043ef53
    add ecx, 0x1                                 # 0043ef56
    mov dword ptr [ebp - local_8], ecx           # 0043ef59
L_0043ef5c:
    # block 0x0043ef5c: entered by jmp at 0x0043ef51, 3 instruction(s), ends with jge to 0x0043ef71 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0043ef5c
    cmp edx, dword ptr [ebp + arg_10]            # 0043ef5f
    jge.d8 L_0043ef71                            # 0043ef62
    # block 0x0043ef64: entered by fall-through of jge at 0x0043ef62, 5 instruction(s), ends with backward jump to 0x0043ef53
    mov eax, dword ptr [ebp - local_4]           # 0043ef64
    add eax, dword ptr [ebp - local_8]           # 0043ef67
    mov cl, byte ptr [ebp + arg_c]               # 0043ef6a
    mov byte ptr [eax], cl                       # 0043ef6d
    jmp.d8 L_0043ef53                            # 0043ef6f
L_0043ef71:
    # block 0x0043ef71: entered by jge at 0x0043ef62, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0043ef71
    pop ebp                                      # 0043ef73
    ret 0xc                                      # 0043ef74

