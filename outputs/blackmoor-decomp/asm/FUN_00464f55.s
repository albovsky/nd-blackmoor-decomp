# FUN_00464f55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464f55
# extent:       0x00464f55-0x00464faa (85 code bytes)
# span:         0x00464f55-0x00464faa (code 85, tables 0, padding 0)
# sha256:       a93f1ebf7807d692338b8de4f73504f4c1eacc33b85a3fd122065f72e3e1c350
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m464f55_lifted
# naming:       native port src/original_methods_fl40.c:m464f55_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 28/28 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_385
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m464f55_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_385, 0x385  # offset +0x385

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00464f55 - 0x401000
.globl FUN_00464f55
FUN_00464f55:
    # block 0x00464f55: entry, 18 instruction(s), ends with je to 0x00464fa4 (forward)
    push ebp                                     # 00464f55
    {load} mov ebp, esp                          # 00464f56
    sub esp, 0x8                                 # 00464f58
    push esi                                     # 00464f5b
    push edi                                     # 00464f5c
    mov dword ptr [ebp - local_8], ecx           # 00464f5d
    mov eax, dword ptr [ebp - local_8]           # 00464f60
    movsx ecx, word ptr [eax + field_1e]         # 00464f63
    imul ecx, ecx, 0x8d                          # 00464f67
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00464f6d
    mov dword ptr [ebp - local_4], edx           # 00464f73
    mov edi, 0x54b338                            # 00464f76
    mov esi, dword ptr [ebp - local_4]           # 00464f7b
    add esi, 0x364                               # 00464f7e
    mov ecx, 0x9                                 # 00464f84
    {load} xor eax, eax                          # 00464f89
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00464f8b
    je.d8 L_00464fa4                             # 00464f8d
    # block 0x00464f8f: entered by fall-through of je at 0x00464f8d, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00464fa4
    mov ecx, dword ptr [ebp - local_4]           # 00464f8f
    mov dx, word ptr [ecx + field_385]           # 00464f92
    push edx                                     # 00464f99
    mov ecx, 0x5c3a67                            # 00464f9a
    call FUN_004fb2e3                            # 00464f9f
L_00464fa4:
    # block 0x00464fa4: entered by je at 0x00464f8d, 5 instruction(s), ends with ret
    pop edi                                      # 00464fa4
    pop esi                                      # 00464fa5
    {load} mov esp, ebp                          # 00464fa6
    pop ebp                                      # 00464fa8
    ret                                          # 00464fa9

