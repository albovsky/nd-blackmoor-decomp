# FUN_0044a116
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a116
# extent:       0x0044a116-0x0044a177 (97 code bytes)
# span:         0x0044a116-0x0044a177 (code 97, tables 0, padding 0)
# sha256:       72b8438549475c3ddcb05444b6342fca2e93389e7729d1467548d24f44e2de48
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a116
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0bc, KERNEL32.dll!GetLogicalDrives
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44a116_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)

.org 0x0044a116 - 0x401000
.globl FUN_0044a116
FUN_0044a116:
    # block 0x0044a116: entry, 17 instruction(s), calls FUN_0050d0bc, KERNEL32.dll!GetLogicalDrives, ends with jne to 0x0044a14b (forward)
    push ebp                                     # 0044a116
    {load} mov ebp, esp                          # 0044a117
    sub esp, 0x10                                # 0044a119
    {load} xor eax, eax                          # 0044a11c
    mov dword ptr [ebp - local_8], eax           # 0044a11e
    mov byte ptr [ebp - local_4], al             # 0044a121
    mov ecx, dword ptr [ebp + arg_8]             # 0044a124
    mov dl, byte ptr [ecx]                       # 0044a127
    mov byte ptr [ebp - local_8], dl             # 0044a129
    lea eax, [ebp - local_8]                     # 0044a12c
    push eax                                     # 0044a12f
    call FUN_0050d0bc                            # 0044a130
    add esp, 0x4                                 # 0044a135
    call dword ptr [0x52a274]                    # 0044a138
    mov dword ptr [ebp - local_10], eax          # 0044a13e
    cmp dword ptr [ebp - local_10], 0x0          # 0044a141
    jne.d8 L_0044a14b                            # 0044a145
    # block 0x0044a147: entered by fall-through of jne at 0x0044a145, 2 instruction(s), ends with forward jump to 0x0044a173
    {load} xor al, al                            # 0044a147
    jmp.d8 L_0044a173                            # 0044a149
L_0044a14b:
    # block 0x0044a14b: entered by jne at 0x0044a145, 10 instruction(s), ends with je to 0x0044a171 (forward)
    mov dword ptr [ebp - local_c], 0x0           # 0044a14b
    movsx ecx, byte ptr [ebp - local_8]          # 0044a152
    sub ecx, 0x41                                # 0044a156
    mov edx, 0x1                                 # 0044a159
    shl edx, cl                                  # 0044a15e
    mov dword ptr [ebp - local_c], edx           # 0044a160
    mov eax, dword ptr [ebp - local_10]          # 0044a163
    and eax, dword ptr [ebp - local_c]           # 0044a166
    test eax, eax                                # 0044a169
    je.d8 L_0044a171                             # 0044a16b
    # block 0x0044a16d: entered by fall-through of je at 0x0044a16b, 2 instruction(s), ends with forward jump to 0x0044a173
    mov al, 0x1                                  # 0044a16d
    jmp.d8 L_0044a173                            # 0044a16f
L_0044a171:
    # block 0x0044a171: entered by je at 0x0044a16b, 1 instruction(s), falls into the block at 0x0044a173
    {load} xor al, al                            # 0044a171
L_0044a173:
    # block 0x0044a173: entered by jmp at 0x0044a149; jmp at 0x0044a16f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044a173
    pop ebp                                      # 0044a175
    ret                                          # 0044a176

