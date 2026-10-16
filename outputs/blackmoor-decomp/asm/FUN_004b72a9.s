# FUN_004b72a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b72a9
# extent:       0x004b72a9-0x004b72cf (38 code bytes)
# span:         0x004b72a9-0x004b72cf (code 38, tables 0, padding 0)
# sha256:       7e3eb0a30d7c016613ca3a4edd71e7186cde31e02d0e1eb924ed9b0ca7cc0d6a
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b72a9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004b72a9 - 0x401000
.globl FUN_004b72a9
FUN_004b72a9:
    # block 0x004b72a9: entry, 10 instruction(s), ends with ret
    push ebp                                     # 004b72a9
    {load} mov ebp, esp                          # 004b72aa
    push ecx                                     # 004b72ac
    mov dword ptr [ebp - local_4], ecx           # 004b72ad
    mov word ptr [0x5957c5], 0x0                 # 004b72b0
    mov word ptr [0x5957c7], 0x0                 # 004b72b9
    mov word ptr [0x5957c9], 0x0                 # 004b72c2
    {load} mov esp, ebp                          # 004b72cb
    pop ebp                                      # 004b72cd
    ret                                          # 004b72ce

