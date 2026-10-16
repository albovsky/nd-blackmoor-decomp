# FUN_0044afd6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044afd6
# extent:       0x0044afd6-0x0044aff2 (28 code bytes)
# span:         0x0044afd6-0x0044aff2 (code 28, tables 0, padding 0)
# sha256:       a8306a1439f3fade78dd871befd6ffbb10149928feed955158a9066701282c83
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044afd6
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

.org 0x0044afd6 - 0x401000
.globl FUN_0044afd6
FUN_0044afd6:
    # block 0x0044afd6: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0044afd6
    {load} mov ebp, esp                          # 0044afd7
    push ecx                                     # 0044afd9
    mov dword ptr [ebp - local_4], ecx           # 0044afda
    mov eax, dword ptr [ebp - local_4]           # 0044afdd
    mov dword ptr [eax], 0x52cb98                # 0044afe0
    mov ecx, dword ptr [ebp - local_4]           # 0044afe6
    call FUN_0051d730                            # 0044afe9
    {load} mov esp, ebp                          # 0044afee
    pop ebp                                      # 0044aff0
    ret                                          # 0044aff1

