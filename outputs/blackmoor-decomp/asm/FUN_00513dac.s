# FUN_00513dac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513dac
# extent:       0x00513dac-0x00513e00 (84 code bytes)
# span:         0x00513dac-0x00513e00 (code 84, tables 0, padding 0)
# sha256:       cd5366e6c73357ec8f5551aef50be277534ac525ba3efc8caf5d4e7d6c561bb4
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513dac
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514467, FUN_0050ea7e, FUN_005146dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_00514467, .text + (0x00514467 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x00513dac - 0x401000
.globl FUN_00513dac
FUN_00513dac:
    # block 0x00513dac: entry, 4 instruction(s), ends with jne to 0x00513de1 (forward)
    push ebp                                     # 00513dac
    {load} mov ebp, esp                          # 00513dad
    cmp dword ptr [0x568e30], 0x0                # 00513daf
    jne.d8 L_00513de1                            # 00513db6
    # block 0x00513db8: entered by fall-through of jne at 0x00513db6, 19 instruction(s), calls FUN_00514467, ends with ret
    push dword ptr [ebp + arg_14]                # 00513db8
    fld qword ptr [ebp + arg_c]                  # 00513dbb
    push ecx                                     # 00513dbe
    push ecx                                     # 00513dbf
    fstp qword ptr [esp]                         # 00513dc0
    push ecx                                     # 00513dc3
    push ecx                                     # 00513dc4
    fldz                                         # 00513dc5
    fstp qword ptr [esp]                         # 00513dc7
    fld qword ptr [ebp + arg_c]                  # 00513dca
    push ecx                                     # 00513dcd
    push ecx                                     # 00513dce
    fstp qword ptr [esp]                         # 00513dcf
    push dword ptr [ebp + arg_8]                 # 00513dd2
    push 0x1                                     # 00513dd5
    call FUN_00514467                            # 00513dd7
    add esp, 0x24                                # 00513ddc
    pop ebp                                      # 00513ddf
    ret                                          # 00513de0
L_00513de1:
    # block 0x00513de1: entered by jne at 0x00513db6, 10 instruction(s), calls FUN_0050ea7e, FUN_005146dc, ends with ret
    call FUN_0050ea7e                            # 00513de1
    push 0xffff                                  # 00513de6
    mov dword ptr [eax], 0x21                    # 00513deb
    push dword ptr [ebp + arg_14]                # 00513df1
    call FUN_005146dc                            # 00513df4
    fld qword ptr [ebp + arg_c]                  # 00513df9
    pop ecx                                      # 00513dfc
    pop ecx                                      # 00513dfd
    pop ebp                                      # 00513dfe
    ret                                          # 00513dff

