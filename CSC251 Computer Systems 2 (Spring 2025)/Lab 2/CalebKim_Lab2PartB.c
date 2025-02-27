//
// Created by Caleb Kim on 2/17/25.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <fcntl.h>

int main()
{
    // Opens a text file and checks if done successfully
    int fd = open("CalebKim.txt", O_RDONLY);
    if (fd < 0) {
        perror("Error opening file");
        exit(1);
    }

    // Create a buffer to store characters
    char ch_buffer[6];
    ch_buffer[5] = '\0';

    // Fork a process
    pid_t pid = fork ();
    pid_t wait(int *status);

    if ( pid == -1 ) {
        perror("Error creating process");
        exit(1);
    }
    else if ( pid == 0) { // child process
        printf("Child Process: ");
        for (int i = 0; i < 5; i++) {
            read(fd, &ch_buffer[i], 1);
        }
        printf("%s\n", ch_buffer);
    }
    else { // in parent process
        printf("Parent Process: ");
        for (int i = 0; i < 5; i++) {
            read(fd, &ch_buffer[i], 1);
        }
        printf("%s\n", ch_buffer);
    }

    close(fd); // close file descriptor
    wait(0);
    return 0;
}