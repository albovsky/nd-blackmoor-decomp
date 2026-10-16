# FUN_0052570f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052570f
# extent:       0x0052570f-0x00525751 (66 code bytes)
# span:         0x0052570f-0x00525751 (code 66, tables 0, padding 0)
# sha256:       5f397fb3d89065d959d229f4b0ecc6e50c83d6ca5da237f1f3e26d361179153b
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052570f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c
# callees:      calls KERNEL32.dll!TlsAlloc, FUN_00519cc0, KERNEL32.dll!InitializeCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)

.org 0x0052570f - 0x401000
.globl FUN_0052570f
FUN_0052570f:
    # block 0x0052570f: entry, 14 instruction(s), calls KERNEL32.dll!TlsAlloc, ends with jne to 0x00525743 (forward)
    push esi                                     # 0052570f
    {load} mov esi, ecx                          # 00525710
    {load} xor eax, eax                          # 00525712
    mov dword ptr [esi + field_14], eax          # 00525714
    mov dword ptr [esi + field_18], eax          # 00525717
    mov dword ptr [esi + field_18], 0x4          # 0052571a
    mov dword ptr [esi + field_4], eax           # 00525721
    mov dword ptr [esi + field_8], 0x1           # 00525724
    mov dword ptr [esi + field_c], eax           # 0052572b
    mov dword ptr [esi + field_10], eax          # 0052572e
    call dword ptr [0x52a0b8]                    # 00525731
    cmp eax, -0x1                                # 00525737
    mov dword ptr [esi], eax                     # 0052573a
    jne.d8 L_00525743                            # 0052573c
    # block 0x0052573e: entered by fall-through of jne at 0x0052573c, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x00525743
    call FUN_00519cc0                            # 0052573e
L_00525743:
    # block 0x00525743: entered by jne at 0x0052573c, 6 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, ends with ret
    lea eax, [esi + field_1c]                    # 00525743
    push eax                                     # 00525746
    call dword ptr [0x52a0b4]                    # 00525747
    {load} mov eax, esi                          # 0052574d
    pop esi                                      # 0052574f
    ret                                          # 00525750

