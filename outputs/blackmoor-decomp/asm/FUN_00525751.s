# FUN_00525751
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525751
# extent:       0x00525751-0x005257a8 (87 code bytes)
# span:         0x00525751-0x005257a8 (code 87, tables 0, padding 0)
# sha256:       187808dc105993e286bbeec61400595e280c136e73981024e0f4fa159d131db9
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525751
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_10, field_14
# callees:      calls KERNEL32.dll!TlsFree, FUN_00525a1d, KERNEL32.dll!GlobalHandle, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalFree, KERNEL32.dll!DeleteCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00525a1d, .text + (0x00525a1d - 0x401000)

.org 0x00525751 - 0x401000
.globl FUN_00525751
FUN_00525751:
    # block 0x00525751: entry, 6 instruction(s), ends with je to 0x00525763 (forward)
    push esi                                     # 00525751
    {load} mov esi, ecx                          # 00525752
    push edi                                     # 00525754
    mov eax, dword ptr [esi]                     # 00525755
    cmp eax, -0x1                                # 00525757
    je.d8 L_00525763                             # 0052575a
    # block 0x0052575c: entered by fall-through of je at 0x0052575a, 2 instruction(s), calls KERNEL32.dll!TlsFree, falls into the block at 0x00525763
    push eax                                     # 0052575c
    call dword ptr [0x52a0c4]                    # 0052575d
L_00525763:
    # block 0x00525763: entered by je at 0x0052575a, 3 instruction(s), ends with je to 0x0052577d (forward)
    mov eax, dword ptr [esi + field_14]          # 00525763
    test eax, eax                                # 00525766
    je.d8 L_0052577d                             # 00525768
L_0052576a:
    # block 0x0052576a: entered by jne at 0x0052577b; fall-through of je at 0x00525768, 8 instruction(s), calls FUN_00525a1d, ends with jne to 0x0052576a (backward)
    mov edi, dword ptr [eax + field_4]           # 0052576a
    push 0x0                                     # 0052576d
    push eax                                     # 0052576f
    {load} mov ecx, esi                          # 00525770
    call FUN_00525a1d                            # 00525772
    test edi, edi                                # 00525777
    {load} mov eax, edi                          # 00525779
    jne.d8 L_0052576a                            # 0052577b
L_0052577d:
    # block 0x0052577d: entered by je at 0x00525768; fall-through of jne at 0x0052577b, 3 instruction(s), ends with je to 0x0052579b (forward)
    mov eax, dword ptr [esi + field_10]          # 0052577d
    test eax, eax                                # 00525780
    je.d8 L_0052579b                             # 00525782
    # block 0x00525784: entered by fall-through of je at 0x00525782, 7 instruction(s), calls KERNEL32.dll!GlobalHandle, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalFree, falls into the block at 0x0052579b
    push eax                                     # 00525784
    call dword ptr [0x52a0c0]                    # 00525785
    {load} mov edi, eax                          # 0052578b
    push edi                                     # 0052578d
    call dword ptr [0x52a208]                    # 0052578e
    push edi                                     # 00525794
    call dword ptr [0x52a20c]                    # 00525795
L_0052579b:
    # block 0x0052579b: entered by je at 0x00525782, 6 instruction(s), calls KERNEL32.dll!DeleteCriticalSection, ends with ret
    add esi, 0x1c                                # 0052579b
    push esi                                     # 0052579e
    call dword ptr [0x52a0bc]                    # 0052579f
    pop edi                                      # 005257a5
    pop esi                                      # 005257a6
    ret                                          # 005257a7

