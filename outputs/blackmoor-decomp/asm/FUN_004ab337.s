# FUN_004ab337
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab337
# extent:       0x004ab337-0x004ab38b (84 code bytes)
# span:         0x004ab337-0x004ab38b (code 84, tables 0, padding 0)
# sha256:       e6421fc2cca03dbe17a42e304ac376fef747c2cb6669d258e9da0e4accc077ba
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab337
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004ab3a7
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
.set FUN_004ab3a7, .text + (0x004ab3a7 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004ab337 - 0x401000
.globl FUN_004ab337
FUN_004ab337:
    # block 0x004ab337: entry, 23 instruction(s), calls FUN_0051d716, FUN_004ab3a7, ends with ret
    push ebp                                     # 004ab337
    {load} mov ebp, esp                          # 004ab338
    push -0x1                                    # 004ab33a
    push 0x52868d                                # 004ab33c
    mov eax, dword ptr fs:[0x0]                  # 004ab341
    push eax                                     # 004ab347
    mov dword ptr fs:[0x0], esp                  # 004ab348
    push ecx                                     # 004ab34f
    mov dword ptr [ebp - local_10], ecx          # 004ab350
    mov ecx, dword ptr [ebp - local_10]          # 004ab353
    call FUN_0051d716                            # 004ab356
    mov dword ptr [ebp - local_4], 0x0           # 004ab35b
    mov eax, dword ptr [ebp - local_10]          # 004ab362
    mov dword ptr [eax], 0x52df00                # 004ab365
    mov ecx, dword ptr [ebp - local_10]          # 004ab36b
    call FUN_004ab3a7                            # 004ab36e
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ab373
    mov eax, dword ptr [ebp - local_10]          # 004ab37a
    mov ecx, dword ptr [ebp - local_c]           # 004ab37d
    mov dword ptr fs:[0x0], ecx                  # 004ab380
    {load} mov esp, ebp                          # 004ab387
    pop ebp                                      # 004ab389
    ret                                          # 004ab38a

