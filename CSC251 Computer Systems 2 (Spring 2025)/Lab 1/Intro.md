# Summary: Measuring Execution Time of Function and System Calls

**Created by:** Caleb Kim  
**Date:** 2/12/24

---

## Overview
This C program compares the execution time of function calls and system calls. It runs a simple function (`foo()`) and various system calls (e.g., `getuid`, `open`, `write`) one million times and measures the time taken using `gettimeofday`.

---

## Key Components

- **Function Call:** `foo()` is a simple function that returns `0`, executed one million times to measure its time.
- **System Calls:** Measures the execution time of system calls like `getuid()`, `open()`, `close()`, `read()`, etc.
- **Time Measurement:** The program uses `gettimeofday` to calculate the execution time in microseconds.

---

## Output
The program prints the time taken for:
- 1 million iterations of `foo()`.
- 1 million iterations of various system calls, showing performance differences.

---

## Conclusion
This program provides insight into the relative costs of function calls vs. system calls, helping to identify performance bottlenecks in C programs.
