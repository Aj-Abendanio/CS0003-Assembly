# AJ's Toy Store

**A Console Based Transactional Shopping Application using NASM Assembly**

AJ's Toy Store is my final project for Computer System and Architecture. It is a simple shopping application developed using 32-bit NASM Assembly that allows users to browse hobby products, manage their shopping cart and complete transactions.

## Features
- Customer Registration and Login
- 59 Products and 6 Categories
- Shopping Cart and Inventory Management
- Checkout and Delivery Fee Calculation
- Free Branded T-Shirt for Orders Worth PHP 10,000+
- Loyalty Tokens System
- Receipt Generation and Order History
- File Handling (Read and Write)

## How to Run
**Requirements:** NASM and a 32-bit compatible Linux environment (Docker or Ubuntu).
```bash
nasm -f elf32 AJToyStore.asm -o AJToyStore.o
ld -m elf_i386 AJToyStore.o -o AJToyStore
./AJToyStore
```

## File Handling
The program creates and uses the following files:
- `users.dat` – Customer accounts
- `stock.dat` – Product inventory
- `orders.txt` – Transaction records
- `receipts.txt` – Sales receipts

## Developer
**Angelika Joy A. Abendanio**  
CS0003 Computer System and Architecture Final Project  
November 13, 2026
