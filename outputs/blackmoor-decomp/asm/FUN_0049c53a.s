# FUN_0049c53a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c53a
# extent:       0x0049c53a-0x0049c59f (101 code bytes)
# span:         0x0049c53a-0x0049c59f (code 101, tables 0, padding 0)
# sha256:       a85cee52774bd1b3239407fd9e24414eb90946560a4e77be1ae6c58df1accffc
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c53a_construct_record
# naming:       native port src/original_methods_fl39f.c:m49c53a_construct_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52dbc8, then zero 0xdb0 bytes at [this+0x28] (rep stosd). All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0049c5f0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m49c53a_construct_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0049c5f0, .text + (0x0049c5f0 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0049c53a - 0x401000
.globl FUN_0049c53a
FUN_0049c53a:
    # block 0x0049c53a: entry, 30 instruction(s), calls FUN_0051d716, FUN_0049c5f0, ends with ret
    push ebp                                     # 0049c53a
    {load} mov ebp, esp                          # 0049c53b
    push -0x1                                    # 0049c53d
    push 0x52855d                                # 0049c53f
    mov eax, dword ptr fs:[0x0]                  # 0049c544
    push eax                                     # 0049c54a
    mov dword ptr fs:[0x0], esp                  # 0049c54b
    push ecx                                     # 0049c552
    push edi                                     # 0049c553
    mov dword ptr [ebp - local_10], ecx          # 0049c554
    mov ecx, dword ptr [ebp - local_10]          # 0049c557
    call FUN_0051d716                            # 0049c55a
    mov dword ptr [ebp - local_4], 0x0           # 0049c55f
    mov eax, dword ptr [ebp - local_10]          # 0049c566
    mov dword ptr [eax], 0x52dbc8                # 0049c569
    mov ecx, 0x36c                               # 0049c56f
    {load} xor eax, eax                          # 0049c574
    mov edi, dword ptr [ebp - local_10]          # 0049c576
    add edi, 0x28                                # 0049c579
    rep stosd dword ptr es:[edi], eax            # 0049c57c
    mov ecx, dword ptr [ebp - local_10]          # 0049c57e
    call FUN_0049c5f0                            # 0049c581
    mov dword ptr [ebp - local_4], 0xffffffff    # 0049c586
    mov eax, dword ptr [ebp - local_10]          # 0049c58d
    mov ecx, dword ptr [ebp - local_c]           # 0049c590
    mov dword ptr fs:[0x0], ecx                  # 0049c593
    pop edi                                      # 0049c59a
    {load} mov esp, ebp                          # 0049c59b
    pop ebp                                      # 0049c59d
    ret                                          # 0049c59e

