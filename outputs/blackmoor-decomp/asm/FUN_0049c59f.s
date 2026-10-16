# FUN_0049c59f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c59f
# extent:       0x0049c59f-0x0049c5f0 (81 code bytes)
# span:         0x0049c59f-0x0049c5f0 (code 81, tables 0, padding 0)
# sha256:       3c1310bfcd5e6866c4761a9f87617cb5a0aa9fecfbf4c0501895e2aab3cdc19a
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049c59f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0049c68a, FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0049c68a, .text + (0x0049c68a - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0049c59f - 0x401000
.globl FUN_0049c59f
FUN_0049c59f:
    # block 0x0049c59f: entry, 22 instruction(s), calls FUN_0049c68a, FUN_0051d730, ends with ret
    push ebp                                     # 0049c59f
    {load} mov ebp, esp                          # 0049c5a0
    push -0x1                                    # 0049c5a2
    push 0x528570                                # 0049c5a4
    mov eax, dword ptr fs:[0x0]                  # 0049c5a9
    push eax                                     # 0049c5af
    mov dword ptr fs:[0x0], esp                  # 0049c5b0
    push ecx                                     # 0049c5b7
    mov dword ptr [ebp - local_10], ecx          # 0049c5b8
    mov eax, dword ptr [ebp - local_10]          # 0049c5bb
    mov dword ptr [eax], 0x52dbc8                # 0049c5be
    mov dword ptr [ebp - local_4], 0x0           # 0049c5c4
    mov ecx, dword ptr [ebp - local_10]          # 0049c5cb
    call FUN_0049c68a                            # 0049c5ce
    mov dword ptr [ebp - local_4], 0xffffffff    # 0049c5d3
    mov ecx, dword ptr [ebp - local_10]          # 0049c5da
    call FUN_0051d730                            # 0049c5dd
    mov ecx, dword ptr [ebp - local_c]           # 0049c5e2
    mov dword ptr fs:[0x0], ecx                  # 0049c5e5
    {load} mov esp, ebp                          # 0049c5ec
    pop ebp                                      # 0049c5ee
    ret                                          # 0049c5ef

