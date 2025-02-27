# Summary: File Reading with Forked Processes

**Created by:** Caleb Kim  
**Date:** 2/17/25

---

## Overview
This C program demonstrates file reading with forked processes. It opens a file (`CalebKim.txt`), forks a process, and both the parent and child processes read the file concurrently and print characters.

---

## Key Components

- **File Handling:** The program opens a file (`CalebKim.txt`) and checks for errors.
- **Forking Process:** The program creates a child process using `fork()`.
- **Reading File:** Both the parent and child process read a character or set of characters from the file.
  - The parent and child process each read 1 character and print it.
  - In a second version, both processes read 5 characters into a buffer and print them.

---

## Output
- In the first version, the program prints the first character read by both the parent and child process.
- In the second version, both processes print a sequence of 5 characters read from the file.

---

## Conclusion
This lab demonstrates how parent and child processes work with file descriptors, reading the file in parallel, and handling inter-process communication using the `fork()` system call.
