# FUN_004e7dad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7dad
# extent:       0x004e7dad-0x004e7e15 (104 code bytes)
# span:         0x004e7dad-0x004e7e15 (code 104, tables 0, padding 0)
# sha256:       d78d90893cd0a12dd3a7e03b63f3e2e9444db2bc061f7963cf7f57239c20a5f6
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7dad_lifted
# naming:       native port src/original_methods_fl39d.c:m4e7dad_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_112c; [edx + n] field_1120
# callees:      calls FUN_004343a2, FUN_0042639d
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e7dad_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1120, 0x1120  # offset +0x1120
.equ field_112c, 0x112c  # offset +0x112c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)

.org 0x004e7dad - 0x401000
.globl FUN_004e7dad
FUN_004e7dad:
    # block 0x004e7dad: entry, 11 instruction(s), calls FUN_004343a2, ends with jne to 0x004e7ddf (forward)
    push ebp                                     # 004e7dad
    {load} mov ebp, esp                          # 004e7dae
    push ecx                                     # 004e7db0
    push esi                                     # 004e7db1
    push edi                                     # 004e7db2
    mov dword ptr [ebp - local_4], ecx           # 004e7db3
    push 0x55c584                                # 004e7db6
    mov ecx, dword ptr [ebp + arg_8]             # 004e7dbb
    call FUN_004343a2                            # 004e7dbe
    test eax, eax                                # 004e7dc3
    jne.d8 L_004e7ddf                            # 004e7dc5
    # block 0x004e7dc7: entered by fall-through of jne at 0x004e7dc5, 6 instruction(s), calls FUN_0042639d, ends with forward jump to 0x004e7e0d
    push 0x55c588                                # 004e7dc7
    push 0x55c58c                                # 004e7dcc
    mov ecx, 0x583979                            # 004e7dd1
    call FUN_0042639d                            # 004e7dd6
    {load} xor eax, eax                          # 004e7ddb
    jmp.d8 L_004e7e0d                            # 004e7ddd
L_004e7ddf:
    # block 0x004e7ddf: entered by jne at 0x004e7dc5, 13 instruction(s), falls into the block at 0x004e7e0d
    mov eax, dword ptr [ebp + arg_8]             # 004e7ddf
    mov ecx, dword ptr [eax + field_112c]        # 004e7de2
    mov edx, dword ptr [ebp + arg_8]             # 004e7de8
    mov esi, dword ptr [edx + field_1120]        # 004e7deb
    mov edi, dword ptr [ebp - local_4]           # 004e7df1
    add edi, 0x69d                               # 004e7df4
    {load} mov eax, ecx                          # 004e7dfa
    shr ecx, 0x2                                 # 004e7dfc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e7dff
    {load} mov ecx, eax                          # 004e7e01
    and ecx, 0x3                                 # 004e7e03
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e7e06
    mov eax, 0x1                                 # 004e7e08
L_004e7e0d:
    # block 0x004e7e0d: entered by jmp at 0x004e7ddd, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004e7e0d
    pop esi                                      # 004e7e0e
    {load} mov esp, ebp                          # 004e7e0f
    pop ebp                                      # 004e7e11
    ret 0x4                                      # 004e7e12

