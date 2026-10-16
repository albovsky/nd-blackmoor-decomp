# FUN_00513a57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513a57
# extent:       0x00513a57-0x00513ae3 (140 code bytes)
# span:         0x00513a57-0x00513ae3 (code 140, tables 0, padding 0)
# sha256:       875f3fffbd05cc164f3d3c18d268204393e355c862294ba9e6c944cf894cf39f
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513a57
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_94, field_minus_9f, field_minus_a0, field_minus_a2, field_minus_a4; [edx + n] field_e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00513ae3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_94, 0x94  # offset -0x94
.equ field_minus_9f, 0x9f  # offset -0x9f
.equ field_minus_a0, 0xa0  # offset -0xa0
.equ field_minus_a2, 0xa2  # offset -0xa2
.equ field_minus_a4, 0xa4  # offset -0xa4
.equ field_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------

.org 0x00513a57 - 0x401000
.globl FUN_00513a57
FUN_00513a57:
    # block 0x00513a57: entry, 2 instruction(s), ends with jne to 0x00513a6e (forward)
    cmp byte ptr [edx + field_e], 0x5            # 00513a57
    jne.d8 L_00513a6e                            # 00513a5b
    # block 0x00513a5d: entered by fall-through of jne at 0x00513a5b, 5 instruction(s), ends with forward jump to 0x00513a72
    mov bx, word ptr [ebp - field_minus_a4]      # 00513a5d
    or bh, 0x2                                   # 00513a64
    and bh, -0x2                                 # 00513a67
    mov bl, 0x3f                                 # 00513a6a
    jmp.d8 L_00513a72                            # 00513a6c
L_00513a6e:
    # block 0x00513a6e: entered by jne at 0x00513a5b, 1 instruction(s), falls into the block at 0x00513a72
    mov bx, 0x133f                               # 00513a6e
L_00513a72:
    # block 0x00513a72: entered by jmp at 0x00513a6c, 37 instruction(s), ends with indirect jump dword ptr [ebx]
    mov word ptr [ebp - field_minus_a2], bx      # 00513a72
    fldcw word ptr [ebp - field_minus_a2]        # 00513a79
    mov ebx, 0x56892c                            # 00513a7f
    fxam                                         # 00513a84
    mov dword ptr [ebp - field_minus_94], edx    # 00513a86
    wait                                         # 00513a8c
    fnstsw word ptr [ebp - field_minus_a0]       # 00513a8d
    mov byte ptr [ebp - field_minus_90], 0x0     # 00513a93
    fxch st(1)                                   # 00513a9a
    mov cl, byte ptr [ebp - field_minus_9f]      # 00513a9c
    fxam                                         # 00513aa2
    wait                                         # 00513aa4
    fnstsw word ptr [ebp - field_minus_a0]       # 00513aa5
    fxch st(1)                                   # 00513aab
    mov ch, byte ptr [ebp - field_minus_9f]      # 00513aad
    shl ch                                       # 00513ab3
    sar ch                                       # 00513ab5
    rol ch                                       # 00513ab7
    {load} mov al, ch                            # 00513ab9
    and al, 0xf                                  # 00513abb
    xlatb                                        # 00513abd
    {load} mov ah, al                            # 00513abe
    shl cl                                       # 00513ac0
    sar cl                                       # 00513ac2
    rol cl                                       # 00513ac4
    {load} mov al, cl                            # 00513ac6
    and al, 0xf                                  # 00513ac8
    xlatb                                        # 00513aca
    shl ah                                       # 00513acb
    shl ah                                       # 00513acd
    {load} or al, ah                             # 00513acf
    movsx eax, al                                # 00513ad1
    and ecx, 0x404                               # 00513ad4
    {load} mov ebx, edx                          # 00513ada
    {load} add ebx, eax                          # 00513adc
    add ebx, 0x10                                # 00513ade
    jmp dword ptr [ebx]                          # 00513ae1

