; CS0003 Computer Systerms & Architecture FINAL PROJECT
; AJ'S TOY STORE (TRANSACTIONAL APPLICATION)
; By Angelika Joy Abendanio

%define MAX_USERS 20
%define USER_SIZE 68
%define PRODUCT_COUNT 59

section .data

    users_file db "users.dat", 0
    stock_file db "stock.dat", 0
    order_file db "orders.txt", 0
    receipt_file db "receipts.txt", 0

    clear_code db 27, '[2J', 27, '[H', 0

    prompt db 10, 'Enter your choice: ', 0
    input_prompt db 'Enter: ', 0
    invalid_msg db 10, 'Invalid input. Please try again.', 10, 0
    pause_msg db 10, 'Press ENTER to continue...', 0

    line db '+======================================================+', 10, 0

    goodbye db 10, "Thank you for visiting AJ's Toy Store!", 10
             db 'Come back and build your collection!', 10, 0

    yes_text db 'YES', 0
    no_text db 'NO', 0
    php_text db 'PHP ', 0
    newline db 10, 0
    separator db '--------------------------------------------------------', 10, 0

    main_screen db '+======================================================+', 10
                db '|                                                      |', 10
                db '|       ______ ______________________________ ______   |', 10
                db '|      /     /  / \   |__   __||_// ___|     /     /   |', 10
                db '|     /  /  /  / _ \     |  |     \____     /  /  /    |', 10
                db '|    /  /  /  / ___ \____|  |      ___ \   /  /  /     |', 10
                db '|   /_____/__/_/___\_\______|_____|____/__/_____/      |', 10
                db '|                                                      |', 10
                db "|              A J ' S   T O Y   S T O R E             |", 10
                db '|                                                      |', 10
                db '|          YOUR HOBBY. YOUR COLLECTION. YOUR WAY.      |', 10
                db '+======================================================+', 10
                db '|                                                      |', 10
                db '|                    MAIN MENU                         |', 10
                db '|                                                      |', 10
                db '|              [1]  Create Account                     |', 10
                db '|              [2]  Customer Login                     |', 10
                db '|              [3]  Exit Store                         |', 10
                db '|                                                      |', 10
                db '+======================================================+', 10, 0


    customer_screen db '+======================================================+', 10
                    db "|                  AJ'S TOY STORE                      |", 10
                    db '|------------------------------------------------------|', 10
                    db '|                  CUSTOMER MENU                       |', 10
                    db '+======================================================+', 10
                    db '|                                                      |', 10
                    db '|       [1] Browse Products                            |', 10
                    db '|       [2] View Shopping Cart                         |', 10
                    db '|       [3] Checkout                                   |', 10
                    db '|       [4] Order History                              |', 10
                    db '|       [5] My Loyalty Rewards                         |', 10
                    db '|       [6] Logout                                     |', 10
                    db '|                                                      |', 10
                    db '+======================================================+', 10, 0


    category_screen db '+======================================================+', 10
                    db "|                  AJ'S TOY STORE                      |", 10
                    db '|------------------------------------------------------|', 10
                    db '|                  PRODUCT CATALOG                     |', 10
                    db '+======================================================+', 10
                    db '|                                                      |', 10
                    db '|  [1] Gunpla Models                                   |', 10
                    db '|  [2] G.I. Joe Classified Series                      |', 10
                    db '|  [3] Tamiya 1/35 WWII Model Kits                     |', 10
                    db '|  [4] Off-road RC Cars                                |', 10
                    db '|  [5] DAMTOYS 1/6 Military Figures                    |', 10
                    db '|  [6] Hobby Tools                                     |', 10
                    db '|  [7] Back to Customer Menu                           |', 10
                    db '|                                                      |', 10
                    db '+======================================================+', 10, 0

    gunpla_screen db '+======================================================+', 10
                  db '|                   GUNPLA MODELS                      |', 10
                  db '+======================================================+', 10
                  db '|                                                      |', 10
                  db '|  [1] Perfect Grade (PG)                              |', 10
                  db '|  [2] Master Grade (MG)                               |', 10
                  db '|  [3] High Grade (HG)                                 |', 10
                  db '|  [4] Back                                            |', 10
                  db '|                                                      |', 10
                  db '+======================================================+', 10, 0

; Product names

    p01 db 'PG Unleashed RX-78-2', 0
    p02 db 'PG Unicorn Gundam', 0
    p03 db 'PG Zeta Gundam', 0
    p04 db 'MG Barbatos', 0
    p05 db 'MG Freedom Gundam', 0
    p06 db 'MG Nu Gundam Ver Ka', 0
    p07 db 'HG RX-78-2', 0
    p08 db 'HG Aerial', 0
    p09 db 'HG Calibarn', 0

    p10 db 'G.I. Joe Duke', 0
    p11 db 'G.I. Joe Snake Eyes', 0
    p12 db 'G.I. Joe Scarlett', 0
    p13 db 'G.I. Joe Storm Shadow', 0
    p14 db 'G.I. Joe Cobra Commander', 0
    p15 db 'G.I. Joe Destro', 0
    p16 db 'G.I. Joe Roadblock', 0
    p17 db 'G.I. Joe Lady Jaye', 0
    p18 db 'G.I. Joe Flint', 0
    p19 db 'G.I. Joe Firefly', 0

    p20 db 'Tamiya Tiger I', 0
    p21 db 'Tamiya Sherman M4', 0
    p22 db 'Tamiya Panzer IV', 0
    p23 db 'Tamiya Panther G', 0
    p24 db 'Tamiya Churchill Mk.VII', 0
    p25 db 'Tamiya German Infantry', 0
    p26 db 'Tamiya US Infantry', 0
    p27 db 'Tamiya Sd.Kfz. 251', 0
    p28 db 'Tamiya Jagdpanther', 0
    p29 db 'Tamiya Tiger II', 0

    p30 db 'Off-road RC Truck A', 0
    p31 db 'Off-road RC Truck B', 0
    p32 db '4WD Rally RC Car', 0
    p33 db 'Desert RC Buggy', 0
    p34 db 'Crawler RC Truck', 0
    p35 db 'Trail RC Car', 0
    p36 db 'Monster RC Truck', 0
    p37 db 'Rock Crawler Set', 0
    p38 db 'Off-road RC Buggy', 0
    p39 db '4x4 RC Adventure Set', 0

    p40 db 'DAMTOYS Modern Soldier', 0
    p41 db 'DAMTOYS Special Forces', 0
    p42 db 'DAMTOYS Sniper Figure', 0
    p43 db 'DAMTOYS Combat Medic', 0
    p44 db 'DAMTOYS Infantry Figure', 0
    p45 db 'DAMTOYS Tactical Operator', 0
    p46 db 'DAMTOYS Military Pilot', 0
    p47 db 'DAMTOYS Field Commander', 0
    p48 db 'DAMTOYS Assault Soldier', 0
    p49 db 'DAMTOYS Recon Soldier', 0

    p50 db 'Plastic Model Nippers', 0
    p51 db 'Hobby Sanding Sticks', 0
    p52 db 'Plastic Cement', 0
    p53 db 'Hobby Primer', 0
    p54 db 'Detailing Paint Brushes', 0
    p55 db 'Model Tweezers', 0
    p56 db 'Hobby Cutting Mat', 0
    p57 db 'Panel Line Tools', 0
    p58 db 'Model Building File Set', 0
    p59 db 'Hobby Tool Kit', 0

; Product data

    product_names dd p01,p02,p03,p04,p05,p06,p07,p08,p09
                  dd p10,p11,p12,p13,p14,p15,p16,p17,p18,p19
                  dd p20,p21,p22,p23,p24,p25,p26,p27,p28,p29
                  dd p30,p31,p32,p33,p34,p35,p36,p37,p38,p39
                  dd p40,p41,p42,p43,p44,p45,p46,p47,p48,p49
                  dd p50,p51,p52,p53,p54,p55,p56,p57,p58,p59

    product_ids dd 101,102,103,201,202,203,301,302,303
                dd 401,402,403,404,405,406,407,408,409,410
                dd 501,502,503,504,505,506,507,508,509,510
                dd 601,602,603,604,605,606,607,608,609,610
                dd 701,702,703,704,705,706,707,708,709,710
                dd 901,902,903,904,905,906,907,908,909,910

    product_prices dd 25000,18500,22000
                   dd 4500,5000,6500
                   dd 1200,1500,1800
                   dd 2500,2800,2600,2900,3000
                   dd 2700,2500,2400,2600,2750
                   dd 3500,3200,3300,3800,3600
                   dd 1800,1800,3000,3700,4200
                   dd 8000,9000,7500,8500,9500
                   dd 7800,8200,10500,8800,11000
                   dd 30000,32000,28500,31000,35000
                   dd 33000,29500,36000,34000,38000
                   dd 900,350,250,650,450
                   dd 300,700,500,400,1800

    product_categories times 9 dd 1
                       times 10 dd 2
                       times 10 dd 3
                       times 10 dd 4
                       times 10 dd 5
                       times 10 dd 6

    product_grades dd 1,1,1,2,2,2,3,3,3
                   times 50 dd 0

; Labels

    category_names dd gunpla_name,gi_name,tamiya_name
                   dd rc_name,dam_name,tools_name

    gunpla_name db 'Gunpla Models',0
    gi_name db 'G.I. Joe Classified Series',0
    tamiya_name db 'Tamiya 1/35 WWII Model Kits',0
    rc_name db 'Off-road RC Cars',0
    dam_name db 'DAMTOYS 1/6 Military Figures',0
    tools_name db 'Hobby Tools',0

    pg_name db 'PERFECT GRADE',0
    mg_name db 'MASTER GRADE',0
    hg_name db 'HIGH GRADE',0


; All messages

    username_prompt db 'Enter username (max 31 characters): ',0
    password_prompt db 'Enter password (max 31 characters): ',0
    login_prompt db 'Enter username: ',0
    login_pass_prompt db 'Enter password: ',0

    registered_msg db 10,'Account successfully created!',10,0
    login_ok_msg db 10,'Login successful. Welcome!',10,0
    login_fail_msg db 10,'Invalid username or password.',10,0
    duplicate_msg db 10,'That username is already registered.',10,0
    user_limit_msg db 10,'Maximum number of accounts reached.',10,0
    length_msg db 10,'Input must contain 1 to 31 characters without spaces.',10,0
    save_error_msg db 10,'Unable to save file.',10,0

    category_prompt db 'Select category: ',0
    grade_prompt db 'Select Gunpla grade: ',0
    product_prompt db 'Enter product ID: ',0
    quantity_prompt db 'Enter quantity: ',0
    remove_prompt db 'Enter product ID to remove: ',0
    remove_qty_prompt db 'Enter quantity to remove: ',0

    delivery_prompt db 10,'DELIVERY LOCATION',10
                    db '[1] Metro Manila - PHP 200',10
                    db '[2] Outside Metro Manila - PHP 500',10
                    db 'Select location: ',0

    add_msg db 10,'Product successfully added to cart.',10,0
    remove_msg db 10,'Product quantity removed from cart.',10,0
    not_found_msg db 10,'Product ID not found.',10,0
    stock_msg db 10,'Not enough stock available.',10,0
    cart_empty_msg db 10,'Your shopping cart is empty.',10,0
    order_cancel_msg db 10,'Checkout cancelled.',10,0
    order_success_msg db 10,'Order successfully completed!',10,0
    history_empty_msg db 10,'No order history found.',10,0
    logout_msg db 10,'You have logged out successfully.',10,0

    confirm_prompt db 10,'[1] Confirm Order',10
                   db '[2] Cancel Order',10
                   db 'Select: ',0

    subtotal_label db 'Merchandise Subtotal: PHP ',0
    delivery_label db 'Delivery Fee: PHP ',0
    total_label db 'TOTAL AMOUNT: PHP ',0
    tokens_label db 'Loyalty Tokens to Earn: ',0
    current_tokens_label db 'Current Loyalty Tokens: ',0

    freebie_label db 'FREEBIE: ',0
    shirt_yes db '1x HOBBY BRANDED T-SHIRT',0
    shirt_no db 'NOT QUALIFIED',0

    receipt_title db '========================================================',10
              db "                    AJ'S TOY STORE",10
              db '                  OFFICIAL SALES RECEIPT',10
              db '========================================================',10,10,0

    receipt_customer db 'Customer: ',0
    receipt_subtotal db 'SUBTOTAL: PHP ',0
    receipt_delivery db 'DELIVERY: PHP ',0
    receipt_total db 'TOTAL: PHP ',0
    receipt_rewards db 10,'REWARDS:',10,'Hobby Branded T-Shirt: ',0
    receipt_tokens db 10,'Loyalty Tokens Earned: ',0

    receipt_thanks db 10,10,"Thank you for shopping at AJ's Toy Store!",10
               db 'Come back and build your collection!',10
               db '========================================================',10,10,0

    history_title db '========================================================',10
                  db '                    ORDER HISTORY',10
                  db '========================================================',10,0

    rewards_title db '+======================================================+',10
                  db '|                  LOYALTY REWARDS                     |',10
                  db '+======================================================+',10,0

    product_title db '                    PRODUCT LIST',10,0
    cart_title db '                    SHOPPING CART',10,0
    checkout_title db '                       CHECKOUT',10,0

    stock_label db '  Stock: ',0
    cart_qty_label db ' x ',0
    cart_price_label db ' = PHP ',0
    customer_label db 'Customer: ',0
    receipt_qty_label db ' | QTY: ',0
    receipt_price_label db ' | PHP ',0
    pipe_label db '|',0

    product_actions db 10,'[1] Add Product to Cart',10
                    db '[2] View Shopping Cart',10
                    db '[3] Back',10,0

    cart_actions db 10,'[1] Add More Products',10
                 db '[2] Remove Product',10
                 db '[3] Proceed to Checkout',10
                 db '[4] Back',10,0

    earn_label db 'Earn 1 token for every PHP 100 spent.',10,0
    tokens_info_label db 'Tokens are added after a successful purchase.',10,0


section .bss

    input_buf resb 128
    temp_name resb 32
    temp_pass resb 32
    num_buf resb 16

    users_data resb MAX_USERS * USER_SIZE
    user_count resd 1
    cur_user resd 1
    user_ptr resd 1

    stock_data resd PRODUCT_COUNT
    cart_data resd PRODUCT_COUNT

    input_len resd 1
    input_num resd 1
    loop_i resd 1
    loop_j resd 1
    found_index resd 1
    wanted_id resd 1
    wanted_qty resd 1

    filter_cat resd 1
    filter_grade resd 1

    subtotal resd 1
    delivery_fee resd 1
    total_amount resd 1
    tokens_earned resd 1
    freebie resd 1

    file_fd resd 1
    receipt_fd resd 1
    out_screen resd 1

    history_buf resb 8192
    history_len resd 1


section .text

global _start

; Macros
%macro PRINT 1
    mov esi, %1
    call print_z
%endmacro

%macro OUT 1
    mov esi, %1
    call out_z
%endmacro


print_z:
    pushad

    mov edi, esi
    xor edx, edx

.next:
    cmp byte [edi], 0
    je .write

    inc edi
    inc edx
    jmp .next

.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80

    popad
    ret


print_num:
    pushad

    mov edi, num_buf + 15
    mov byte [edi], 0
    mov ebx, 10

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'
    jmp .done

.convert:
    xor edx, edx
    div ebx
    add dl, '0'

    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

.done:
    mov esi, edi
    call print_z

    popad
    ret


read_line:
    push ebx
    push ecx
    push edx
    push edi

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 127
    int 0x80

    mov [input_len], eax

    cmp eax, 0
    jle .empty

    mov edi, input_buf
    mov ecx, eax

.scan:
    cmp byte [edi], 10
    je .end

    cmp byte [edi], 13
    je .end

    inc edi
    loop .scan

.end:
    mov byte [edi], 0
    jmp .done

.empty:
    mov byte [input_buf], 0

.done:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret


to_number:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, input_buf
    xor eax, eax
    xor ecx, ecx

.next:
    mov bl, [esi]

    cmp bl, 0
    je .done

    cmp bl, '0'
    jb .invalid

    cmp bl, '9'
    ja .invalid

    imul eax, eax, 10

    movzx edx, bl
    sub edx, '0'
    add eax, edx

    inc esi
    inc ecx
    jmp .next

.done:
    cmp ecx, 0
    je .invalid

    jmp .finish

.invalid:
    mov eax, -1

.finish:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret


get_number:
    call print_z
    call read_line
    call to_number
    ret


clear_screen:
    PRINT clear_code
    ret


pause_program:
    PRINT pause_msg
    call read_line
    ret


string_length:
    push edi

    mov edi, esi
    xor eax, eax

.next:
    cmp byte [edi], 0
    je .done

    inc edi
    inc eax
    jmp .next

.done:
    pop edi
    ret


copy_string:
    push eax
    push ecx

    mov ecx, 31

.next:
    mov al, [esi]

    cmp al, 0
    je .done

    mov [edi], al

    inc esi
    inc edi
    loop .next

.done:
    mov byte [edi], 0

    pop ecx
    pop eax
    ret


compare_string:
    push ebx

.next:
    mov al, [esi]
    mov bl, [edi]

    cmp al, bl
    jne .not_equal

    cmp al, 0
    je .equal

    inc esi
    inc edi
    jmp .next

.equal:
    mov eax, 1
    jmp .done

.not_equal:
    xor eax, eax

.done:
    pop ebx
    ret


check_account_input:
    mov esi, input_buf
    call string_length

    cmp eax, 1
    jb .invalid

    cmp eax, 31
    ja .invalid

    mov esi, input_buf

.check:
    mov al, [esi]

    cmp al, 0
    je .valid

    cmp al, ' '
    je .invalid

    inc esi
    jmp .check

.valid:
    mov eax, 1
    ret

.invalid:
    xor eax, eax
    ret


load_users:
    mov dword [user_count], 0

    mov eax, 5
    mov ebx, users_file
    mov ecx, 0
    int 0x80

    test eax, eax
    js .done

    mov [file_fd], eax

    mov eax, 3
    mov ebx, [file_fd]
    mov ecx, users_data
    mov edx, MAX_USERS * USER_SIZE
    int 0x80

    cmp eax, 0
    jle .close

    xor edx, edx
    mov ecx, USER_SIZE
    div ecx

    mov [user_count], eax

.close:
    mov eax, 6
    mov ebx, [file_fd]
    int 0x80

.done:
    ret


save_users:
    mov eax, 5
    mov ebx, users_file
    mov ecx, 577
    mov edx, 420
    int 0x80

    test eax, eax
    js .done

    mov [file_fd], eax

    mov eax, [user_count]
    imul eax, USER_SIZE

    mov edx, eax
    mov eax, 4
    mov ebx, [file_fd]
    mov ecx, users_data
    int 0x80

    mov eax, 6
    mov ebx, [file_fd]
    int 0x80

.done:
    ret


load_stock:
    mov edi, stock_data
    mov ecx, PRODUCT_COUNT
    mov eax, 5

    cld
    rep stosd

    mov eax, 5
    mov ebx, stock_file
    mov ecx, 0
    int 0x80

    test eax, eax
    js .done

    mov [file_fd], eax

    mov eax, 3
    mov ebx, [file_fd]
    mov ecx, stock_data
    mov edx, PRODUCT_COUNT * 4
    int 0x80

    mov eax, 6
    mov ebx, [file_fd]
    int 0x80

.done:
    ret


save_stock:
    mov eax, 5
    mov ebx, stock_file
    mov ecx, 577
    mov edx, 420
    int 0x80

    test eax, eax
    js .done

    mov [file_fd], eax

    mov eax, 4
    mov ebx, [file_fd]
    mov ecx, stock_data
    mov edx, PRODUCT_COUNT * 4
    int 0x80

    mov eax, 6
    mov ebx, [file_fd]
    int 0x80

.done:
    ret


; Current User

set_user_pointer:
    mov eax, [cur_user]
    imul eax, USER_SIZE

    lea eax, [users_data + eax]
    mov [user_ptr], eax
    ret


register_account:
    call clear_screen

    mov eax, [user_count]
    cmp eax, MAX_USERS
    jae .limit

    PRINT username_prompt
    call read_line
    call check_account_input

    cmp eax, 1
    jne .invalid

    mov esi, input_buf
    mov edi, temp_name
    call copy_string

    xor ebx, ebx

.check_duplicate:
    cmp ebx, [user_count]
    jae .password

    mov eax, ebx
    imul eax, USER_SIZE

    lea edi, [users_data + eax]
    mov esi, temp_name
    call compare_string

    cmp eax, 1
    je .duplicate

    inc ebx
    jmp .check_duplicate

.password:
    PRINT password_prompt
    call read_line
    call check_account_input

    cmp eax, 1
    jne .invalid

    mov esi, input_buf
    mov edi, temp_pass
    call copy_string

    mov eax, [user_count]
    imul eax, USER_SIZE

    lea edi, [users_data + eax]
    mov esi, temp_name
    call copy_string

    mov eax, [user_count]
    imul eax, USER_SIZE

    lea edi, [users_data + eax + 32]
    mov esi, temp_pass
    call copy_string

    mov eax, [user_count]
    imul eax, USER_SIZE

    mov dword [users_data + eax + 64], 0

    inc dword [user_count]

    call save_users

    PRINT registered_msg
    call pause_program
    jmp main_menu

.duplicate:
    PRINT duplicate_msg
    call pause_program
    jmp main_menu

.limit:
    PRINT user_limit_msg
    call pause_program
    jmp main_menu

.invalid:
    PRINT length_msg
    call pause_program
    jmp main_menu


customer_login:
    call clear_screen

    PRINT login_prompt
    call read_line

    mov esi, input_buf
    mov edi, temp_name
    call copy_string

    PRINT login_pass_prompt
    call read_line

    mov esi, input_buf
    mov edi, temp_pass
    call copy_string

    xor ebx, ebx

.check:
    cmp ebx, [user_count]
    jae .failed

    mov eax, ebx
    imul eax, USER_SIZE

    lea edi, [users_data + eax]
    mov esi, temp_name
    call compare_string

    cmp eax, 1
    jne .next

    mov eax, ebx
    imul eax, USER_SIZE

    lea edi, [users_data + eax + 32]
    mov esi, temp_pass
    call compare_string

    cmp eax, 1
    je .success

.next:
    inc ebx
    jmp .check

.failed:
    PRINT login_fail_msg
    call pause_program
    jmp main_menu

.success:
    mov [cur_user], ebx
    call set_user_pointer

    mov edi, cart_data
    mov ecx, PRODUCT_COUNT
    xor eax, eax

    cld
    rep stosd

    PRINT login_ok_msg
    call pause_program
    jmp customer_menu


; Main Program
_start:
    mov dword [cur_user], -1
    mov dword [receipt_fd], -1
    mov dword [out_screen], 1

    call load_users
    call load_stock

main_menu:
    call clear_screen
    PRINT main_screen

    mov esi, prompt
    call get_number

    cmp eax, 1
    je register_account

    cmp eax, 2
    je customer_login

    cmp eax, 3
    je exit_program

    PRINT invalid_msg
    call pause_program
    jmp main_menu


customer_menu:
    call clear_screen
    PRINT customer_screen

    PRINT customer_label
    mov esi, [user_ptr]
    call print_z
    PRINT newline

    PRINT current_tokens_label
    mov edi, [user_ptr]
    mov eax, [edi + 64]
    call print_num
    PRINT newline

    mov esi, prompt
    call get_number

    cmp eax, 1
    je browse_categories

    cmp eax, 2
    je shopping_cart

    cmp eax, 3
    je checkout

    cmp eax, 4
    je order_history

    cmp eax, 5
    je loyalty_rewards

    cmp eax, 6
    je logout

    PRINT invalid_msg
    call pause_program
    jmp customer_menu


browse_categories:
    call clear_screen
    PRINT category_screen

    mov esi, category_prompt
    call get_number

    cmp eax, 1
    je gunpla_menu

    cmp eax, 2
    je browse_gi

    cmp eax, 3
    je browse_tamiya

    cmp eax, 4
    je browse_rc

    cmp eax, 5
    je browse_dam

    cmp eax, 6
    je browse_tools

    cmp eax, 7
    je customer_menu

    PRINT invalid_msg
    call pause_program
    jmp browse_categories


gunpla_menu:
    call clear_screen
    PRINT gunpla_screen

    mov esi, grade_prompt
    call get_number

    cmp eax, 1
    je browse_pg

    cmp eax, 2
    je browse_mg

    cmp eax, 3
    je browse_hg

    cmp eax, 4
    je browse_categories

    PRINT invalid_msg
    call pause_program
    jmp gunpla_menu

browse_pg:
    mov dword [filter_cat], 1
    mov dword [filter_grade], 1
    jmp product_menu

browse_mg:
    mov dword [filter_cat], 1
    mov dword [filter_grade], 2
    jmp product_menu

browse_hg:
    mov dword [filter_cat], 1
    mov dword [filter_grade], 3
    jmp product_menu

browse_gi:
    mov dword [filter_cat], 2
    mov dword [filter_grade], 0
    jmp product_menu

browse_tamiya:
    mov dword [filter_cat], 3
    mov dword [filter_grade], 0
    jmp product_menu

browse_rc:
    mov dword [filter_cat], 4
    mov dword [filter_grade], 0
    jmp product_menu

browse_dam:
    mov dword [filter_cat], 5
    mov dword [filter_grade], 0
    jmp product_menu

browse_tools:
    mov dword [filter_cat], 6
    mov dword [filter_grade], 0
    jmp product_menu


show_products:
    mov dword [loop_i], 0

.next:
    mov ebx, [loop_i]
    cmp ebx, PRODUCT_COUNT
    jae .done

    mov eax, [product_categories + ebx*4]
    cmp eax, [filter_cat]
    jne .skip

    cmp dword [filter_cat], 1
    jne .display

    mov eax, [product_grades + ebx*4]
    cmp eax, [filter_grade]
    jne .skip

.display:
    mov eax, [product_ids + ebx*4]
    call print_num

    PRINT cart_qty_label

    mov esi, [product_names + ebx*4]
    call print_z

    PRINT newline
    PRINT php_text

    mov eax, [product_prices + ebx*4]
    call print_num

    PRINT stock_label

    mov eax, [stock_data + ebx*4]
    call print_num

    PRINT newline
    PRINT separator

.skip:
    inc dword [loop_i]
    jmp .next

.done:
    ret


product_menu:
    call clear_screen
    PRINT line

    cmp dword [filter_cat], 1
    jne .other

    cmp dword [filter_grade], 1
    je .pg

    cmp dword [filter_grade], 2
    je .mg

    PRINT hg_name
    jmp .heading_done

.pg:
    PRINT pg_name
    jmp .heading_done

.mg:
    PRINT mg_name
    jmp .heading_done

.other:
    mov ebx, [filter_cat]
    dec ebx
    mov esi, [category_names + ebx*4]
    call print_z

.heading_done:
    PRINT newline
    PRINT line

    call show_products
    PRINT product_actions

    mov esi, prompt
    call get_number

    cmp eax, 1
    je add_product

    cmp eax, 2
    je shopping_cart

    cmp eax, 3
    je .back

    PRINT invalid_msg
    call pause_program
    jmp product_menu

.back:
    cmp dword [filter_cat], 1
    je gunpla_menu

    jmp browse_categories


find_product:
    mov [wanted_id], eax
    xor ebx, ebx

.next:
    cmp ebx, PRODUCT_COUNT
    jae .not_found

    mov eax, [product_ids + ebx*4]
    cmp eax, [wanted_id]
    je .found

    inc ebx
    jmp .next

.found:
    mov eax, ebx
    ret

.not_found:
    mov eax, -1
    ret


add_product:
    mov esi, product_prompt
    call get_number

    cmp eax, 0
    jle .invalid

    call find_product

    cmp eax, -1
    je .not_found

    mov [found_index], eax
    mov ebx, eax

    mov eax, [product_categories + ebx*4]
    cmp eax, [filter_cat]
    jne .not_found

    cmp dword [filter_cat], 1
    jne .quantity

    mov eax, [product_grades + ebx*4]
    cmp eax, [filter_grade]
    jne .not_found

.quantity:
    mov esi, quantity_prompt
    call get_number

    cmp eax, 0
    jle .invalid

    mov [wanted_qty], eax
    mov ebx, [found_index]

    mov eax, [stock_data + ebx*4]
    sub eax, [cart_data + ebx*4]

    cmp [wanted_qty], eax
    ja .stock_error

    mov eax, [wanted_qty]
    add [cart_data + ebx*4], eax

    PRINT add_msg
    call pause_program
    jmp product_menu

.stock_error:
    PRINT stock_msg
    call pause_program
    jmp product_menu

.not_found:
    PRINT not_found_msg
    call pause_program
    jmp product_menu

.invalid:
    PRINT invalid_msg
    call pause_program
    jmp product_menu


calculate_subtotal:
    mov dword [subtotal], 0
    xor ebx, ebx

.next:
    cmp ebx, PRODUCT_COUNT
    jae .done

    mov eax, [product_prices + ebx*4]
    imul eax, [cart_data + ebx*4]
    add [subtotal], eax

    inc ebx
    jmp .next

.done:
    ret


shopping_cart:
    call clear_screen
    PRINT line
    PRINT cart_title
    PRINT line

    call calculate_subtotal

    mov dword [loop_i], 0
    mov dword [loop_j], 0

.next:
    mov ebx, [loop_i]
    cmp ebx, PRODUCT_COUNT
    jae .done

    mov eax, [cart_data + ebx*4]
    cmp eax, 0
    je .skip

    inc dword [loop_j]

    mov eax, [product_ids + ebx*4]
    call print_num

    PRINT cart_qty_label

    mov esi, [product_names + ebx*4]
    call print_z

    PRINT newline
    PRINT cart_qty_label

    mov eax, [cart_data + ebx*4]
    call print_num

    PRINT cart_price_label

    mov eax, [product_prices + ebx*4]
    imul eax, [cart_data + ebx*4]
    call print_num

    PRINT newline

.skip:
    inc dword [loop_i]
    jmp .next

.done:
    cmp dword [loop_j], 0
    jne .total

    PRINT cart_empty_msg

.total:
    PRINT separator
    PRINT subtotal_label

    mov eax, [subtotal]
    call print_num

    PRINT newline
    PRINT cart_actions

    mov esi, prompt
    call get_number

    cmp eax, 1
    je browse_categories

    cmp eax, 2
    je remove_product

    cmp eax, 3
    je checkout

    cmp eax, 4
    je customer_menu

    PRINT invalid_msg
    call pause_program
    jmp shopping_cart


remove_product:
    mov esi, remove_prompt
    call get_number

    cmp eax, 0
    jle .invalid

    call find_product

    cmp eax, -1
    je .not_found

    mov [found_index], eax
    mov ebx, eax

    cmp dword [cart_data + ebx*4], 0
    je .not_found

    mov esi, remove_qty_prompt
    call get_number

    cmp eax, 0
    jle .invalid

    mov ebx, [found_index]
    cmp eax, [cart_data + ebx*4]
    ja .invalid

    sub [cart_data + ebx*4], eax

    PRINT remove_msg
    call pause_program
    jmp shopping_cart

.not_found:
    PRINT not_found_msg
    call pause_program
    jmp shopping_cart

.invalid:
    PRINT invalid_msg
    call pause_program
    jmp shopping_cart


checkout:
    call calculate_subtotal

    cmp dword [subtotal], 0
    je .empty

    call clear_screen
    PRINT line
    PRINT checkout_title
    PRINT line

    PRINT customer_label
    mov esi, [user_ptr]
    call print_z
    PRINT newline

    PRINT delivery_prompt
    call read_line
    call to_number

    cmp eax, 1
    je .metro

    cmp eax, 2
    je .outside

    PRINT invalid_msg
    call pause_program
    jmp checkout

.metro:
    mov dword [delivery_fee], 200
    jmp .calculate

.outside:
    mov dword [delivery_fee], 500

.calculate:
    mov eax, [subtotal]
    add eax, [delivery_fee]
    mov [total_amount], eax

    mov eax, [subtotal]
    xor edx, edx
    mov ebx, 100
    div ebx
    mov [tokens_earned], eax

    mov dword [freebie], 0

    cmp dword [subtotal], 10000
    jb .display

    mov dword [freebie], 1

.display:
    PRINT newline
    PRINT subtotal_label
    mov eax, [subtotal]
    call print_num

    PRINT newline
    PRINT delivery_label
    mov eax, [delivery_fee]
    call print_num

    PRINT newline
    PRINT separator
    PRINT total_label
    mov eax, [total_amount]
    call print_num

    PRINT newline
    PRINT freebie_label

    cmp dword [freebie], 1
    jne .no_shirt

    PRINT shirt_yes
    jmp .tokens

.no_shirt:
    PRINT shirt_no

.tokens:
    PRINT newline
    PRINT tokens_label
    mov eax, [tokens_earned]
    call print_num

    PRINT newline
    PRINT confirm_prompt

    call read_line
    call to_number

    cmp eax, 1
    je complete_order

    cmp eax, 2
    je .cancel

    PRINT invalid_msg
    call pause_program
    jmp checkout

.empty:
    PRINT cart_empty_msg
    call pause_program
    jmp customer_menu

.cancel:
    PRINT order_cancel_msg
    call pause_program
    jmp customer_menu


complete_order:
    xor ebx, ebx

.check_stock:
    cmp ebx, PRODUCT_COUNT
    jae .stock_ok

    mov eax, [cart_data + ebx*4]
    cmp eax, [stock_data + ebx*4]
    ja .stock_error

    inc ebx
    jmp .check_stock

.stock_ok:
    xor ebx, ebx

.update_stock:
    cmp ebx, PRODUCT_COUNT
    jae .update_tokens

    mov eax, [cart_data + ebx*4]
    sub [stock_data + ebx*4], eax

    inc ebx
    jmp .update_stock

.update_tokens:
    mov edi, [user_ptr]
    mov eax, [tokens_earned]
    add [edi + 64], eax

    call save_users
    call save_stock

    call print_receipt
    call save_order

    mov edi, cart_data
    mov ecx, PRODUCT_COUNT
    xor eax, eax
    cld
    rep stosd

    PRINT order_success_msg
    call pause_program
    jmp customer_menu

.stock_error:
    PRINT stock_msg
    call pause_program
    jmp shopping_cart


out_z:
    pushad

    mov edi, esi
    xor edx, edx

.length:
    cmp byte [edi], 0
    je .write

    inc edi
    inc edx
    jmp .length

.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80

    cmp dword [receipt_fd], 0
    jl .done

    mov eax, 4
    mov ebx, [receipt_fd]
    mov ecx, esi
    int 0x80

.done:
    popad
    ret


out_num:
    pushad

    mov edi, num_buf + 15
    mov byte [edi], 0
    mov ebx, 10

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'
    jmp .done

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

.done:
    mov esi, edi
    call out_z

    popad
    ret


print_receipt:
    call clear_screen

    mov eax, 5
    mov ebx, receipt_file
    mov ecx, 1089
    mov edx, 420
    int 0x80

    mov [receipt_fd], eax

    OUT receipt_title
    OUT receipt_customer

    mov esi, [user_ptr]
    call out_z

    OUT newline
    OUT separator

    mov dword [loop_i], 0

.next:
    mov ebx, [loop_i]
    cmp ebx, PRODUCT_COUNT
    jae .totals

    cmp dword [cart_data + ebx*4], 0
    je .skip

    mov esi, [product_names + ebx*4]
    call out_z

    OUT receipt_qty_label

    mov eax, [cart_data + ebx*4]
    call out_num

    OUT receipt_price_label

    mov eax, [product_prices + ebx*4]
    imul eax, [cart_data + ebx*4]
    call out_num

    OUT newline

.skip:
    inc dword [loop_i]
    jmp .next

.totals:
    OUT separator
    OUT receipt_subtotal

    mov eax, [subtotal]
    call out_num

    OUT newline
    OUT receipt_delivery

    mov eax, [delivery_fee]
    call out_num

    OUT newline
    OUT receipt_total

    mov eax, [total_amount]
    call out_num

    OUT receipt_rewards

    cmp dword [freebie], 1
    jne .no_shirt

    OUT shirt_yes
    jmp .tokens

.no_shirt:
    OUT shirt_no

.tokens:
    OUT receipt_tokens

    mov eax, [tokens_earned]
    call out_num

    OUT receipt_thanks

    cmp dword [receipt_fd], 0
    jl .done

    mov eax, 6
    mov ebx, [receipt_fd]
    int 0x80

.done:
    mov dword [receipt_fd], -1
    ret


save_order:
    mov eax, 5
    mov ebx, order_file
    mov ecx, 1089
    mov edx, 420
    int 0x80

    test eax, eax
    js .done

    mov [receipt_fd], eax

    mov esi, [user_ptr]
    call file_string

    mov esi, pipe_label
    call file_string

    mov eax, [subtotal]
    call file_number

    mov esi, pipe_label
    call file_string

    mov eax, [delivery_fee]
    call file_number

    mov esi, pipe_label
    call file_string

    mov eax, [total_amount]
    call file_number

    mov esi, pipe_label
    call file_string

    mov eax, [tokens_earned]
    call file_number

    mov esi, pipe_label
    call file_string

    cmp dword [freebie], 1
    jne .no_shirt

    mov esi, yes_text
    call file_string
    jmp .end_record

.no_shirt:
    mov esi, no_text
    call file_string

.end_record:
    mov esi, newline
    call file_string

    mov eax, 6
    mov ebx, [receipt_fd]
    int 0x80

    mov dword [receipt_fd], -1

.done:
    ret


file_string:
    pushad

    mov edi, esi
    xor edx, edx

.length:
    cmp byte [edi], 0
    je .write

    inc edi
    inc edx
    jmp .length

.write:
    mov eax, 4
    mov ebx, [receipt_fd]
    mov ecx, esi
    int 0x80

    popad
    ret


file_number:
    pushad

    mov edi, num_buf + 15
    mov byte [edi], 0
    mov ebx, 10

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'
    jmp .done

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

.done:
    mov esi, edi
    call file_string

    popad
    ret


order_history:
    call clear_screen
    PRINT history_title

    mov eax, 5
    mov ebx, order_file
    mov ecx, 0
    int 0x80

    test eax, eax
    js .empty

    mov [file_fd], eax
    mov dword [loop_j], 0

.read:
    mov eax, 3
    mov ebx, [file_fd]
    mov ecx, history_buf
    mov edx, 8191
    int 0x80

    cmp eax, 0
    jle .close

    mov [history_len], eax
    inc dword [loop_j]

    mov eax, 4
    mov ebx, 1
    mov ecx, history_buf
    mov edx, [history_len]
    int 0x80

    jmp .read

.close:
    mov eax, 6
    mov ebx, [file_fd]
    int 0x80

    cmp dword [loop_j], 0
    je .empty

    call pause_program
    jmp customer_menu

.empty:
    PRINT history_empty_msg
    call pause_program
    jmp customer_menu


loyalty_rewards:
    call clear_screen
    PRINT rewards_title

    PRINT current_tokens_label

    mov edi, [user_ptr]
    mov eax, [edi + 64]
    call print_num

    PRINT newline
    PRINT earn_label
    PRINT tokens_info_label

    call pause_program
    jmp customer_menu


logout:
    mov dword [cur_user], -1
    mov dword [user_ptr], 0

    mov edi, cart_data
    mov ecx, PRODUCT_COUNT
    xor eax, eax
    cld
    rep stosd

    call clear_screen
    PRINT logout_msg

    call pause_program
    jmp main_menu


exit_program:
    call clear_screen
    PRINT goodbye

    mov eax, 1
    xor ebx, ebx
    int 0x80
