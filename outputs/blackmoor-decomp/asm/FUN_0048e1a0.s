# FUN_0048e1a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e1a0
# extent:       0x0048e1a0-0x0048e20a (106 code bytes)
# span:         0x0048e1a0-0x0048e20a (code 106, tables 0, padding 0)
# sha256:       4ecf581a1235b40c00c70edbcc67c7d1e95906a1959f4779ed8ac99f804b04d6
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e1a0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0048e21a
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
.set FUN_0048e21a, .text + (0x0048e21a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048e1a0 - 0x401000
.globl FUN_0048e1a0
FUN_0048e1a0:
    # block 0x0048e1a0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0048e1e5 (forward)
    push ebp                                     # 0048e1a0
    {load} mov ebp, esp                          # 0048e1a1
    push -0x1                                    # 0048e1a3
    push 0x5284ea                                # 0048e1a5
    mov eax, dword ptr fs:[0x0]                  # 0048e1aa
    push eax                                     # 0048e1b0
    mov dword ptr fs:[0x0], esp                  # 0048e1b1
    sub esp, 0xc                                 # 0048e1b8
    push 0x4e4                                   # 0048e1bb
    call FUN_0051dc43                            # 0048e1c0
    add esp, 0x4                                 # 0048e1c5
    mov dword ptr [ebp - local_14], eax          # 0048e1c8
    mov dword ptr [ebp - local_4], 0x0           # 0048e1cb
    cmp dword ptr [ebp - local_14], 0x0          # 0048e1d2
    je.d8 L_0048e1e5                             # 0048e1d6
    # block 0x0048e1d8: entered by fall-through of je at 0x0048e1d6, 4 instruction(s), calls FUN_0048e21a, ends with forward jump to 0x0048e1ec
    mov ecx, dword ptr [ebp - local_14]          # 0048e1d8
    call FUN_0048e21a                            # 0048e1db
    mov dword ptr [ebp - local_18], eax          # 0048e1e0
    jmp.d8 L_0048e1ec                            # 0048e1e3
L_0048e1e5:
    # block 0x0048e1e5: entered by je at 0x0048e1d6, 1 instruction(s), falls into the block at 0x0048e1ec
    mov dword ptr [ebp - local_18], 0x0          # 0048e1e5
L_0048e1ec:
    # block 0x0048e1ec: entered by jmp at 0x0048e1e3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0048e1ec
    mov dword ptr [ebp - local_10], eax          # 0048e1ef
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048e1f2
    mov eax, dword ptr [ebp - local_10]          # 0048e1f9
    mov ecx, dword ptr [ebp - local_c]           # 0048e1fc
    mov dword ptr fs:[0x0], ecx                  # 0048e1ff
    {load} mov esp, ebp                          # 0048e206
    pop ebp                                      # 0048e208
    ret                                          # 0048e209

