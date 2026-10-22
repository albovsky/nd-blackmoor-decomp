# FUN_00402322
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402322
# extent:       0x00402322-0x0040236a (72 code bytes)
# span:         0x00402322-0x0040236a (code 72, tables 0, padding 0)
# sha256:       9462fbb6239b886bd30bd24e0f45b3418c4912a44555481bc9d9583a37168734
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402322_lifted
# naming:       native port src/original_methods_fl40.c:m402322_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 23/23 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1a
# callees:      calls FUN_0050ca3e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m402322_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1a, 0x1a  # offset +0x1a

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00402322 - 0x401000
.globl FUN_00402322
FUN_00402322:
    # block 0x00402322: entry, 23 instruction(s), calls FUN_0050ca3e, ends with ret 0xc
    push ebp                                     # 00402322
    {load} mov ebp, esp                          # 00402323
    push ecx                                     # 00402325
    mov dword ptr [ebp - local_4], ecx           # 00402326
    movsx eax, word ptr [ebp + arg_8]            # 00402329
    imul eax, eax, 0x18                          # 0040232d
    mov ecx, dword ptr [4*eax + 0x5374d0]        # 00402330
    push ecx                                     # 00402337
    push 0x53e8c8                                # 00402338
    mov edx, dword ptr [ebp + arg_c]             # 0040233d
    push edx                                     # 00402340
    call FUN_0050ca3e                            # 00402341
    add esp, 0xc                                 # 00402346
    mov eax, dword ptr [ebp + arg_c]             # 00402349
    mov byte ptr [eax + field_1a], 0x0           # 0040234c
    movsx ecx, word ptr [ebp + arg_8]            # 00402350
    imul ecx, ecx, 0x14                          # 00402354
    mov edx, dword ptr [ebp + arg_10]            # 00402357
    mov ax, word ptr [ecx + 0x5370f8]            # 0040235a
    mov word ptr [edx], ax                       # 00402361
    {load} mov esp, ebp                          # 00402364
    pop ebp                                      # 00402366
    ret 0xc                                      # 00402367

