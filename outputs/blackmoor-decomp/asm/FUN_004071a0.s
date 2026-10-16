# FUN_004071a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004071a0
# extent:       0x004071a0-0x004071e7 (71 code bytes)
# span:         0x004071a0-0x004071e7 (code 71, tables 0, padding 0)
# sha256:       cc82049210c1067de18d77ef581f874dd16cb5fe38029ebb343e2e72bed9d4a8
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004071a0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004071a0 - 0x401000
.globl FUN_004071a0
FUN_004071a0:
    # block 0x004071a0: entry, 6 instruction(s), ends with jne to 0x004071bc (forward)
    push ebp                                     # 004071a0
    {load} mov ebp, esp                          # 004071a1
    push ecx                                     # 004071a3
    mov dword ptr [ebp - local_4], ecx           # 004071a4
    cmp dword ptr [0x5e359a], 0x1                # 004071a7
    jne.d8 L_004071bc                            # 004071ae
    # block 0x004071b0: entered by fall-through of jne at 0x004071ae, 2 instruction(s), ends with forward jump to 0x004071db
    mov dword ptr [0x5e359a], 0x0                # 004071b0
    jmp.d8 L_004071db                            # 004071ba
L_004071bc:
    # block 0x004071bc: entered by jne at 0x004071ae, 4 instruction(s), ends with jne to 0x004071db (forward)
    mov dword ptr [0x5e359a], 0x1                # 004071bc
    movsx eax, word ptr [0x5e335e]               # 004071c6
    cmp eax, 0x24                                # 004071cd
    jne.d8 L_004071db                            # 004071d0
    # block 0x004071d2: entered by fall-through of jne at 0x004071d0, 1 instruction(s), falls into the block at 0x004071db
    mov word ptr [0x5e335e], 0xffff              # 004071d2
L_004071db:
    # block 0x004071db: entered by jmp at 0x004071ba; jne at 0x004071d0, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004071db
    call FUN_00404be1                            # 004071de
    {load} mov esp, ebp                          # 004071e3
    pop ebp                                      # 004071e5
    ret                                          # 004071e6

