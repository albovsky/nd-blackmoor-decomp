# FUN_0051d730
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d730
# extent:       0x0051d730-0x0051d75b (43 code bytes)
# span:         0x0051d730-0x0051d75b (code 43, tables 0, padding 0)
# sha256:       3dee1fde211fdde2644d47004d4536c7414cf5120804911e89e432acfddea119
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d730
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_10
# callees:      calls FUN_0050f978; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)

.org 0x0051d730 - 0x401000
.globl FUN_0051d730
FUN_0051d730:
    # block 0x0051d730: entry, 9 instruction(s), calls FUN_0050f978, ends with je to 0x0051d74f (forward)
    mov eax, 0x528c3c                            # 0051d730
    call FUN_0050f978                            # 0051d735
    push ecx                                     # 0051d73a
    mov dword ptr [ebp - field_minus_10], ecx    # 0051d73b
    mov eax, dword ptr [ecx + field_10]          # 0051d73e
    and dword ptr [ebp - field_minus_4], 0x0     # 0051d741
    add ecx, 0x10                                # 0051d745
    test eax, eax                                # 0051d748
    je.d8 L_0051d74f                             # 0051d74a
    # block 0x0051d74c: entered by fall-through of je at 0x0051d74a, 1 instruction(s), calls indirect dword ptr [eax + 0x1c], falls into the block at 0x0051d74f
    call dword ptr [eax + field_1c]              # 0051d74c
L_0051d74f:
    # block 0x0051d74f: entered by je at 0x0051d74a, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051d74f
    mov dword ptr fs:[0x0], ecx                  # 0051d752
    leave                                        # 0051d759
    ret                                          # 0051d75a

