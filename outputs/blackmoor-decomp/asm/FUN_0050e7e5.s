# FUN_0050e7e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e7e5
# extent:       0x0050e7e5-0x0050e8e2 (253 code bytes)
# span:         0x0050e7e5-0x0050e8e2 (code 253, tables 0, padding 0)
# sha256:       9aef39583c6912f05be724e1d6cd3aef1ac803cfa117baf8a4ec822878a5b9e2
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         entry
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (crt_startup_termination, function-ledger-overrides.json not_needed_entries)
# name-note:    entry: GetVersion, heap/io/cmdline/env init, _cinit, GetStartupInfo, calls WinMain wrapper, exit; no callers, not game reached
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       9 ebp-relative slot(s): local_4, local_14, local_18, local_2c, local_30, local_5c, local_60, local_64, local_68
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetVersion, FUN_00514d5d, FUN_0050e912, FUN_00510d6c, FUN_00512d28, KERNEL32.dll!GetCommandLineA, FUN_00514c2b, FUN_005149de, FUN_00514925, FUN_0050d7b6, KERNEL32.dll!GetStartupInfoA, FUN_005148cd, KERNEL32.dll!GetModuleHandleA, FUN_00519a60, FUN_0050d7e3, FUN_00514755
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 81 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0050e8e2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68

# --- external targets -----------------------------------------------
.set FUN_0050d7b6, .text + (0x0050d7b6 - 0x401000)
.set FUN_0050d7e3, .text + (0x0050d7e3 - 0x401000)
.set FUN_0050e912, .text + (0x0050e912 - 0x401000)
.set FUN_00510d6c, .text + (0x00510d6c - 0x401000)
.set FUN_00512d28, .text + (0x00512d28 - 0x401000)
.set FUN_00514755, .text + (0x00514755 - 0x401000)
.set FUN_005148cd, .text + (0x005148cd - 0x401000)
.set FUN_00514925, .text + (0x00514925 - 0x401000)
.set FUN_005149de, .text + (0x005149de - 0x401000)
.set FUN_00514c2b, .text + (0x00514c2b - 0x401000)
.set FUN_00514d5d, .text + (0x00514d5d - 0x401000)
.set FUN_00519a60, .text + (0x00519a60 - 0x401000)

.org 0x0050e7e5 - 0x401000
.globl FUN_0050e7e5
FUN_0050e7e5:
    # block 0x0050e7e5: entry, 30 instruction(s), calls KERNEL32.dll!GetVersion, FUN_00514d5d, ends with jne to 0x0050e850 (forward)
    push ebp                                     # 0050e7e5
    {load} mov ebp, esp                          # 0050e7e6
    push -0x1                                    # 0050e7e8
    push 0x530258                                # 0050e7ea
    push 0x511930                                # 0050e7ef
    mov eax, dword ptr fs:[0x0]                  # 0050e7f4
    push eax                                     # 0050e7fa
    mov dword ptr fs:[0x0], esp                  # 0050e7fb
    sub esp, 0x58                                # 0050e802
    push ebx                                     # 0050e805
    push esi                                     # 0050e806
    push edi                                     # 0050e807
    mov dword ptr [ebp - local_18], esp          # 0050e808
    call dword ptr [0x52a224]                    # 0050e80b
    {load} xor edx, edx                          # 0050e811
    {load} mov dl, ah                            # 0050e813
    mov dword ptr [0x63ca1c], edx                # 0050e815
    {load} mov ecx, eax                          # 0050e81b
    and ecx, 0xff                                # 0050e81d
    mov dword ptr [0x63ca18], ecx                # 0050e823
    shl ecx, 0x8                                 # 0050e829
    {load} add ecx, edx                          # 0050e82c
    mov dword ptr [0x63ca14], ecx                # 0050e82e
    shr eax, 0x10                                # 0050e834
    mov dword ptr [0x63ca10], eax                # 0050e837
    push 0x1                                     # 0050e83c
    call FUN_00514d5d                            # 0050e83e
    pop ecx                                      # 0050e843
    test eax, eax                                # 0050e844
    jne.d8 L_0050e850                            # 0050e846
    # block 0x0050e848: entered by fall-through of jne at 0x0050e846, 3 instruction(s), calls FUN_0050e912, falls into the block at 0x0050e850
    push 0x1c                                    # 0050e848
    call FUN_0050e912                            # 0050e84a
    pop ecx                                      # 0050e84f
L_0050e850:
    # block 0x0050e850: entered by jne at 0x0050e846, 3 instruction(s), calls FUN_00510d6c, ends with jne to 0x0050e861 (forward)
    call FUN_00510d6c                            # 0050e850
    test eax, eax                                # 0050e855
    jne.d8 L_0050e861                            # 0050e857
    # block 0x0050e859: entered by fall-through of jne at 0x0050e857, 3 instruction(s), calls FUN_0050e912, falls into the block at 0x0050e861
    push 0x10                                    # 0050e859
    call FUN_0050e912                            # 0050e85b
    pop ecx                                      # 0050e860
L_0050e861:
    # block 0x0050e861: entered by jne at 0x0050e857, 18 instruction(s), calls FUN_00512d28, KERNEL32.dll!GetCommandLineA, FUN_00514c2b, FUN_005149de, FUN_00514925, FUN_0050d7b..., ends with je to 0x0050e8b0 (forward)
    {load} xor esi, esi                          # 0050e861
    mov dword ptr [ebp - local_4], esi           # 0050e863
    call FUN_00512d28                            # 0050e866
    call dword ptr [0x52a148]                    # 0050e86b
    mov dword ptr [0x63e128], eax                # 0050e871
    call FUN_00514c2b                            # 0050e876
    mov dword ptr [0x63ca68], eax                # 0050e87b
    call FUN_005149de                            # 0050e880
    call FUN_00514925                            # 0050e885
    call FUN_0050d7b6                            # 0050e88a
    mov dword ptr [ebp - local_30], esi          # 0050e88f
    lea eax, [ebp - local_5c]                    # 0050e892
    push eax                                     # 0050e895
    call dword ptr [0x52a144]                    # 0050e896
    call FUN_005148cd                            # 0050e89c
    mov dword ptr [ebp - local_64], eax          # 0050e8a1
    test byte ptr [ebp - local_30], 0x1          # 0050e8a4
    je.d8 L_0050e8b0                             # 0050e8a8
    # block 0x0050e8aa: entered by fall-through of je at 0x0050e8a8, 2 instruction(s), ends with forward jump to 0x0050e8b3
    movzx eax, word ptr [ebp - local_2c]         # 0050e8aa
    jmp.d8 L_0050e8b3                            # 0050e8ae
L_0050e8b0:
    # block 0x0050e8b0: entered by je at 0x0050e8a8, 2 instruction(s), falls into the block at 0x0050e8b3
    push 0xa                                     # 0050e8b0
    pop eax                                      # 0050e8b2
L_0050e8b3:
    # block 0x0050e8b3: entered by jmp at 0x0050e8ae, 20 instruction(s), calls KERNEL32.dll!GetModuleHandleA, FUN_00519a60, FUN_0050d7e3, FUN_00514755, ends with ret
    push eax                                     # 0050e8b3
    push dword ptr [ebp - local_64]              # 0050e8b4
    push esi                                     # 0050e8b7
    push esi                                     # 0050e8b8
    call dword ptr [0x52a248]                    # 0050e8b9
    push eax                                     # 0050e8bf
    call FUN_00519a60                            # 0050e8c0
    mov dword ptr [ebp - local_60], eax          # 0050e8c5
    push eax                                     # 0050e8c8
    call FUN_0050d7e3                            # 0050e8c9
    mov eax, dword ptr [ebp - local_14]          # 0050e8ce
    mov ecx, dword ptr [eax]                     # 0050e8d1
    mov ecx, dword ptr [ecx]                     # 0050e8d3
    mov dword ptr [ebp - local_68], ecx          # 0050e8d5
    push eax                                     # 0050e8d8
    push ecx                                     # 0050e8d9
    call FUN_00514755                            # 0050e8da
    pop ecx                                      # 0050e8df
    pop ecx                                      # 0050e8e0
    ret                                          # 0050e8e1

