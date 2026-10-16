# FUN_00483f4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483f4e
# extent:       0x00483f4e-0x00483f6a (28 code bytes)
# span:         0x00483f4e-0x00483f6a (code 28, tables 0, padding 0)
# sha256:       5d0a95828b7330f54344bd2e017d4d08e9590eda3245caf3a2c5f49a10aeaaaa
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00483f4e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00483f4e - 0x401000
.globl FUN_00483f4e
FUN_00483f4e:
    # block 0x00483f4e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00483f4e
    {load} mov ebp, esp                          # 00483f4f
    push ecx                                     # 00483f51
    mov dword ptr [ebp - local_4], ecx           # 00483f52
    mov eax, dword ptr [ebp - local_4]           # 00483f55
    mov dword ptr [eax], 0x52d740                # 00483f58
    mov ecx, dword ptr [ebp - local_4]           # 00483f5e
    call FUN_0051d730                            # 00483f61
    {load} mov esp, ebp                          # 00483f66
    pop ebp                                      # 00483f68
    ret                                          # 00483f69

