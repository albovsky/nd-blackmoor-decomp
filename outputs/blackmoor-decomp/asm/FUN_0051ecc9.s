# FUN_0051ecc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ecc9
# extent:       0x0051ecc9-0x0051ed28 (95 code bytes)
# span:         0x0051ecc9-0x0051ed28 (code 95, tables 0, padding 0)
# sha256:       01aa124122b1968ee7db24db02006fa4d974eec21dc874308a6769c476adc49f
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ecc9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_14; [esi + n] field_14, field_30
# callees:      calls FUN_00525371, FUN_0052513f, KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, FUN_00525bd1, FUN_00525b0f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x0051ecc9 - 0x401000
.globl FUN_0051ecc9
FUN_0051ecc9:
    # block 0x0051ecc9: entry, 3 instruction(s), calls FUN_00525371, ends with jne to 0x0051ed27 (forward)
    call FUN_00525371                            # 0051ecc9
    cmp byte ptr [eax + field_14], 0x0           # 0051ecce
    jne.d8 L_0051ed27                            # 0051ecd2
    # block 0x0051ecd4: entered by fall-through of jne at 0x0051ecd2, 16 instruction(s), calls FUN_0052513f, KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, FUN_00525bd1, ends with je to 0x0051ed17 (forward)
    push esi                                     # 0051ecd4
    call FUN_0052513f                            # 0051ecd5
    {load} mov esi, eax                          # 0051ecda
    call dword ptr [0x52a2a0]                    # 0051ecdc
    push eax                                     # 0051ece2
    push 0x0                                     # 0051ece3
    push 0x51f164                                # 0051ece5
    push -0x1                                    # 0051ecea
    call dword ptr [0x52a41c]                    # 0051ecec
    push 0x5249d1                                # 0051ecf2
    mov ecx, 0x63c740                            # 0051ecf7
    mov dword ptr [esi + field_30], eax          # 0051ecfc
    call FUN_00525bd1                            # 0051ecff
    {load} mov esi, eax                          # 0051ed04
    cmp dword ptr [esi + field_14], 0x0          # 0051ed06
    je.d8 L_0051ed17                             # 0051ed0a
    # block 0x0051ed0c: entered by fall-through of je at 0x0051ed0a, 3 instruction(s), calls FUN_00525371, indirect dword ptr [esi + 0x14], falls into the block at 0x0051ed17
    call FUN_00525371                            # 0051ed0c
    push dword ptr [eax + field_8]               # 0051ed11
    call dword ptr [esi + field_14]              # 0051ed14
L_0051ed17:
    # block 0x0051ed17: entered by je at 0x0051ed0a, 4 instruction(s), calls FUN_00525b0f, falls into the block at 0x0051ed27
    push 0x524c05                                # 0051ed17
    mov ecx, 0x63c73c                            # 0051ed1c
    call FUN_00525b0f                            # 0051ed21
    pop esi                                      # 0051ed26
L_0051ed27:
    # block 0x0051ed27: entered by jne at 0x0051ecd2, 1 instruction(s), ends with ret
    ret                                          # 0051ed27

