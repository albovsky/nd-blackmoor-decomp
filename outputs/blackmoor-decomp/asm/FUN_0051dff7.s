# FUN_0051dff7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dff7
# extent:       0x0051dff7-0x0051e07e (135 code bytes)
# span:         0x0051dff7-0x0051e07e (code 135, tables 0, padding 0)
# sha256:       36e07cd0e094a9373276479a2dc208238aee42a8632c33101ca0d3c5606a4950
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dff7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_a4, field_b4; [ebp + n] field_minus_4, field_minus_c, field_minus_14, field_minus_18, field_minus_34; [esi + n] field_24
# callees:      calls FUN_0051b0e3, USER32.dll!DestroyWindow, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalFree; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051e07e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_34, 0x34  # offset -0x34
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_a4, 0xa4  # offset +0xa4
.equ field_b4, 0xb4  # offset +0xb4

# --- external targets -----------------------------------------------
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)

.org 0x0051dff7 - 0x401000
.globl FUN_0051dff7
FUN_0051dff7:
    # block 0x0051dff7: entry, 3 instruction(s), ends with je to 0x0051e01a (forward)
    or dword ptr [ebp - field_minus_4], -0x1     # 0051dff7
    {load} cmp edi, ebx                          # 0051dffb
    je.d8 L_0051e01a                             # 0051dffd
    # block 0x0051dfff: entered by fall-through of je at 0x0051dffd, 7 instruction(s), calls indirect dword ptr [eax + 0x14], ends with je to 0x0051e01a (forward)
    mov eax, dword ptr [edi]                     # 0051dfff
    lea ecx, [ebp - field_minus_34]              # 0051e001
    push ecx                                     # 0051e004
    {load} mov ecx, edi                          # 0051e005
    call dword ptr [eax + field_14]              # 0051e007
    cmp dword ptr [ebp - field_minus_18], ebx    # 0051e00a
    je.d8 L_0051e01a                             # 0051e00d
    # block 0x0051e00f: entered by fall-through of je at 0x0051e00d, 4 instruction(s), calls indirect dword ptr [eax + 0xb4], falls into the block at 0x0051e01a
    mov eax, dword ptr [esi]                     # 0051e00f
    push ebx                                     # 0051e011
    {load} mov ecx, esi                          # 0051e012
    call dword ptr [eax + field_b4]              # 0051e014
L_0051e01a:
    # block 0x0051e01a: entered by je at 0x0051dffd; je at 0x0051e00d, 3 instruction(s), calls FUN_0051b0e3, ends with jne to 0x0051e02d (forward)
    call FUN_0051b0e3                            # 0051e01a
    test eax, eax                                # 0051e01f
    jne.d8 L_0051e02d                            # 0051e021
    # block 0x0051e023: entered by fall-through of jne at 0x0051e021, 3 instruction(s), calls indirect dword ptr [eax + 0xa4], falls into the block at 0x0051e02d
    mov eax, dword ptr [esi]                     # 0051e023
    {load} mov ecx, esi                          # 0051e025
    call dword ptr [eax + field_a4]              # 0051e027
L_0051e02d:
    # block 0x0051e02d: entered by jne at 0x0051e021, 2 instruction(s), ends with je to 0x0051e044 (forward)
    cmp dword ptr [ebp - field_minus_18], ebx    # 0051e02d
    je.d8 L_0051e044                             # 0051e030
    # block 0x0051e032: entered by fall-through of je at 0x0051e030, 2 instruction(s), ends with jne to 0x0051e044 (forward)
    test byte ptr [esi + field_24], 0x10         # 0051e032
    jne.d8 L_0051e044                            # 0051e036
    # block 0x0051e038: entered by fall-through of jne at 0x0051e036, 3 instruction(s), calls USER32.dll!DestroyWindow, falls into the block at 0x0051e044
    push dword ptr [ebp - field_minus_18]        # 0051e038
    call dword ptr [0x52a414]                    # 0051e03b
    mov dword ptr [ebp - field_minus_18], ebx    # 0051e041
L_0051e044:
    # block 0x0051e044: entered by je at 0x0051e030; jne at 0x0051e036, 2 instruction(s), ends with je to 0x0051e05b (forward)
    cmp dword ptr [ebp - field_minus_14], ebx    # 0051e044
    je.d8 L_0051e05b                             # 0051e047
    # block 0x0051e049: entered by fall-through of je at 0x0051e047, 4 instruction(s), calls KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalFree, falls into the block at 0x0051e05b
    push dword ptr [ebp - field_minus_14]        # 0051e049
    call dword ptr [0x52a208]                    # 0051e04c
    push dword ptr [ebp - field_minus_14]        # 0051e052
    call dword ptr [0x52a20c]                    # 0051e055
L_0051e05b:
    # block 0x0051e05b: entered by je at 0x0051e047, 2 instruction(s), ends with jne to 0x0051e06a (forward)
    cmp dword ptr [ebp - field_minus_18], ebx    # 0051e05b
    jne.d8 L_0051e06a                            # 0051e05e
    # block 0x0051e060: entered by fall-through of jne at 0x0051e05e, 2 instruction(s), ends with je to 0x0051e06a (forward)
    test byte ptr [esi + field_24], 0x10         # 0051e060
    je.d8 L_0051e06a                             # 0051e064
    # block 0x0051e066: entered by fall-through of je at 0x0051e064, 2 instruction(s), ends with forward jump to 0x0051e06d
    {load} xor eax, eax                          # 0051e066
    jmp.d8 L_0051e06d                            # 0051e068
L_0051e06a:
    # block 0x0051e06a: entered by jne at 0x0051e05e; je at 0x0051e064, 2 instruction(s), falls into the block at 0x0051e06d
    push 0x1                                     # 0051e06a
    pop eax                                      # 0051e06c
L_0051e06d:
    # block 0x0051e06d: entered by jmp at 0x0051e068, 7 instruction(s), ends with ret 0xc
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051e06d
    pop edi                                      # 0051e070
    pop esi                                      # 0051e071
    mov dword ptr fs:[0x0], ecx                  # 0051e072
    pop ebx                                      # 0051e079
    leave                                        # 0051e07a
    ret 0xc                                      # 0051e07b

