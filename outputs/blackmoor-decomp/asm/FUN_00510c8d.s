# FUN_00510c8d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510c8d
# extent:       0x00510c8d-0x00510ce3 (86 code bytes)
# span:         0x00510c8d-0x00510ce3 (code 86, tables 0, padding 0)
# sha256:       c0dbd55e94350bc443ff432341e30ee59e87c08572960e0dbf53ed8f5ce68326
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510c8d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_10, local_18
# fields:       [eax + n] field_18, field_1c; [ecx + n] field_4
# callees:      calls FUN_0050c669
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510ce3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c669, .text + (0x0050c669 - 0x401000)

.org 0x00510c8d - 0x401000
.globl FUN_00510c8d
FUN_00510c8d:
    # block 0x00510c8d: entry, 17 instruction(s), ends with je to 0x00510cd4 (forward)
    push ebp                                     # 00510c8d
    {load} mov ebp, esp                          # 00510c8e
    push -0x1                                    # 00510c90
    push 0x5303f8                                # 00510c92
    push 0x511930                                # 00510c97
    mov eax, dword ptr fs:[0x0]                  # 00510c9c
    push eax                                     # 00510ca2
    mov dword ptr fs:[0x0], esp                  # 00510ca3
    push ecx                                     # 00510caa
    push ecx                                     # 00510cab
    push ebx                                     # 00510cac
    push esi                                     # 00510cad
    push edi                                     # 00510cae
    mov dword ptr [ebp - local_18], esp          # 00510caf
    mov eax, dword ptr [ebp + arg_8]             # 00510cb2
    test eax, eax                                # 00510cb5
    je.d8 L_00510cd4                             # 00510cb7
    # block 0x00510cb9: entered by fall-through of je at 0x00510cb7, 4 instruction(s), ends with je to 0x00510cd4 (forward)
    mov ecx, dword ptr [eax + field_1c]          # 00510cb9
    mov ecx, dword ptr [ecx + field_4]           # 00510cbc
    test ecx, ecx                                # 00510cbf
    je.d8 L_00510cd4                             # 00510cc1
    # block 0x00510cc3: entered by fall-through of je at 0x00510cc1, 5 instruction(s), calls FUN_0050c669, falls into the block at 0x00510cd4
    and dword ptr [ebp - local_4], 0x0           # 00510cc3
    push ecx                                     # 00510cc7
    push dword ptr [eax + field_18]              # 00510cc8
    call FUN_0050c669                            # 00510ccb
    or dword ptr [ebp - local_4], -0x1           # 00510cd0
L_00510cd4:
    # block 0x00510cd4: entered by je at 0x00510cb7; je at 0x00510cc1, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_10]          # 00510cd4
    mov dword ptr fs:[0x0], ecx                  # 00510cd7
    pop edi                                      # 00510cde
    pop esi                                      # 00510cdf
    pop ebx                                      # 00510ce0
    leave                                        # 00510ce1
    ret                                          # 00510ce2

