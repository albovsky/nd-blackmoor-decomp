# FUN_0051e95c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e95c
# extent:       0x0051e95c-0x0051e9c2 (102 code bytes)
# span:         0x0051e95c-0x0051e9c2 (code 102, tables 0, padding 0)
# sha256:       dd74766ab9cae38df82f7303a4ec969fbe1d56eb6e92f821eb8f55bf8a5347a4
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e95c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_c, field_minus_10, field_minus_14; [ecx + n] field_minus_8
# callees:      calls FUN_0050f978, FUN_0051e91e, FUN_0051e52f, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e91e, .text + (0x0051e91e - 0x401000)

.org 0x0051e95c - 0x401000
.globl FUN_0051e95c
FUN_0051e95c:
    # block 0x0051e95c: entry, 35 instruction(s), calls FUN_0050f978, FUN_0051e91e, FUN_0051e52f, FUN_0051e7ba, ends with ret 0xc
    mov eax, 0x528d8b                            # 0051e95c
    call FUN_0050f978                            # 0051e961
    push ecx                                     # 0051e966
    push ecx                                     # 0051e967
    mov eax, dword ptr [0x5679b0]                # 0051e968
    and dword ptr [ebp - field_minus_14], 0x0    # 0051e96d
    push esi                                     # 0051e971
    mov dword ptr [ebp - field_minus_10], eax    # 0051e972
    mov eax, dword ptr [ebp + field_10]          # 0051e975
    mov ecx, dword ptr [ebp + field_c]           # 0051e978
    push 0x1                                     # 0051e97b
    mov eax, dword ptr [eax]                     # 0051e97d
    mov ecx, dword ptr [ecx]                     # 0051e97f
    pop esi                                      # 0051e981
    push eax                                     # 0051e982
    mov dword ptr [ebp - field_minus_4], esi     # 0051e983
    push dword ptr [eax - field_minus_8]         # 0051e986
    push ecx                                     # 0051e989
    push dword ptr [ecx - field_minus_8]         # 0051e98a
    lea ecx, [ebp - field_minus_10]              # 0051e98d
    call FUN_0051e91e                            # 0051e990
    mov ecx, dword ptr [ebp + field_8]           # 0051e995
    lea eax, [ebp - field_minus_10]              # 0051e998
    push eax                                     # 0051e99b
    call FUN_0051e52f                            # 0051e99c
    mov dword ptr [ebp - field_minus_14], esi    # 0051e9a1
    and byte ptr [ebp - field_minus_4], 0x0      # 0051e9a4
    lea ecx, [ebp - field_minus_10]              # 0051e9a8
    call FUN_0051e7ba                            # 0051e9ab
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051e9b0
    mov eax, dword ptr [ebp + field_8]           # 0051e9b3
    pop esi                                      # 0051e9b6
    mov dword ptr fs:[0x0], ecx                  # 0051e9b7
    leave                                        # 0051e9be
    ret 0xc                                      # 0051e9bf

