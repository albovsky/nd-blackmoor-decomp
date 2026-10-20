# FUN_00525c1c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525c1c
# extent:       0x00525c1c-0x00525c51 (53 code bytes)
# span:         0x00525c1c-0x00525c51 (code 53, tables 0, padding 0)
# sha256:       5b6ef4b7f3560105ba50a8b56e531b40b5581e027bb75dae2cfb1fec2b59715d
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@00525c1c
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# name-note:    Catch@ handler of a library parent: Unlocks global critical section FUN_0052606a(0x10) and rethrows; tail is spilled delete-object code of another fn. Parent (locked lazy init) just propagates
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4
# callees:      calls FUN_0052606a, FUN_0050f997; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x00525c1c - 0x401000
.globl FUN_00525c1c
FUN_00525c1c:
    # block 0x00525c1c: entry, 11 instruction(s), calls FUN_0052606a, FUN_0050f997, ends with je to 0x00525c4f (forward)
    push 0x10                                    # 00525c1c
    call FUN_0052606a                            # 00525c1e
    {load} xor edi, edi                          # 00525c23
    push edi                                     # 00525c25
    push edi                                     # 00525c26
    call FUN_0050f997                            # 00525c27
    push ebp                                     # 00525c2c
    {load} mov ebp, esp                          # 00525c2d
    push ecx                                     # 00525c2f
    cmp dword ptr [ecx], 0x0                     # 00525c30
    je.d8 L_00525c4f                             # 00525c33
    # block 0x00525c35: entered by fall-through of je at 0x00525c33, 6 instruction(s), ends with je to 0x00525c4f (forward)
    mov eax, dword ptr [ecx]                     # 00525c35
    mov dword ptr [ebp - field_minus_4], eax     # 00525c37
    mov eax, dword ptr [ebp - field_minus_4]     # 00525c3a
    mov dword ptr [ebp - field_minus_4], eax     # 00525c3d
    cmp dword ptr [ebp - field_minus_4], 0x0     # 00525c40
    je.d8 L_00525c4f                             # 00525c44
    # block 0x00525c46: entered by fall-through of je at 0x00525c44, 4 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x00525c4f
    mov ecx, dword ptr [ebp - field_minus_4]     # 00525c46
    mov eax, dword ptr [ecx]                     # 00525c49
    push 0x1                                     # 00525c4b
    call dword ptr [eax]                         # 00525c4d
L_00525c4f:
    # block 0x00525c4f: entered by je at 0x00525c33; je at 0x00525c44, 2 instruction(s), ends with ret
    leave                                        # 00525c4f
    ret                                          # 00525c50

