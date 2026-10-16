# FUN_0040907b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040907b
# extent:       0x0040907b-0x0040909b (32 code bytes)
# span:         0x0040907b-0x0040909b (code 32, tables 0, padding 0)
# sha256:       374c9f9ec9f1d925931ec04f36ee9b5cad844d12c65879eb29b1d0982da42480
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040907b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521b22, FUN_004090ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_00521b22, .text + (0x00521b22 - 0x401000)

.org 0x0040907b - 0x401000
.globl FUN_0040907b
FUN_0040907b:
    # block 0x0040907b: entry, 12 instruction(s), calls FUN_00521b22, FUN_004090ab, ends with ret
    push ebp                                     # 0040907b
    {load} mov ebp, esp                          # 0040907c
    push ecx                                     # 0040907e
    mov dword ptr [ebp - local_4], ecx           # 0040907f
    mov ecx, dword ptr [ebp - local_4]           # 00409082
    call FUN_00521b22                            # 00409085
    mov ecx, dword ptr [ebp - local_4]           # 0040908a
    call FUN_004090ab                            # 0040908d
    mov eax, 0x1                                 # 00409092
    {load} mov esp, ebp                          # 00409097
    pop ebp                                      # 00409099
    ret                                          # 0040909a

