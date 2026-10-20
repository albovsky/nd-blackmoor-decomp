# FUN_0050cf15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cf15
# extent:       0x0050cf15-0x0050cf61 (76 code bytes)
# span:         0x0050cf15-0x0050cf61 (code 76, tables 0, padding 0)
# sha256:       97d6e480aebf501cfe22151fd82eebf814d918d46c96eca741f20af4b59cf1e5
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __fclose_lk
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10, field_1c; [esp + n] stk_8
# callees:      calls FUN_0050dcb0, FUN_00512330, FUN_00512250, FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_00512250, .text + (0x00512250 - 0x401000)
.set FUN_00512330, .text + (0x00512330 - 0x401000)

.org 0x0050cf15 - 0x401000
.globl FUN_0050cf15
FUN_0050cf15:
    # block 0x0050cf15: entry, 6 instruction(s), ends with je to 0x0050cf58 (forward)
    push esi                                     # 0050cf15
    mov esi, dword ptr [esp + stk_8]             # 0050cf16
    push edi                                     # 0050cf1a
    or edi, -0x1                                 # 0050cf1b
    test byte ptr [esi + field_c], -0x7d         # 0050cf1e
    je.d8 L_0050cf58                             # 0050cf22
    # block 0x0050cf24: entered by fall-through of je at 0x0050cf22, 10 instruction(s), calls FUN_0050dcb0, FUN_00512330, FUN_00512250, ends with jge to 0x0050cf46 (forward)
    push esi                                     # 0050cf24
    call FUN_0050dcb0                            # 0050cf25
    push esi                                     # 0050cf2a
    {load} mov edi, eax                          # 0050cf2b
    call FUN_00512330                            # 0050cf2d
    push dword ptr [esi + field_10]              # 0050cf32
    call FUN_00512250                            # 0050cf35
    add esp, 0xc                                 # 0050cf3a
    test eax, eax                                # 0050cf3d
    jge.d8 L_0050cf46                            # 0050cf3f
    # block 0x0050cf41: entered by fall-through of jge at 0x0050cf3f, 2 instruction(s), ends with forward jump to 0x0050cf58
    or edi, -0x1                                 # 0050cf41
    jmp.d8 L_0050cf58                            # 0050cf44
L_0050cf46:
    # block 0x0050cf46: entered by jge at 0x0050cf3f, 3 instruction(s), ends with je to 0x0050cf58 (forward)
    mov eax, dword ptr [esi + field_1c]          # 0050cf46
    test eax, eax                                # 0050cf49
    je.d8 L_0050cf58                             # 0050cf4b
    # block 0x0050cf4d: entered by fall-through of je at 0x0050cf4b, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x0050cf58
    push eax                                     # 0050cf4d
    call FUN_0050e936                            # 0050cf4e
    and dword ptr [esi + field_1c], 0x0          # 0050cf53
    pop ecx                                      # 0050cf57
L_0050cf58:
    # block 0x0050cf58: entered by je at 0x0050cf22; jmp at 0x0050cf44; je at 0x0050cf4b, 5 instruction(s), ends with ret
    and dword ptr [esi + field_c], 0x0           # 0050cf58
    {load} mov eax, edi                          # 0050cf5c
    pop edi                                      # 0050cf5e
    pop esi                                      # 0050cf5f
    ret                                          # 0050cf60

