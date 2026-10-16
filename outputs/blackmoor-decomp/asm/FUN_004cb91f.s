# FUN_004cb91f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb91f
# extent:       0x004cb91f-0x004cb944 (37 code bytes)
# span:         0x004cb91f-0x004cb944 (code 37, tables 0, padding 0)
# sha256:       71c0400985924154dc86b40a501bc5ef70f760925b3ac352a548d282a2b3dc1e
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cb91f
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

.org 0x004cb91f - 0x401000
.globl FUN_004cb91f
FUN_004cb91f:
    # block 0x004cb91f: entry, 14 instruction(s), calls FUN_004cc70f, ends with ret
    push ebp                                     # 004cb91f
    {load} mov ebp, esp                          # 004cb920
    sub esp, 0x8                                 # 004cb922
    mov dword ptr [ebp - local_8], ecx           # 004cb925
    mov dword ptr [ebp - local_4], 0x0           # 004cb928
    push 0x29                                    # 004cb92f
    lea eax, [ebp - local_4]                     # 004cb931
    push eax                                     # 004cb934
    mov ecx, dword ptr [ebp - local_8]           # 004cb935
    call FUN_004cc70f                            # 004cb938
    mov eax, dword ptr [ebp - local_4]           # 004cb93d
    {load} mov esp, ebp                          # 004cb940
    pop ebp                                      # 004cb942
    ret                                          # 004cb943

