# FUN_004ea1cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ea1cb
# extent:       0x004ea1cb-0x004ea229 (94 code bytes)
# span:         0x004ea1cb-0x004ea229 (code 94, tables 0, padding 0)
# sha256:       daa7cc53b98baa1a9981a67d41fdfb75fbcc8ebc6dbfb22115e3e7aff71d8679
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ea1cb_lifted
# naming:       native port src/original_methods_fl39d.c:m4ea1cb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (18 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_699; [edx + n] field_699
# callees:      calls FUN_004c2790, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ea1cb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_699, 0x699  # offset +0x699

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)

.org 0x004ea1cb - 0x401000
.globl FUN_004ea1cb
FUN_004ea1cb:
    # block 0x004ea1cb: entry, 7 instruction(s), ends with jne to 0x004ea219 (forward)
    push ebp                                     # 004ea1cb
    {load} mov ebp, esp                          # 004ea1cc
    push ecx                                     # 004ea1ce
    mov dword ptr [ebp - local_4], ecx           # 004ea1cf
    mov eax, dword ptr [ebp - local_4]           # 004ea1d2
    cmp dword ptr [eax + field_699], 0x0         # 004ea1d5
    jne.d8 L_004ea219                            # 004ea1dc
    # block 0x004ea1de: entered by fall-through of jne at 0x004ea1dc, 12 instruction(s), calls FUN_004c2790, ends with je to 0x004ea219 (forward)
    push 0x55cab8                                # 004ea1de
    push 0x6                                     # 004ea1e3
    mov ecx, dword ptr [ebp + arg_8]             # 004ea1e5
    push ecx                                     # 004ea1e8
    push 0x55cad0                                # 004ea1e9
    mov ecx, 0x5cf659                            # 004ea1ee
    call FUN_004c2790                            # 004ea1f3
    mov edx, dword ptr [ebp - local_4]           # 004ea1f8
    mov dword ptr [edx + field_699], eax         # 004ea1fb
    movsx eax, word ptr [0x63a4cd]               # 004ea201
    test eax, eax                                # 004ea208
    je.d8 L_004ea219                             # 004ea20a
    # block 0x004ea20c: entered by fall-through of je at 0x004ea20a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ea219
    push 0x55cad8                                # 004ea20c
    call FUN_0044a2b7                            # 004ea211
    add esp, 0x4                                 # 004ea216
L_004ea219:
    # block 0x004ea219: entered by jne at 0x004ea1dc; je at 0x004ea20a, 4 instruction(s), ends with ret 0x4
    mov dword ptr [0x5d1717], 0x0                # 004ea219
    {load} mov esp, ebp                          # 004ea223
    pop ebp                                      # 004ea225
    ret 0x4                                      # 004ea226

