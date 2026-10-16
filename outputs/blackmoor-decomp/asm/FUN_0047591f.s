# FUN_0047591f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047591f
# extent:       0x0047591f-0x00475964 (69 code bytes)
# span:         0x0047591f-0x00475964 (code 69, tables 0, padding 0)
# sha256:       4f0a1022a15d9e79cf8ff4d85922db595eb9b0d4ee4cfda58e92309eaa62531c
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047591f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------

.org 0x0047591f - 0x401000
.globl FUN_0047591f
FUN_0047591f:
    # block 0x0047591f: entry, 7 instruction(s), ends with forward jump to 0x00475946
    push ebp                                     # 0047591f
    {load} mov ebp, esp                          # 00475920
    sub esp, 0x8                                 # 00475922
    mov dword ptr [ebp - local_8], ecx           # 00475925
    mov dword ptr [0x5a0545], 0x0                # 00475928
    mov word ptr [ebp - local_4], 0x0            # 00475932
    jmp.d8 L_00475946                            # 00475938
L_0047593a:
    # block 0x0047593a: entered by jmp at 0x0047595e, 3 instruction(s), falls into the block at 0x00475946
    mov ax, word ptr [ebp - local_4]             # 0047593a
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047593e
    mov word ptr [ebp - local_4], ax             # 00475942
L_00475946:
    # block 0x00475946: entered by jmp at 0x00475938, 3 instruction(s), ends with jge to 0x00475960 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00475946
    cmp ecx, 0x5                                 # 0047594a
    jge.d8 L_00475960                            # 0047594d
    # block 0x0047594f: entered by fall-through of jge at 0x0047594d, 3 instruction(s), ends with backward jump to 0x0047593a
    movsx edx, word ptr [ebp - local_4]          # 0047594f
    mov dword ptr [4*edx + 0x5a0549], 0x0        # 00475953
    jmp.d8 L_0047593a                            # 0047595e
L_00475960:
    # block 0x00475960: entered by jge at 0x0047594d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00475960
    pop ebp                                      # 00475962
    ret                                          # 00475963

