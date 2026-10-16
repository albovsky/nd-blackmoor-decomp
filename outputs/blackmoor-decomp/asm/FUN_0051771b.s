# FUN_0051771b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051771b
# extent:       0x0051771b-0x0051777a (95 code bytes)
# span:         0x0051771b-0x0051777a (code 95, tables 0, padding 0)
# sha256:       0b42292811aaa258a0e8cbd04304853ca911a778e145cb5f7377108ab58e3099
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051771b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esi + n] field_8, field_c; [esp + n] stk_4
# callees:      calls FUN_00512c18, KERNEL32.dll!InitializeCriticalSection, FUN_00512c79, KERNEL32.dll!EnterCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0051771b - 0x401000
.globl FUN_0051771b
FUN_0051771b:
    # block 0x0051771b: entry, 14 instruction(s), ends with jne to 0x00517769 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051771b
    push ebx                                     # 0051771f
    {load} mov ecx, eax                          # 00517720
    and eax, 0x1f                                # 00517722
    sar ecx, 0x5                                 # 00517725
    push esi                                     # 00517728
    push edi                                     # 00517729
    mov esi, dword ptr [4*ecx + 0x63cde0]        # 0051772a
    lea ebx, [4*ecx + 0x63cde0]                  # 00517731
    lea edi, [eax + 8*eax]                       # 00517738
    shl edi, 0x2                                 # 0051773b
    {load} add esi, edi                          # 0051773e
    cmp dword ptr [esi + field_8], 0x0           # 00517740
    jne.d8 L_00517769                            # 00517744
    # block 0x00517746: entered by fall-through of jne at 0x00517744, 5 instruction(s), calls FUN_00512c18, ends with jne to 0x00517761 (forward)
    push 0x11                                    # 00517746
    call FUN_00512c18                            # 00517748
    cmp dword ptr [esi + field_8], 0x0           # 0051774d
    pop ecx                                      # 00517751
    jne.d8 L_00517761                            # 00517752
    # block 0x00517754: entered by fall-through of jne at 0x00517752, 4 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, falls into the block at 0x00517761
    lea eax, [esi + field_c]                     # 00517754
    push eax                                     # 00517757
    call dword ptr [0x52a0b4]                    # 00517758
    inc dword ptr [esi + field_8]                # 0051775e
L_00517761:
    # block 0x00517761: entered by jne at 0x00517752, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x00517769
    push 0x11                                    # 00517761
    call FUN_00512c79                            # 00517763
    pop ecx                                      # 00517768
L_00517769:
    # block 0x00517769: entered by jne at 0x00517744, 8 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with ret
    mov eax, dword ptr [ebx]                     # 00517769
    lea eax, [eax + edi + field_c]               # 0051776b
    push eax                                     # 0051776f
    call dword ptr [0x52a0d0]                    # 00517770
    pop edi                                      # 00517776
    pop esi                                      # 00517777
    pop ebx                                      # 00517778
    ret                                          # 00517779

