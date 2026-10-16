# FUN_0048cff7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cff7
# extent:       0x0048cff7-0x0048d04b (84 code bytes)
# span:         0x0048cff7-0x0048d04b (code 84, tables 0, padding 0)
# sha256:       e57bd770ce33255a9d1186aab807ac9efda42db124962cd91e8789964a2d70f7
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048cff7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0048d067
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048d067, .text + (0x0048d067 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0048cff7 - 0x401000
.globl FUN_0048cff7
FUN_0048cff7:
    # block 0x0048cff7: entry, 23 instruction(s), calls FUN_0051d716, FUN_0048d067, ends with ret
    push ebp                                     # 0048cff7
    {load} mov ebp, esp                          # 0048cff8
    push -0x1                                    # 0048cffa
    push 0x5284cd                                # 0048cffc
    mov eax, dword ptr fs:[0x0]                  # 0048d001
    push eax                                     # 0048d007
    mov dword ptr fs:[0x0], esp                  # 0048d008
    push ecx                                     # 0048d00f
    mov dword ptr [ebp - local_10], ecx          # 0048d010
    mov ecx, dword ptr [ebp - local_10]          # 0048d013
    call FUN_0051d716                            # 0048d016
    mov dword ptr [ebp - local_4], 0x0           # 0048d01b
    mov eax, dword ptr [ebp - local_10]          # 0048d022
    mov dword ptr [eax], 0x52d9e8                # 0048d025
    mov ecx, dword ptr [ebp - local_10]          # 0048d02b
    call FUN_0048d067                            # 0048d02e
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048d033
    mov eax, dword ptr [ebp - local_10]          # 0048d03a
    mov ecx, dword ptr [ebp - local_c]           # 0048d03d
    mov dword ptr fs:[0x0], ecx                  # 0048d040
    {load} mov esp, ebp                          # 0048d047
    pop ebp                                      # 0048d049
    ret                                          # 0048d04a

