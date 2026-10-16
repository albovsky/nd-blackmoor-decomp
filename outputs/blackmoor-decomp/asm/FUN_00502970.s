# FUN_00502970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502970
# extent:       0x00502970-0x005029c3 (83 code bytes)
# span:         0x00502970-0x005029d0 (code 83, tables 0, padding 13)
# sha256:       f7d0672ad9d0b0b31d4728a554b0e3465cc56af0b26320b3c44655f2528e3a71
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502970
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_4, field_8, field_c, field_10, field_14; [esi + n] field_4, field_8; [esp + n] stk_8, stk_10
# callees:      calls FUN_00502440, FUN_00502630
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00502440, .text + (0x00502440 - 0x401000)
.set FUN_00502630, .text + (0x00502630 - 0x401000)

.org 0x00502970 - 0x401000
.globl FUN_00502970
FUN_00502970:
    # block 0x00502970: entry, 35 instruction(s), calls FUN_00502440, FUN_00502630, ends with ret
    push ebx                                     # 00502970
    mov ebx, dword ptr [esp + stk_8]             # 00502971
    push esi                                     # 00502975
    mov esi, dword ptr [esp + stk_10]            # 00502976
    push edi                                     # 0050297a
    mov ecx, 0xb                                 # 0050297b
    {load} xor eax, eax                          # 00502980
    {load} mov edi, ebx                          # 00502982
    rep stosd dword ptr es:[edi], eax            # 00502984
    mov dword ptr [ebx + field_c], esi           # 00502986
    mov eax, dword ptr [esi + field_4]           # 00502989
    mov dword ptr [ebx + field_4], eax           # 0050298c
    mov ecx, dword ptr [esi + field_4]           # 0050298f
    mov dword ptr [ebx + field_8], ecx           # 00502992
    mov edx, dword ptr [esi]                     # 00502995
    mov dword ptr [ebx], edx                     # 00502997
    mov eax, dword ptr [esi + field_4]           # 00502999
    mov ecx, dword ptr [esi + field_8]           # 0050299c
    push 0x0                                     # 0050299f
    push eax                                     # 005029a1
    push ecx                                     # 005029a2
    call FUN_00502440                            # 005029a3
    mov dword ptr [ebx + field_14], eax          # 005029a8
    mov edx, dword ptr [esi + field_4]           # 005029ab
    push 0x0                                     # 005029ae
    push edx                                     # 005029b0
    push esi                                     # 005029b1
    call FUN_00502630                            # 005029b2
    add esp, 0x18                                # 005029b7
    mov dword ptr [ebx + field_10], eax          # 005029ba
    {load} xor eax, eax                          # 005029bd
    pop edi                                      # 005029bf
    pop esi                                      # 005029c0
    pop ebx                                      # 005029c1
    ret                                          # 005029c2

# --- data items (not part of the function) -------------------------
.org 0x005029c3 - 0x401000
PAD_005029c3:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

