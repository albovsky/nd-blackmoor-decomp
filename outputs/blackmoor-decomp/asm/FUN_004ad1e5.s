# FUN_004ad1e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ad1e5
# extent:       0x004ad1e5-0x004ad310 (299 code bytes)
# span:         0x004ad1e5-0x004ad310 (code 299, tables 0, padding 0)
# sha256:       aac5bafe5c9c1bd765db11212ca1110c9bcee4f83079d061bb3396b715c162dc
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ad1e5_lifted
# naming:       native port src/original_methods_fl39d.c:m4ad1e5_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (52 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ad1e5_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004ad1e5 - 0x401000
.globl FUN_004ad1e5
FUN_004ad1e5:
    # block 0x004ad1e5: entry, 7 instruction(s), ends with jne to 0x004ad24e (forward)
    push ebp                                     # 004ad1e5
    {load} mov ebp, esp                          # 004ad1e6
    push ecx                                     # 004ad1e8
    mov dword ptr [ebp - local_4], ecx           # 004ad1e9
    movsx eax, word ptr [ebp + arg_8]            # 004ad1ec
    cmp eax, 0x2775                              # 004ad1f0
    jne.d8 L_004ad24e                            # 004ad1f5
    # block 0x004ad1f7: entered by fall-through of jne at 0x004ad1f5, 13 instruction(s), ends with forward jump to 0x004ad30a
    mov ecx, dword ptr [0x5d0377]                # 004ad1f7
    mov dword ptr [0x5d162d], ecx                # 004ad1fd
    mov dword ptr [0x5b44f0], 0x9                # 004ad203
    mov dword ptr [0x5b44f4], 0x1                # 004ad20d
    mov edx, dword ptr [0x5b44f0]                # 004ad217
    shl edx, 0x5                                 # 004ad21d
    mov eax, dword ptr [0x5b44f4]                # 004ad220
    shl eax, 0x4                                 # 004ad225
    lea ecx, [edx + eax + 0x5b160c]              # 004ad228
    mov dword ptr [0x5d1631], ecx                # 004ad22f
    mov dword ptr [0x5d1639], 0x1                # 004ad235
    mov dword ptr [0x5c39e5], 0x2775             # 004ad23f
    jmp.d32 L_004ad30a                           # 004ad249
L_004ad24e:
    # block 0x004ad24e: entered by jne at 0x004ad1f5, 3 instruction(s), ends with jne to 0x004ad2ac (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004ad24e
    cmp edx, 0x2774                              # 004ad252
    jne.d8 L_004ad2ac                            # 004ad258
    # block 0x004ad25a: entered by fall-through of jne at 0x004ad258, 13 instruction(s), ends with forward jump to 0x004ad30a
    mov dword ptr [0x5b44f0], 0x12               # 004ad25a
    mov dword ptr [0x5b44f4], 0x1                # 004ad264
    mov eax, dword ptr [0x5d0377]                # 004ad26e
    mov dword ptr [0x5d162d], eax                # 004ad273
    mov ecx, dword ptr [0x5b44f0]                # 004ad278
    shl ecx, 0x5                                 # 004ad27e
    mov edx, dword ptr [0x5b44f4]                # 004ad281
    shl edx, 0x4                                 # 004ad287
    lea eax, [ecx + edx + 0x5b160c]              # 004ad28a
    mov dword ptr [0x5d1631], eax                # 004ad291
    mov dword ptr [0x5d1639], 0x1                # 004ad296
    mov dword ptr [0x5c39e5], 0x2774             # 004ad2a0
    jmp.d8 L_004ad30a                            # 004ad2aa
L_004ad2ac:
    # block 0x004ad2ac: entered by jne at 0x004ad258, 3 instruction(s), ends with jne to 0x004ad30a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ad2ac
    cmp ecx, 0x2776                              # 004ad2b0
    jne.d8 L_004ad30a                            # 004ad2b6
    # block 0x004ad2b8: entered by fall-through of jne at 0x004ad2b6, 12 instruction(s), falls into the block at 0x004ad30a
    mov dword ptr [0x5b44f0], 0x12               # 004ad2b8
    mov dword ptr [0x5b44f4], 0x0                # 004ad2c2
    mov edx, dword ptr [0x5d0377]                # 004ad2cc
    mov dword ptr [0x5d162d], edx                # 004ad2d2
    mov eax, dword ptr [0x5b44f0]                # 004ad2d8
    shl eax, 0x5                                 # 004ad2dd
    mov ecx, dword ptr [0x5b44f4]                # 004ad2e0
    shl ecx, 0x4                                 # 004ad2e6
    lea edx, [eax + ecx + 0x5b160c]              # 004ad2e9
    mov dword ptr [0x5d1631], edx                # 004ad2f0
    mov dword ptr [0x5d1639], 0x1                # 004ad2f6
    mov dword ptr [0x5c39e5], 0x2776             # 004ad300
L_004ad30a:
    # block 0x004ad30a: entered by jmp at 0x004ad249; jmp at 0x004ad2aa; jne at 0x004ad2b6, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ad30a
    pop ebp                                      # 004ad30c
    ret 0x4                                      # 004ad30d

