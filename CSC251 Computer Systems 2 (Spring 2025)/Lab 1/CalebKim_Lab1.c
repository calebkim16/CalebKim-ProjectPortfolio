//
// Created by Caleb Kim on 2/12/24
//

#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int foo(){
    return(0);
}

void measure_function_call() {
    struct timeval start_Time, end_Time;
    long cost;

    // Measure function foo
    gettimeofday(&start_Time, NULL); // Start Timer
    for (int i = 0; i < 1000000; i++) {
        foo();
    }
    gettimeofday(&end_Time, NULL); // End Timer

    cost = (end_Time.tv_sec - start_Time.tv_sec) * 1000000 + (end_Time.tv_usec - start_Time.tv_usec);

    printf("Time cost for function foo() to run 1 million iterations: %ld microseconds\n", cost);
}

void measure_system_call(const char *systemName) {
    struct timeval start_Time, end_Time;
    long cost;

    // Create file pointer for output
    FILE *filePTR;
    filePTR = fopen("output.txt", "w");
    int fd = fileno(filePTR);

    gettimeofday(&start_Time, NULL);

    // For loop that runs the system call one million times
    for (int i = 0; i < 1000000; i++) {
        if (strcmp(systemName, "getuid") == 0) {
            getuid();
        }
        else if (strcmp(systemName, "getppid") == 0) {
            getppid();
        }
        else if (strcmp(systemName, "geteuid") == 0) {
            geteuid();
        }
        else if (strcmp(systemName, "open") == 0) {
            int fd = open("test_file", O_RDONLY | O_CREAT);
            close(fd);
        }
        else if (strcmp(systemName, "close") == 0) {
            int fd = open("test_file", O_RDONLY | O_CREAT);
            close(fd);
        }
        else if (strcmp(systemName, "getcwd") == 0) {
            char cwd[1024];
            getcwd(cwd, sizeof(cwd));
        }
        else if (strcmp(systemName, "gethostname") == 0) {
            char hostName[1024];
            gethostname(hostName, sizeof(hostName));
        }
        else if (strcmp(systemName, "write") == 0) {
            write(fd, "Hello World!", 10);
        }
        else if (strcmp(systemName, "read") == 0) {
            char buffer[100];
            read(fd, buffer, 10);
        }
    }
    gettimeofday(&end_Time, NULL); // End Timer

    cost = (end_Time.tv_sec - start_Time.tv_sec) * 1000000 + (end_Time.tv_usec - start_Time.tv_usec);
    printf("Time cost for system call to run 1 million iterations (%s): %ld microseconds\n", systemName, cost);

    close(fd);
    fclose(filePTR);
}
// Main that runs all the calls and outputs result
int main() {
    measure_function_call();

    measure_system_call("getuid");
    measure_system_call("getppid");
    measure_system_call("geteuid");
    measure_system_call("open");
    measure_system_call("close");
    measure_system_call("getcwd");
    measure_system_call("gethostname");
    measure_system_call("write");
    measure_system_call("read");

    return 0;
}