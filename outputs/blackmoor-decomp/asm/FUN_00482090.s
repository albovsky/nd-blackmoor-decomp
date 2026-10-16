# FUN_00482090
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482090
# extent:       0x00482090-0x004820fa (106 code bytes)
# span:         0x00482090-0x004820fa (code 106, tables 0, padding 0)
# sha256:       1a5b5874d9df1510c250438d053c2323cbbafd61d6560b72ca0d613b3240350e
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00482090
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0048210a
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
.set FUN_0048210a, .text + (0x0048210a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00482090 - 0x401000
.globl FUN_00482090
FUN_00482090:
    # block 0x00482090: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004820d5 (forward)
    push ebp                                     # 00482090
    {load} mov ebp, esp                          # 00482091
    push -0x1                                    # 00482093
    push 0x5283aa                                # 00482095
    mov eax, dword ptr fs:[0x0]                  # 0048209a
    push eax                                     # 004820a0
    mov dword ptr fs:[0x0], esp                  # 004820a1
    sub esp, 0xc                                 # 004820a8
    push 0xb7                                    # 004820ab
    call FUN_0051dc43                            # 004820b0
    add esp, 0x4                                 # 004820b5
    mov dword ptr [ebp - local_14], eax          # 004820b8
    mov dword ptr [ebp - local_4], 0x0           # 004820bb
    cmp dword ptr [ebp - local_14], 0x0          # 004820c2
    je.d8 L_004820d5                             # 004820c6
    # block 0x004820c8: entered by fall-through of je at 0x004820c6, 4 instruction(s), calls FUN_0048210a, ends with forward jump to 0x004820dc
    mov ecx, dword ptr [ebp - local_14]          # 004820c8
    call FUN_0048210a                            # 004820cb
    mov dword ptr [ebp - local_18], eax          # 004820d0
    jmp.d8 L_004820dc                            # 004820d3
L_004820d5:
    # block 0x004820d5: entered by je at 0x004820c6, 1 instruction(s), falls into the block at 0x004820dc
    mov dword ptr [ebp - local_18], 0x0          # 004820d5
L_004820dc:
    # block 0x004820dc: entered by jmp at 0x004820d3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004820dc
    mov dword ptr [ebp - local_10], eax          # 004820df
    mov dword ptr [ebp - local_4], 0xffffffff    # 004820e2
    mov eax, dword ptr [ebp - local_10]          # 004820e9
    mov ecx, dword ptr [ebp - local_c]           # 004820ec
    mov dword ptr fs:[0x0], ecx                  # 004820ef
    {load} mov esp, ebp                          # 004820f6
    pop ebp                                      # 004820f8
    ret                                          # 004820f9

