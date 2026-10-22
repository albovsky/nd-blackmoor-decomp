# FUN_0041b925
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041b925
# extent:       0x0041b925-0x0041b992 (109 code bytes)
# span:         0x0041b925-0x0041b992 (code 109, tables 0, padding 0)
# sha256:       5cabd8b11b064bd07cf6d5c808ec5dfa4a057b07d2191519313448753b672515
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41b925_lifted
# naming:       native port src/original_methods_fl40.c:m41b925_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 29/29 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41b925_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------

.org 0x0041b925 - 0x401000
.globl FUN_0041b925
FUN_0041b925:
    # block 0x0041b925: entry, 6 instruction(s), ends with forward jump to 0x0041b942
    push ebp                                     # 0041b925
    {load} mov ebp, esp                          # 0041b926
    sub esp, 0x8                                 # 0041b928
    mov dword ptr [ebp - local_8], ecx           # 0041b92b
    mov word ptr [ebp - local_4], 0x1001         # 0041b92e
    jmp.d8 L_0041b942                            # 0041b934
L_0041b936:
    # block 0x0041b936: entered by jmp at 0x0041b95c, 3 instruction(s), falls into the block at 0x0041b942
    mov ax, word ptr [ebp - local_4]             # 0041b936
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b93a
    mov word ptr [ebp - local_4], ax             # 0041b93e
L_0041b942:
    # block 0x0041b942: entered by jmp at 0x0041b934, 3 instruction(s), ends with jg to 0x0041b95e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041b942
    cmp ecx, 0x1100                              # 0041b946
    jg.d8 L_0041b95e                             # 0041b94c
    # block 0x0041b94e: entered by fall-through of jg at 0x0041b94c, 3 instruction(s), ends with backward jump to 0x0041b936
    movsx edx, word ptr [ebp - local_4]          # 0041b94e
    mov word ptr [2*edx + 0x56b148], 0x1000      # 0041b952
    jmp.d8 L_0041b936                            # 0041b95c
L_0041b95e:
    # block 0x0041b95e: entered by jg at 0x0041b94c, 2 instruction(s), ends with forward jump to 0x0041b972
    mov word ptr [ebp - local_4], 0x0            # 0041b95e
    jmp.d8 L_0041b972                            # 0041b964
L_0041b966:
    # block 0x0041b966: entered by jmp at 0x0041b98c, 3 instruction(s), falls into the block at 0x0041b972
    mov ax, word ptr [ebp - local_4]             # 0041b966
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b96a
    mov word ptr [ebp - local_4], ax             # 0041b96e
L_0041b972:
    # block 0x0041b972: entered by jmp at 0x0041b964, 3 instruction(s), ends with jge to 0x0041b98e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041b972
    cmp ecx, 0x1000                              # 0041b976
    jge.d8 L_0041b98e                            # 0041b97c
    # block 0x0041b97e: entered by fall-through of jge at 0x0041b97c, 3 instruction(s), ends with backward jump to 0x0041b966
    movsx edx, word ptr [ebp - local_4]          # 0041b97e
    mov word ptr [2*edx + 0x569144], 0x1000      # 0041b982
    jmp.d8 L_0041b966                            # 0041b98c
L_0041b98e:
    # block 0x0041b98e: entered by jge at 0x0041b97c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041b98e
    pop ebp                                      # 0041b990
    ret                                          # 0041b991

