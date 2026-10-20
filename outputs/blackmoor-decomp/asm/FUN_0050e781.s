# FUN_0050e781
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e781
# extent:       0x0050e781-0x0050e7e5 (100 code bytes)
# span:         0x0050e781-0x0050e7e5 (code 100, tables 0, padding 0)
# sha256:       7d33fc71841746c27cb12b7f740714bbdace7458243e19dc2c49bc38b64dda73
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         ___timet_from_ft
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       7 ebp-relative slot(s): local_8, local_c, local_e, local_10, local_12, local_16, local_18
# fields:       [eax + n] field_4
# callees:      calls KERNEL32.dll!FileTimeToLocalFileTime, KERNEL32.dll!FileTimeToSystemTime, FUN_00513174
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_e, 0xe  # offset -0xe
.equ local_10, 0x10  # offset -0x10
.equ local_12, 0x12  # offset -0x12
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00513174, .text + (0x00513174 - 0x401000)

.org 0x0050e781 - 0x401000
.globl FUN_0050e781
FUN_0050e781:
    # block 0x0050e781: entry, 6 instruction(s), ends with jne to 0x0050e795 (forward)
    push ebp                                     # 0050e781
    {load} mov ebp, esp                          # 0050e782
    sub esp, 0x18                                # 0050e784
    mov eax, dword ptr [ebp + arg_8]             # 0050e787
    cmp dword ptr [eax], 0x0                     # 0050e78a
    jne.d8 L_0050e795                            # 0050e78d
    # block 0x0050e78f: entered by fall-through of jne at 0x0050e78d, 2 instruction(s), ends with je to 0x0050e7e0 (forward)
    cmp dword ptr [eax + field_4], 0x0           # 0050e78f
    je.d8 L_0050e7e0                             # 0050e793
L_0050e795:
    # block 0x0050e795: entered by jne at 0x0050e78d; fall-through of je at 0x0050e793, 6 instruction(s), calls KERNEL32.dll!FileTimeToLocalFileTime, ends with je to 0x0050e7e0 (forward)
    lea ecx, [ebp - local_8]                     # 0050e795
    push ecx                                     # 0050e798
    push eax                                     # 0050e799
    call dword ptr [0x52a25c]                    # 0050e79a
    test eax, eax                                # 0050e7a0
    je.d8 L_0050e7e0                             # 0050e7a2
    # block 0x0050e7a4: entered by fall-through of je at 0x0050e7a2, 7 instruction(s), calls KERNEL32.dll!FileTimeToSystemTime, ends with je to 0x0050e7e0 (forward)
    lea eax, [ebp - local_18]                    # 0050e7a4
    push eax                                     # 0050e7a7
    lea eax, [ebp - local_8]                     # 0050e7a8
    push eax                                     # 0050e7ab
    call dword ptr [0x52a128]                    # 0050e7ac
    test eax, eax                                # 0050e7b2
    je.d8 L_0050e7e0                             # 0050e7b4
    # block 0x0050e7b6: entered by fall-through of je at 0x0050e7b4, 17 instruction(s), calls FUN_00513174, ends with ret
    movzx eax, word ptr [ebp - local_c]          # 0050e7b6
    push -0x1                                    # 0050e7ba
    push eax                                     # 0050e7bc
    movzx eax, word ptr [ebp - local_e]          # 0050e7bd
    push eax                                     # 0050e7c1
    movzx eax, word ptr [ebp - local_10]         # 0050e7c2
    push eax                                     # 0050e7c6
    movzx eax, word ptr [ebp - local_12]         # 0050e7c7
    push eax                                     # 0050e7cb
    movzx eax, word ptr [ebp - local_16]         # 0050e7cc
    push eax                                     # 0050e7d0
    movzx eax, word ptr [ebp - local_18]         # 0050e7d1
    push eax                                     # 0050e7d5
    call FUN_00513174                            # 0050e7d6
    add esp, 0x1c                                # 0050e7db
    leave                                        # 0050e7de
    ret                                          # 0050e7df
L_0050e7e0:
    # block 0x0050e7e0: entered by je at 0x0050e793; je at 0x0050e7a2; je at 0x0050e7b4, 3 instruction(s), ends with ret
    or eax, -0x1                                 # 0050e7e0
    leave                                        # 0050e7e3
    ret                                          # 0050e7e4

