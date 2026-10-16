# FUN_0051ebf8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ebf8
# extent:       0x0051ebf8-0x0051ec6f (119 code bytes)
# span:         0x0051ebf8-0x0051ec6f (code 119, tables 0, padding 0)
# sha256:       bf909d80fea823a84f6c518ac6abf226ebbf00a2a71ceb16186b2f5915a7ec4d
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ebf8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50, field_54, field_68; [ebp + n] field_minus_4, field_minus_c, field_minus_50; [edi + n] field_10, field_14; [esi + n] field_4c, field_50
# callees:      calls KERNEL32.dll!SetEvent, KERNEL32.dll!WaitForSingleObject, KERNEL32.dll!CloseHandle, FUN_0051ac62, FUN_0051ec84, FUN_0051b257; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_50, 0x50  # offset -0x50
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0051ac62, .text + (0x0051ac62 - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x0051ebf8 - 0x401000
.globl FUN_0051ebf8
FUN_0051ebf8:
    # block 0x0051ebf8: entry, 12 instruction(s), calls KERNEL32.dll!SetEvent, KERNEL32.dll!WaitForSingleObject, KERNEL32.dll!CloseHandle, ends with je to 0x0051ec27 (forward)
    push dword ptr [edi + field_10]              # 0051ebf8
    and dword ptr [ebp - field_minus_4], 0x0     # 0051ebfb
    mov ebx, dword ptr [edi + field_14]          # 0051ebff
    call dword ptr [0x52a1e8]                    # 0051ec02
    push -0x1                                    # 0051ec08
    push ebx                                     # 0051ec0a
    call dword ptr [0x52a1ec]                    # 0051ec0b
    push ebx                                     # 0051ec11
    call dword ptr [0x52a2b8]                    # 0051ec12
    mov eax, dword ptr [esi + field_50]          # 0051ec18
    test eax, eax                                # 0051ec1b
    je.d8 L_0051ec27                             # 0051ec1d
    # block 0x0051ec1f: entered by fall-through of je at 0x0051ec1d, 4 instruction(s), calls indirect eax, ends with forward jump to 0x0051ec3e
    push dword ptr [esi + field_4c]              # 0051ec1f
    call eax                                     # 0051ec22
    pop ecx                                      # 0051ec24
    jmp.d8 L_0051ec3e                            # 0051ec25
L_0051ec27:
    # block 0x0051ec27: entered by je at 0x0051ec1d, 7 instruction(s), calls indirect dword ptr [eax + 0x50], ends with jne to 0x0051ec3b (forward)
    mov eax, dword ptr [esi]                     # 0051ec27
    {load} mov ecx, esi                          # 0051ec29
    call dword ptr [eax + field_50]              # 0051ec2b
    test eax, eax                                # 0051ec2e
    mov eax, dword ptr [esi]                     # 0051ec30
    {load} mov ecx, esi                          # 0051ec32
    jne.d8 L_0051ec3b                            # 0051ec34
    # block 0x0051ec36: entered by fall-through of jne at 0x0051ec34, 2 instruction(s), calls indirect dword ptr [eax + 0x68], ends with forward jump to 0x0051ec3e
    call dword ptr [eax + field_68]              # 0051ec36
    jmp.d8 L_0051ec3e                            # 0051ec39
L_0051ec3b:
    # block 0x0051ec3b: entered by jne at 0x0051ec34, 1 instruction(s), calls indirect dword ptr [eax + 0x54], falls into the block at 0x0051ec3e
    call dword ptr [eax + field_54]              # 0051ec3b
L_0051ec3e:
    # block 0x0051ec3e: entered by jmp at 0x0051ec25; jmp at 0x0051ec39, 17 instruction(s), calls FUN_0051ac62, FUN_0051ec84, FUN_0051b257, ends with ret 0x4
    lea ecx, [ebp - field_minus_50]              # 0051ec3e
    {load} mov esi, eax                          # 0051ec41
    call FUN_0051ac62                            # 0051ec43
    push 0x1                                     # 0051ec48
    push esi                                     # 0051ec4a
    call FUN_0051ec84                            # 0051ec4b
    or dword ptr [ebp - field_minus_4], -0x1     # 0051ec50
    lea ecx, [ebp - field_minus_50]              # 0051ec54
    call FUN_0051b257                            # 0051ec57
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051ec5c
    pop edi                                      # 0051ec5f
    pop esi                                      # 0051ec60
    {load} xor eax, eax                          # 0051ec61
    mov dword ptr fs:[0x0], ecx                  # 0051ec63
    pop ebx                                      # 0051ec6a
    leave                                        # 0051ec6b
    ret 0x4                                      # 0051ec6c

