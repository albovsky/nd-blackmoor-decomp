# FUN_004eb870
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb870
# extent:       0x004eb870-0x004eb8fe (142 code bytes)
# span:         0x004eb870-0x004eb8fe (code 142, tables 0, padding 0)
# sha256:       ca1c066bb3090148a6919ee9520dec77a88a13e8f4fd97cfe61f3695fe02d591
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eb870_construct_record
# naming:       native port src/original_methods_fl39f.c:m4eb870_construct_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: 0x4eda10(this) (thiscall, 0 arguments), then 0x50cb26(this + 0xca8, 0x18f, 0x2, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them). All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eda10, FUN_0050cb26, FUN_004eb9c8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4eb870_construct_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 41 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004eb9c8, .text + (0x004eb9c8 - 0x401000)
.set FUN_004eda10, .text + (0x004eda10 - 0x401000)
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)

.org 0x004eb870 - 0x401000
.globl FUN_004eb870
FUN_004eb870:
    # block 0x004eb870: entry, 41 instruction(s), calls FUN_004eda10, FUN_0050cb26, FUN_004eb9c8, ends with ret
    push ebp                                     # 004eb870
    {load} mov ebp, esp                          # 004eb871
    push -0x1                                    # 004eb873
    push 0x528ab4                                # 004eb875
    mov eax, dword ptr fs:[0x0]                  # 004eb87a
    push eax                                     # 004eb880
    mov dword ptr fs:[0x0], esp                  # 004eb881
    push ecx                                     # 004eb888
    push edi                                     # 004eb889
    mov dword ptr [ebp - local_10], ecx          # 004eb88a
    mov ecx, dword ptr [ebp - local_10]          # 004eb88d
    call FUN_004eda10                            # 004eb890
    mov dword ptr [ebp - local_4], 0x0           # 004eb895
    push 0x4e1c83                                # 004eb89c
    push 0x4e1c50                                # 004eb8a1
    push 0x2                                     # 004eb8a6
    push 0x18f                                   # 004eb8a8
    mov eax, dword ptr [ebp - local_10]          # 004eb8ad
    add eax, 0xca8                               # 004eb8b0
    push eax                                     # 004eb8b5
    call FUN_0050cb26                            # 004eb8b6
    mov byte ptr [ebp - local_4], 0x1            # 004eb8bb
    mov ecx, dword ptr [ebp - local_10]          # 004eb8bf
    mov dword ptr [ecx], 0x52e4f8                # 004eb8c2
    mov ecx, 0x182                               # 004eb8c8
    {load} xor eax, eax                          # 004eb8cd
    mov edi, dword ptr [ebp - local_10]          # 004eb8cf
    add edi, 0x695                               # 004eb8d2
    rep stosd dword ptr es:[edi], eax            # 004eb8d8
    stosw word ptr es:[edi], ax                  # 004eb8da
    stosb byte ptr es:[edi], al                  # 004eb8dc
    mov ecx, dword ptr [ebp - local_10]          # 004eb8dd
    call FUN_004eb9c8                            # 004eb8e0
    mov dword ptr [ebp - local_4], 0xffffffff    # 004eb8e5
    mov eax, dword ptr [ebp - local_10]          # 004eb8ec
    mov ecx, dword ptr [ebp - local_c]           # 004eb8ef
    mov dword ptr fs:[0x0], ecx                  # 004eb8f2
    pop edi                                      # 004eb8f9
    {load} mov esp, ebp                          # 004eb8fa
    pop ebp                                      # 004eb8fc
    ret                                          # 004eb8fd

