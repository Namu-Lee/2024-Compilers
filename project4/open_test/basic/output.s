        shift_sp 1
        push_const EXIT
        push_reg fp
        push_reg sp
        pop_reg fp
        jump main
EXIT:
        exit
main:
main_start:
str_0. string "hello world\n"
        push_const str_0
        write_string
        push_reg fp
        push_const -1
        add
        push_const -1
        add
        push_const 0
        assign
        jump main_final
main_final:
        push_reg fp
        pop_reg sp
        pop_reg fp
        pop_reg pc
main_end:
Lglob.  data 0
