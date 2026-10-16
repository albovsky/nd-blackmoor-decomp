# FUN_004e7757
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7757
# extent:       0x004e7757-0x004e7786 (47 code bytes)
# span:         0x004e7757-0x004e7786 (code 47, tables 0, padding 0)
# sha256:       a2a7de12d05c8665b260e2a7bb99bfb87320cdbe17bd76fc42bfccede9395a52
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7757
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991
# callees:      calls FUN_004e76ed, FUN_004d36ed
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase2 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e76ed, .text + (0x004e76ed - 0x401000)

.org 0x004e7757 - 0x401000
.globl FUN_004e7757
FUN_004e7757:
    # block 0x004e7757: entry, 13 instruction(s), calls FUN_004e76ed, FUN_004d36ed, ends with ret
    push ebp                                     # 004e7757
    {load} mov ebp, esp                          # 004e7758
    push ecx                                     # 004e775a
    mov dword ptr [ebp - local_4], ecx           # 004e775b
    mov eax, dword ptr [ebp - local_4]           # 004e775e
    mov dword ptr [eax + field_991], 0x1         # 004e7761
    mov ecx, dword ptr [ebp - local_4]           # 004e776b
    call FUN_004e76ed                            # 004e776e
    call FUN_004d36ed                            # 004e7773
    mov dword ptr [0x583204], 0x0                # 004e7778
    {load} mov esp, ebp                          # 004e7782
    pop ebp                                      # 004e7784
    ret                                          # 004e7785

