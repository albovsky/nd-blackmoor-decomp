# FUN_0044a0c5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a0c5
# extent:       0x0044a0c5-0x0044a116 (81 code bytes)
# span:         0x0044a0c5-0x0044a116 (code 81, tables 0, padding 0)
# sha256:       0cd5e3c7f09109b520c9c73639cda52fb51f19e7d33b8496703558eb83ced13f
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a0c5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_c, local_68
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d51c0, FUN_0051e140, FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_68, 0x68  # offset -0x68

# --- external targets -----------------------------------------------
.set FUN_004d51c0, .text + (0x004d51c0 - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)
.set FUN_0051e140, .text + (0x0051e140 - 0x401000)

.org 0x0044a0c5 - 0x401000
.globl FUN_0044a0c5
FUN_0044a0c5:
    # block 0x0044a0c5: entry, 22 instruction(s), calls FUN_004d51c0, FUN_0051e140, FUN_0051de13, ends with ret
    push ebp                                     # 0044a0c5
    {load} mov ebp, esp                          # 0044a0c6
    push -0x1                                    # 0044a0c8
    push 0x527f39                                # 0044a0ca
    mov eax, dword ptr fs:[0x0]                  # 0044a0cf
    push eax                                     # 0044a0d5
    mov dword ptr fs:[0x0], esp                  # 0044a0d6
    sub esp, 0x5c                                # 0044a0dd
    push 0x0                                     # 0044a0e0
    lea ecx, [ebp - local_68]                    # 0044a0e2
    call FUN_004d51c0                            # 0044a0e5
    mov dword ptr [ebp - local_4], 0x0           # 0044a0ea
    lea ecx, [ebp - local_68]                    # 0044a0f1
    call FUN_0051e140                            # 0044a0f4
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044a0f9
    lea ecx, [ebp - local_68]                    # 0044a100
    call FUN_0051de13                            # 0044a103
    mov ecx, dword ptr [ebp - local_c]           # 0044a108
    mov dword ptr fs:[0x0], ecx                  # 0044a10b
    {load} mov esp, ebp                          # 0044a112
    pop ebp                                      # 0044a114
    ret                                          # 0044a115

