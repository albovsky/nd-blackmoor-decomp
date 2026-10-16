# FUN_00459ace
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459ace
# extent:       0x00459ace-0x00459aea (28 code bytes)
# span:         0x00459ace-0x00459aea (code 28, tables 0, padding 0)
# sha256:       838f13450e523294d92526e45e7f9795b56f934f7a214dffb908edc575ded6e4
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459ace
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

.org 0x00459ace - 0x401000
.globl FUN_00459ace
FUN_00459ace:
    # block 0x00459ace: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00459ace
    {load} mov ebp, esp                          # 00459acf
    push ecx                                     # 00459ad1
    mov dword ptr [ebp - local_4], ecx           # 00459ad2
    mov eax, dword ptr [ebp - local_4]           # 00459ad5
    mov dword ptr [eax], 0x52cee8                # 00459ad8
    mov ecx, dword ptr [ebp - local_4]           # 00459ade
    call FUN_0051d730                            # 00459ae1
    {load} mov esp, ebp                          # 00459ae6
    pop ebp                                      # 00459ae8
    ret                                          # 00459ae9

