# FUN_004d51c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d51c0
# extent:       0x004d51c0-0x004d51ea (42 code bytes)
# span:         0x004d51c0-0x004d51ea (code 42, tables 0, padding 0)
# sha256:       233299a43b550c8526cc15884739c70706b08405cfb6ea9e5639efd365cbad59
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d51c0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e08b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e08b, .text + (0x0051e08b - 0x401000)

.org 0x004d51c0 - 0x401000
.globl FUN_004d51c0
FUN_004d51c0:
    # block 0x004d51c0: entry, 15 instruction(s), calls FUN_0051e08b, ends with ret 0x4
    push ebp                                     # 004d51c0
    {load} mov ebp, esp                          # 004d51c1
    push ecx                                     # 004d51c3
    mov dword ptr [ebp - local_4], ecx           # 004d51c4
    mov eax, dword ptr [ebp + arg_8]             # 004d51c7
    push eax                                     # 004d51ca
    push 0x84                                    # 004d51cb
    mov ecx, dword ptr [ebp - local_4]           # 004d51d0
    call FUN_0051e08b                            # 004d51d3
    mov ecx, dword ptr [ebp - local_4]           # 004d51d8
    mov dword ptr [ecx], 0x52e380                # 004d51db
    mov eax, dword ptr [ebp - local_4]           # 004d51e1
    {load} mov esp, ebp                          # 004d51e4
    pop ebp                                      # 004d51e6
    ret 0x4                                      # 004d51e7

