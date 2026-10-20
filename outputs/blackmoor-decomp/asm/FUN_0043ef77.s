# FUN_0043ef77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ef77
# extent:       0x0043ef77-0x0043efb6 (63 code bytes)
# span:         0x0043ef77-0x0043efb6 (code 63, tables 0, padding 0)
# sha256:       f613794d82ed413a0bbc3e7a7db12730bc9c721d3c7d973958c407560eb6b58e
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fill16
# naming:       native port src/avf_decoder.c:fill16 (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Extracted from run_commands (no behaviour change): count signed 16-bit word stores, nothing for count <= 0. No oracle executes it whole (game data).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/avf_decoder.c:convert_span (function ledger class native_tests_only; also fill16, run_commands; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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

.org 0x0043ef77 - 0x401000
.globl FUN_0043ef77
FUN_0043ef77:
    # block 0x0043ef77: entry, 8 instruction(s), ends with forward jump to 0x0043ef98
    push ebp                                     # 0043ef77
    {load} mov ebp, esp                          # 0043ef78
    sub esp, 0xc                                 # 0043ef7a
    mov dword ptr [ebp - local_c], ecx           # 0043ef7d
    mov eax, dword ptr [ebp + arg_8]             # 0043ef80
    mov dword ptr [ebp - local_4], eax           # 0043ef83
    mov dword ptr [ebp - local_8], 0x0           # 0043ef86
    jmp.d8 L_0043ef98                            # 0043ef8d
L_0043ef8f:
    # block 0x0043ef8f: entered by jmp at 0x0043efae, 3 instruction(s), falls into the block at 0x0043ef98
    mov ecx, dword ptr [ebp - local_8]           # 0043ef8f
    add ecx, 0x1                                 # 0043ef92
    mov dword ptr [ebp - local_8], ecx           # 0043ef95
L_0043ef98:
    # block 0x0043ef98: entered by jmp at 0x0043ef8d, 3 instruction(s), ends with jge to 0x0043efb0 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0043ef98
    cmp edx, dword ptr [ebp + arg_10]            # 0043ef9b
    jge.d8 L_0043efb0                            # 0043ef9e
    # block 0x0043efa0: entered by fall-through of jge at 0x0043ef9e, 5 instruction(s), ends with backward jump to 0x0043ef8f
    mov eax, dword ptr [ebp - local_8]           # 0043efa0
    mov ecx, dword ptr [ebp - local_4]           # 0043efa3
    mov dx, word ptr [ebp + arg_c]               # 0043efa6
    mov word ptr [ecx + 2*eax], dx               # 0043efaa
    jmp.d8 L_0043ef8f                            # 0043efae
L_0043efb0:
    # block 0x0043efb0: entered by jge at 0x0043ef9e, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0043efb0
    pop ebp                                      # 0043efb2
    ret 0xc                                      # 0043efb3

