# FUN_00456d07
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456d07
# extent:       0x00456d07-0x00456d2e (39 code bytes)
# span:         0x00456d07-0x00456d2e (code 39, tables 0, padding 0)
# sha256:       5155fc18b9c5e1b105192b253e4ceef6594947acfbf6e60c7e8000ef2d21f3e9
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456d07
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e; [ecx + n] field_1c; [edx + n] field_3e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_3e, 0x3e  # offset +0x3e

# --- external targets -----------------------------------------------

.org 0x00456d07 - 0x401000
.globl FUN_00456d07
FUN_00456d07:
    # block 0x00456d07: entry, 13 instruction(s), ends with ret
    push ebp                                     # 00456d07
    {load} mov ebp, esp                          # 00456d08
    push ecx                                     # 00456d0a
    mov dword ptr [ebp - local_4], ecx           # 00456d0b
    mov eax, dword ptr [ebp - local_4]           # 00456d0e
    mov word ptr [eax + field_1e], 0xffff        # 00456d11
    mov ecx, dword ptr [ebp - local_4]           # 00456d17
    mov word ptr [ecx + field_1c], 0xffff        # 00456d1a
    mov edx, dword ptr [ebp - local_4]           # 00456d20
    mov dword ptr [edx + field_3e], 0x0          # 00456d23
    {load} mov esp, ebp                          # 00456d2a
    pop ebp                                      # 00456d2c
    ret                                          # 00456d2d

