# FUN_004f872e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f872e
# extent:       0x004f872e-0x004f875f (49 code bytes)
# span:         0x004f872e-0x004f875f (code 49, tables 0, padding 0)
# sha256:       45a2a01554f1a28354a19542760ccd4415c198b0d923cc86dfcdce06d86314f1
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f872e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_248; [ecx + n] field_240; [edx + n] field_244
# callees:      calls FUN_004f861c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248

# --- external targets -----------------------------------------------
.set FUN_004f861c, .text + (0x004f861c - 0x401000)

.org 0x004f872e - 0x401000
.globl FUN_004f872e
FUN_004f872e:
    # block 0x004f872e: entry, 18 instruction(s), calls FUN_004f861c, ends with ret
    push ebp                                     # 004f872e
    {load} mov ebp, esp                          # 004f872f
    push ecx                                     # 004f8731
    mov dword ptr [ebp - local_4], ecx           # 004f8732
    mov eax, dword ptr [ebp - local_4]           # 004f8735
    mov ecx, dword ptr [eax + field_248]         # 004f8738
    push ecx                                     # 004f873e
    mov edx, dword ptr [ebp - local_4]           # 004f873f
    mov eax, dword ptr [edx + field_244]         # 004f8742
    push eax                                     # 004f8748
    mov ecx, dword ptr [ebp - local_4]           # 004f8749
    mov edx, dword ptr [ecx + field_240]         # 004f874c
    push edx                                     # 004f8752
    mov ecx, dword ptr [ebp - local_4]           # 004f8753
    call FUN_004f861c                            # 004f8756
    {load} mov esp, ebp                          # 004f875b
    pop ebp                                      # 004f875d
    ret                                          # 004f875e

