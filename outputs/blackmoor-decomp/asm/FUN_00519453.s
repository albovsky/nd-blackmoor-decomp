# FUN_00519453
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519453
# extent:       0x00519453-0x00519492 (63 code bytes)
# span:         0x00519453-0x00519492 (code 63, tables 0, padding 0)
# sha256:       c7c893fa830f5ae8cdcdcd2dada1f504c91c335aaba0eb5d7233c02690ebeba8
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __mbsnbicoll
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519561
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00519561, .text + (0x00519561 - 0x401000)

.org 0x00519453 - 0x401000
.globl FUN_00519453
FUN_00519453:
    # block 0x00519453: entry, 4 instruction(s), ends with jne to 0x00519460 (forward)
    push ebp                                     # 00519453
    {load} mov ebp, esp                          # 00519454
    cmp dword ptr [ebp + arg_10], 0x0            # 00519456
    jne.d8 L_00519460                            # 0051945a
    # block 0x0051945c: entered by fall-through of jne at 0x0051945a, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051945c
    pop ebp                                      # 0051945e
    ret                                          # 0051945f
L_00519460:
    # block 0x00519460: entered by jne at 0x0051945a, 11 instruction(s), calls FUN_00519561, ends with jne to 0x0051948d (forward)
    push dword ptr [0x63df04]                    # 00519460
    push dword ptr [ebp + arg_10]                # 00519466
    push dword ptr [ebp + arg_c]                 # 00519469
    push dword ptr [ebp + arg_10]                # 0051946c
    push dword ptr [ebp + arg_8]                 # 0051946f
    push 0x1                                     # 00519472
    push dword ptr [0x63e124]                    # 00519474
    call FUN_00519561                            # 0051947a
    add esp, 0x1c                                # 0051947f
    test eax, eax                                # 00519482
    jne.d8 L_0051948d                            # 00519484
    # block 0x00519486: entered by fall-through of jne at 0x00519484, 3 instruction(s), ends with ret
    mov eax, 0x7fffffff                          # 00519486
    pop ebp                                      # 0051948b
    ret                                          # 0051948c
L_0051948d:
    # block 0x0051948d: entered by jne at 0x00519484, 3 instruction(s), ends with ret
    add eax, -0x2                                # 0051948d
    pop ebp                                      # 00519490
    ret                                          # 00519491

