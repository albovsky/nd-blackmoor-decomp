# FUN_00520b14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b14
# extent:       0x00520b14-0x00520b4a (54 code bytes)
# span:         0x00520b14-0x00520b4a (code 54, tables 0, padding 0)
# sha256:       7fdcecdde92211fd3021417a2df34016f1be9f79227a7448dcedb852c3e5bbc7
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b14
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_4
# callees:      calls FUN_0050f978, FUN_00520ae3, GDI32.dll!DeleteDC
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00520b4a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00520ae3, .text + (0x00520ae3 - 0x401000)

.org 0x00520b14 - 0x401000
.globl FUN_00520b14
FUN_00520b14:
    # block 0x00520b14: entry, 8 instruction(s), calls FUN_0050f978, ends with je to 0x00520b3e (forward)
    mov eax, 0x529024                            # 00520b14
    call FUN_0050f978                            # 00520b19
    push ecx                                     # 00520b1e
    mov dword ptr [ebp - field_minus_10], ecx    # 00520b1f
    mov dword ptr [ecx], 0x52fc80                # 00520b22
    and dword ptr [ebp - field_minus_4], 0x0     # 00520b28
    cmp dword ptr [ecx + field_4], 0x0           # 00520b2c
    je.d8 L_00520b3e                             # 00520b30
    # block 0x00520b32: entered by fall-through of je at 0x00520b30, 3 instruction(s), calls FUN_00520ae3, GDI32.dll!DeleteDC, falls into the block at 0x00520b3e
    call FUN_00520ae3                            # 00520b32
    push eax                                     # 00520b37
    call dword ptr [0x52a064]                    # 00520b38
L_00520b3e:
    # block 0x00520b3e: entered by je at 0x00520b30, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00520b3e
    mov dword ptr fs:[0x0], ecx                  # 00520b41
    leave                                        # 00520b48
    ret                                          # 00520b49

