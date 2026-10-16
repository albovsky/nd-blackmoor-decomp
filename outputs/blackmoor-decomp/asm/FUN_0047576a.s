# FUN_0047576a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047576a
# extent:       0x0047576a-0x004757be (84 code bytes)
# span:         0x0047576a-0x004757be (code 84, tables 0, padding 0)
# sha256:       4c0f086a8f3f77f2c6ad91f217d1693b6e5af2cacfbc1ef9714196257b60865f
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047576a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004757da
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
.set FUN_004757da, .text + (0x004757da - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0047576a - 0x401000
.globl FUN_0047576a
FUN_0047576a:
    # block 0x0047576a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004757da, ends with ret
    push ebp                                     # 0047576a
    {load} mov ebp, esp                          # 0047576b
    push -0x1                                    # 0047576d
    push 0x5282dd                                # 0047576f
    mov eax, dword ptr fs:[0x0]                  # 00475774
    push eax                                     # 0047577a
    mov dword ptr fs:[0x0], esp                  # 0047577b
    push ecx                                     # 00475782
    mov dword ptr [ebp - local_10], ecx          # 00475783
    mov ecx, dword ptr [ebp - local_10]          # 00475786
    call FUN_0051d716                            # 00475789
    mov dword ptr [ebp - local_4], 0x0           # 0047578e
    mov eax, dword ptr [ebp - local_10]          # 00475795
    mov dword ptr [eax], 0x52d490                # 00475798
    mov ecx, dword ptr [ebp - local_10]          # 0047579e
    call FUN_004757da                            # 004757a1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004757a6
    mov eax, dword ptr [ebp - local_10]          # 004757ad
    mov ecx, dword ptr [ebp - local_c]           # 004757b0
    mov dword ptr fs:[0x0], ecx                  # 004757b3
    {load} mov esp, ebp                          # 004757ba
    pop ebp                                      # 004757bc
    ret                                          # 004757bd

