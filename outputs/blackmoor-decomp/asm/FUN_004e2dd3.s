# FUN_004e2dd3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2dd3
# extent:       0x004e2dd3-0x004e2e05 (50 code bytes)
# span:         0x004e2dd3-0x004e2e05 (code 50, tables 0, padding 0)
# sha256:       a68dd9db5cb67059cbba903b1b8113387e5c56bc0c06caddc4a4e25721bdd748
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2dd3_lifted
# naming:       native port src/original_methods_fl39d.c:m4e2dd3_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4528; [ecx + n] field_452c; [edx + n] field_4534
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e2dd3_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4528, 0x4528  # offset +0x4528
.equ field_452c, 0x452c  # offset +0x452c
.equ field_4534, 0x4534  # offset +0x4534

# --- external targets -----------------------------------------------

.org 0x004e2dd3 - 0x401000
.globl FUN_004e2dd3
FUN_004e2dd3:
    # block 0x004e2dd3: entry, 13 instruction(s), ends with ret
    push ebp                                     # 004e2dd3
    {load} mov ebp, esp                          # 004e2dd4
    push ecx                                     # 004e2dd6
    mov dword ptr [ebp - local_4], ecx           # 004e2dd7
    mov eax, dword ptr [ebp - local_4]           # 004e2dda
    mov dword ptr [eax + field_4528], 0x0        # 004e2ddd
    mov ecx, dword ptr [ebp - local_4]           # 004e2de7
    mov dword ptr [ecx + field_452c], 0x0        # 004e2dea
    mov edx, dword ptr [ebp - local_4]           # 004e2df4
    mov dword ptr [edx + field_4534], 0x0        # 004e2df7
    {load} mov esp, ebp                          # 004e2e01
    pop ebp                                      # 004e2e03
    ret                                          # 004e2e04

