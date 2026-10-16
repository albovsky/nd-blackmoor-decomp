# FUN_00487afe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487afe
# extent:       0x00487afe-0x00487b1a (28 code bytes)
# span:         0x00487afe-0x00487b1a (code 28, tables 0, padding 0)
# sha256:       b8beab32f36789bc06c35b60e23e87611b603c77797eefaabc1c613514bd1c0d
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00487afe
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

.org 0x00487afe - 0x401000
.globl FUN_00487afe
FUN_00487afe:
    # block 0x00487afe: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00487afe
    {load} mov ebp, esp                          # 00487aff
    push ecx                                     # 00487b01
    mov dword ptr [ebp - local_4], ecx           # 00487b02
    mov eax, dword ptr [ebp - local_4]           # 00487b05
    mov dword ptr [eax], 0x52d7c8                # 00487b08
    mov ecx, dword ptr [ebp - local_4]           # 00487b0e
    call FUN_0051d730                            # 00487b11
    {load} mov esp, ebp                          # 00487b16
    pop ebp                                      # 00487b18
    ret                                          # 00487b19

