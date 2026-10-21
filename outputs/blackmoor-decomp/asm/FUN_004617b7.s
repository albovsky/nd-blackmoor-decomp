# FUN_004617b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004617b7
# extent:       0x004617b7-0x0046180b (84 code bytes)
# span:         0x004617b7-0x0046180b (code 84, tables 0, padding 0)
# sha256:       75edb31c9589d40bea855464968e8db790bbdee0c638af21f6023ac0bd8510af
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4617b7_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4617b7_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d080u at [this], calls 0x461827(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00461827
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4617b7_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00461827, .text + (0x00461827 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004617b7 - 0x401000
.globl FUN_004617b7
FUN_004617b7:
    # block 0x004617b7: entry, 23 instruction(s), calls FUN_0051d716, FUN_00461827, ends with ret
    push ebp                                     # 004617b7
    {load} mov ebp, esp                          # 004617b8
    push -0x1                                    # 004617ba
    push 0x52812d                                # 004617bc
    mov eax, dword ptr fs:[0x0]                  # 004617c1
    push eax                                     # 004617c7
    mov dword ptr fs:[0x0], esp                  # 004617c8
    push ecx                                     # 004617cf
    mov dword ptr [ebp - local_10], ecx          # 004617d0
    mov ecx, dword ptr [ebp - local_10]          # 004617d3
    call FUN_0051d716                            # 004617d6
    mov dword ptr [ebp - local_4], 0x0           # 004617db
    mov eax, dword ptr [ebp - local_10]          # 004617e2
    mov dword ptr [eax], 0x52d080                # 004617e5
    mov ecx, dword ptr [ebp - local_10]          # 004617eb
    call FUN_00461827                            # 004617ee
    mov dword ptr [ebp - local_4], 0xffffffff    # 004617f3
    mov eax, dword ptr [ebp - local_10]          # 004617fa
    mov ecx, dword ptr [ebp - local_c]           # 004617fd
    mov dword ptr fs:[0x0], ecx                  # 00461800
    {load} mov esp, ebp                          # 00461807
    pop ebp                                      # 00461809
    ret                                          # 0046180a

