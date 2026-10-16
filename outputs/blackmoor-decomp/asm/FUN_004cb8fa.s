# FUN_004cb8fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb8fa
# extent:       0x004cb8fa-0x004cb91f (37 code bytes)
# span:         0x004cb8fa-0x004cb91f (code 37, tables 0, padding 0)
# sha256:       4df91d1048830294aceb319847abdcbbe4cddc98d30c64411999630902db8fc5
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cb8fa
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004cc70f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004cc70f, .text + (0x004cc70f - 0x401000)

.org 0x004cb8fa - 0x401000
.globl FUN_004cb8fa
FUN_004cb8fa:
    # block 0x004cb8fa: entry, 14 instruction(s), calls FUN_004cc70f, ends with ret
    push ebp                                     # 004cb8fa
    {load} mov ebp, esp                          # 004cb8fb
    sub esp, 0x8                                 # 004cb8fd
    mov dword ptr [ebp - local_8], ecx           # 004cb900
    mov dword ptr [ebp - local_4], 0x0           # 004cb903
    push 0xd                                     # 004cb90a
    lea eax, [ebp - local_4]                     # 004cb90c
    push eax                                     # 004cb90f
    mov ecx, dword ptr [ebp - local_8]           # 004cb910
    call FUN_004cc70f                            # 004cb913
    mov eax, dword ptr [ebp - local_4]           # 004cb918
    {load} mov esp, ebp                          # 004cb91b
    pop ebp                                      # 004cb91d
    ret                                          # 004cb91e

