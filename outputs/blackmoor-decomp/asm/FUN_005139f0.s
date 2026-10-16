# FUN_005139f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005139f0
# extent:       0x005139f0-0x00513a57 (103 code bytes)
# span:         0x005139f0-0x00513a57 (code 103, tables 0, padding 0)
# sha256:       fc736a710900a9081a126a61344250d00742ffc3e15d08a61f56e54099112ae7
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005139f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_94, field_minus_9f, field_minus_a0, field_minus_a2, field_minus_a4; [edx + n] field_e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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

.org 0x005139f0 - 0x401000
.globl FUN_005139f0
FUN_005139f0:
    # block 0x005139f0: entry, 2 instruction(s), ends with jne to 0x00513a07 (forward)
    cmp byte ptr [edx + field_e], 0x5            # 005139f0
    jne.d8 L_00513a07                            # 005139f4
    # block 0x005139f6: entered by fall-through of jne at 0x005139f4, 5 instruction(s), ends with forward jump to 0x00513a0b
    mov bx, word ptr [ebp - field_minus_a4]      # 005139f6
    or bh, 0x2                                   # 005139fd
    and bh, -0x2                                 # 00513a00
    mov bl, 0x3f                                 # 00513a03
    jmp.d8 L_00513a0b                            # 00513a05
L_00513a07:
    # block 0x00513a07: entered by jne at 0x005139f4, 1 instruction(s), falls into the block at 0x00513a0b
    mov bx, 0x133f                               # 00513a07
L_00513a0b:
    # block 0x00513a0b: entered by jmp at 0x00513a05, 22 instruction(s), ends with indirect jump dword ptr [ebx]
    mov word ptr [ebp - field_minus_a2], bx      # 00513a0b
    fldcw word ptr [ebp - field_minus_a2]        # 00513a12
    mov ebx, 0x56892c                            # 00513a18
    fxam                                         # 00513a1d
    mov dword ptr [ebp - field_minus_94], edx    # 00513a1f
    wait                                         # 00513a25
    fnstsw word ptr [ebp - field_minus_a0]       # 00513a26
    mov byte ptr [ebp - field_minus_90], 0x0     # 00513a2c
    wait                                         # 00513a33
    mov cl, byte ptr [ebp - field_minus_9f]      # 00513a34
    shl cl                                       # 00513a3a
    sar cl                                       # 00513a3c
    rol cl                                       # 00513a3e
    {load} mov al, cl                            # 00513a40
    and al, 0xf                                  # 00513a42
    xlatb                                        # 00513a44
    movsx eax, al                                # 00513a45
    and ecx, 0x404                               # 00513a48
    {load} mov ebx, edx                          # 00513a4e
    {load} add ebx, eax                          # 00513a50
    add ebx, 0x10                                # 00513a52
    jmp dword ptr [ebx]                          # 00513a55

