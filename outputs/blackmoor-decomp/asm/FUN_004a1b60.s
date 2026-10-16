# FUN_004a1b60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1b60
# extent:       0x004a1b60-0x004a1bc7 (103 code bytes)
# span:         0x004a1b60-0x004a1bc7 (code 103, tables 0, padding 0)
# sha256:       903241f58c24c2794e44798fc318d7b489228c80315b848c07e49b872d8776d3
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1b60
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004a1bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004a1bd7, .text + (0x004a1bd7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a1b60 - 0x401000
.globl FUN_004a1b60
FUN_004a1b60:
    # block 0x004a1b60: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004a1ba2 (forward)
    push ebp                                     # 004a1b60
    {load} mov ebp, esp                          # 004a1b61
    push -0x1                                    # 004a1b63
    push 0x52858a                                # 004a1b65
    mov eax, dword ptr fs:[0x0]                  # 004a1b6a
    push eax                                     # 004a1b70
    mov dword ptr fs:[0x0], esp                  # 004a1b71
    sub esp, 0xc                                 # 004a1b78
    push 0x68                                    # 004a1b7b
    call FUN_0051dc43                            # 004a1b7d
    add esp, 0x4                                 # 004a1b82
    mov dword ptr [ebp - local_14], eax          # 004a1b85
    mov dword ptr [ebp - local_4], 0x0           # 004a1b88
    cmp dword ptr [ebp - local_14], 0x0          # 004a1b8f
    je.d8 L_004a1ba2                             # 004a1b93
    # block 0x004a1b95: entered by fall-through of je at 0x004a1b93, 4 instruction(s), calls FUN_004a1bd7, ends with forward jump to 0x004a1ba9
    mov ecx, dword ptr [ebp - local_14]          # 004a1b95
    call FUN_004a1bd7                            # 004a1b98
    mov dword ptr [ebp - local_18], eax          # 004a1b9d
    jmp.d8 L_004a1ba9                            # 004a1ba0
L_004a1ba2:
    # block 0x004a1ba2: entered by je at 0x004a1b93, 1 instruction(s), falls into the block at 0x004a1ba9
    mov dword ptr [ebp - local_18], 0x0          # 004a1ba2
L_004a1ba9:
    # block 0x004a1ba9: entered by jmp at 0x004a1ba0, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004a1ba9
    mov dword ptr [ebp - local_10], eax          # 004a1bac
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a1baf
    mov eax, dword ptr [ebp - local_10]          # 004a1bb6
    mov ecx, dword ptr [ebp - local_c]           # 004a1bb9
    mov dword ptr fs:[0x0], ecx                  # 004a1bbc
    {load} mov esp, ebp                          # 004a1bc3
    pop ebp                                      # 004a1bc5
    ret                                          # 004a1bc6

