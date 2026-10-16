# FUN_005139ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005139ae
# extent:       0x005139ae-0x005139ea (60 code bytes)
# span:         0x005139ae-0x005139f0 (code 60, tables 0, padding 6)
# sha256:       b146371d2e644aa9a70ff0395feabad7b737b1b7e7e3672fd6c565d6a7bb689e
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005139ae
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_e; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_2, local_6, local_a
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2
.equ local_6, 0x6  # offset -0x6
.equ local_a, 0xa  # offset -0xa
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------

.org 0x005139ae - 0x401000
.globl FUN_005139ae
FUN_005139ae:
    # block 0x005139ae: entry, 9 instruction(s), ends with jne to 0x005139e4 (forward)
    push ebp                                     # 005139ae
    {load} mov ebp, esp                          # 005139af
    add esp, -0xc                                # 005139b1
    push ebx                                     # 005139b4
    mov ax, word ptr [ebp + arg_e]               # 005139b5
    {load} mov bx, ax                            # 005139b9
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 005139bc
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 005139c0
    jne.d8 L_005139e4                            # 005139c4
    # block 0x005139c6: entered by fall-through of jne at 0x005139c4, 9 instruction(s), ends with forward jump to 0x005139e7
    .insn 0x6681/1, ebx, 32767{:s16}             # 005139c6
    mov word ptr [ebp - local_2], bx             # 005139cb
    mov eax, dword ptr [ebp + arg_c]             # 005139cf
    mov ebx, dword ptr [ebp + arg_8]             # 005139d2
    shld eax, ebx, 0xb                           # 005139d5
    mov dword ptr [ebp - local_6], eax           # 005139d9
    mov dword ptr [ebp - local_a], ebx           # 005139dc
    fld tbyte ptr [ebp - local_a]                # 005139df
    jmp.d8 L_005139e7                            # 005139e2
L_005139e4:
    # block 0x005139e4: entered by jne at 0x005139c4, 1 instruction(s), falls into the block at 0x005139e7
    fld qword ptr [ebp + arg_8]                  # 005139e4
L_005139e7:
    # block 0x005139e7: entered by jmp at 0x005139e2, 3 instruction(s), ends with ret
    pop ebx                                      # 005139e7
    leave                                        # 005139e8
    ret                                          # 005139e9

# --- data items (not part of the function) -------------------------
.org 0x005139ea - 0x401000
PAD_005139ea:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

