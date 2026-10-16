# FUN_005096c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005096c0
# extent:       0x005096c0-0x00509708 (72 code bytes)
# span:         0x005096c0-0x00509710 (code 72, tables 0, padding 8)
# sha256:       d22427651b39e19e6e6e496c824ddf5a86173957277a69dcd18ff32f43d3a236
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005096c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_10, stk_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x005096c0 - 0x401000
.globl FUN_005096c0
FUN_005096c0:
    # block 0x005096c0: entry, 22 instruction(s), ends with jge to 0x00509702 (forward)
    mov ecx, dword ptr [esp + stk_10]            # 005096c0
    push esi                                     # 005096c4
    mov esi, dword ptr [esp + stk_10]            # 005096c5
    and ecx, 0x7fff                              # 005096c9
    and esi, 0x7fff                              # 005096cf
    push edi                                     # 005096d5
    {load} sub ecx, esi                          # 005096d6
    mov edi, dword ptr [esp + stk_1c]            # 005096d8
    {load} mov eax, ecx                          # 005096dc
    cdq                                          # 005096de
    {load} xor eax, edx                          # 005096df
    {load} sub eax, edx                          # 005096e1
    mov edx, dword ptr [esp + stk_c]             # 005096e3
    {load} sub edi, edx                          # 005096e7
    imul eax, edi                                # 005096e9
    mov edi, dword ptr [esp + stk_10]            # 005096ec
    {load} sub edi, edx                          # 005096f0
    cdq                                          # 005096f2
    idiv edi                                     # 005096f3
    test ecx, ecx                                # 005096f5
    {load} mov edx, eax                          # 005096f7
    jge.d8 L_00509702                            # 005096f9
    # block 0x005096fb: entered by fall-through of jge at 0x005096f9, 5 instruction(s), ends with ret
    {load} mov eax, esi                          # 005096fb
    pop edi                                      # 005096fd
    {load} sub eax, edx                          # 005096fe
    pop esi                                      # 00509700
    ret                                          # 00509701
L_00509702:
    # block 0x00509702: entered by jge at 0x005096f9, 4 instruction(s), ends with ret
    lea eax, [edx + esi]                         # 00509702
    pop edi                                      # 00509705
    pop esi                                      # 00509706
    ret                                          # 00509707

# --- data items (not part of the function) -------------------------
.org 0x00509708 - 0x401000
PAD_00509708:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

