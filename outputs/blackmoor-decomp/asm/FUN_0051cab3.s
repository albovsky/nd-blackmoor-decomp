# FUN_0051cab3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cab3
# extent:       0x0051cab3-0x0051cb11 (94 code bytes)
# span:         0x0051cab3-0x0051cb11 (code 94, tables 0, padding 0)
# sha256:       a0a920c2f1ce2bb1b1dc1da4712a50be1e4bb12372abe1b88eb98a84b9252827
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cab3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_84; [ebp + n] field_8, field_minus_4, field_minus_10, field_minus_14, field_minus_18, field_minus_2c; [edi + n] field_b8; [esi + n] field_1c
# callees:      calls FUN_0050f978, FUN_0051cb55, FUN_0052513f, tail jump FUN_0051cb38; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_2c, 0x2c  # offset -0x2c
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_84, 0x84  # offset +0x84
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051cb38, .text + (0x0051cb38 - 0x401000)
.set FUN_0051cb55, .text + (0x0051cb55 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x0051cab3 - 0x401000
.globl FUN_0051cab3
FUN_0051cab3:
    # block 0x0051cab3: entry, 29 instruction(s), calls FUN_0050f978, FUN_0051cb55, FUN_0052513f, indirect dword ptr [eax + 0x84], ends with forward jump to 0x0051cb38
    mov eax, 0x528bd8                            # 0051cab3
    call FUN_0050f978                            # 0051cab8
    sub esp, 0x24                                # 0051cabd
    push ebx                                     # 0051cac0
    push esi                                     # 0051cac1
    push edi                                     # 0051cac2
    {load} mov esi, ecx                          # 0051cac3
    mov dword ptr [ebp - field_minus_10], esp    # 0051cac5
    push dword ptr [ebp + field_8]               # 0051cac8
    lea ecx, [ebp - field_minus_2c]              # 0051cacb
    push esi                                     # 0051cace
    call FUN_0051cb55                            # 0051cacf
    call FUN_0052513f                            # 0051cad4
    {load} mov edi, eax                          # 0051cad9
    and dword ptr [ebp + field_8], 0x0           # 0051cadb
    and dword ptr [ebp - field_minus_4], 0x0     # 0051cadf
    mov dword ptr [ebp - field_minus_14], edi    # 0051cae3
    mov ecx, dword ptr [edi + field_b8]          # 0051cae6
    lea eax, [edi + field_b8]                    # 0051caec
    mov dword ptr [ebp - field_minus_18], ecx    # 0051caf2
    mov ecx, dword ptr [esi + field_1c]          # 0051caf5
    mov dword ptr [eax], ecx                     # 0051caf8
    mov eax, dword ptr [esi]                     # 0051cafa
    lea ecx, [ebp - field_minus_2c]              # 0051cafc
    push ecx                                     # 0051caff
    {load} mov ecx, esi                          # 0051cb00
    call dword ptr [eax + field_84]              # 0051cb02
    mov dword ptr [ebp + field_8], 0x1           # 0051cb08
    jmp.d8 . + (41)  # -> FUN_0051cb38           # 0051cb0f

