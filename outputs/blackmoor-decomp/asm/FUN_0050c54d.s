# FUN_0050c54d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c54d
# extent:       0x0050c54d-0x0050c575 (40 code bytes)
# span:         0x0050c54d-0x0050c575 (code 40, tables 0, padding 0)
# sha256:       da67997396b4be0dee7c292588141b92564a82336bbea374f2d9c68aacf00287
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c54d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c, field_10
# callees:      calls KERNEL32.dll!EnterCriticalSection, FUN_0051a3f4, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051a3f4, .text + (0x0051a3f4 - 0x401000)

.org 0x0050c54d - 0x401000
.globl FUN_0050c54d
FUN_0050c54d:
    # block 0x0050c54d: entry, 15 instruction(s), calls KERNEL32.dll!EnterCriticalSection, FUN_0051a3f4, KERNEL32.dll!LeaveCriticalSection, ends with ret
    push esi                                     # 0050c54d
    {load} mov esi, ecx                          # 0050c54e
    push edi                                     # 0050c550
    lea edi, [esi + field_10]                    # 0050c551
    push edi                                     # 0050c554
    call dword ptr [0x52a0d0]                    # 0050c555
    mov ecx, dword ptr [esi + field_8]           # 0050c55b
    call FUN_0051a3f4                            # 0050c55e
    and dword ptr [esi + field_8], 0x0           # 0050c563
    and dword ptr [esi + field_c], 0x0           # 0050c567
    push edi                                     # 0050c56b
    call dword ptr [0x52a0c8]                    # 0050c56c
    pop edi                                      # 0050c572
    pop esi                                      # 0050c573
    ret                                          # 0050c574

