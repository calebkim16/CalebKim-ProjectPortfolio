//
// Created by Caleb Kim on 2/17/25.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
    // Opens a text file and checks if done successfully
    int fd = open("CalebKim.txt", O_RDONLY);
    if (fd < 0) {
        perror("Error opening file");
        exit(1);
    }

    // Create a buffer to store characters
    char ch;

    // Fork a process
    pid_t pid = fork ();

    if ( pid == -1 ) {
        perror("Error creating process");
        exit(1);
    }
    else if ( pid == 0) { // child process
        read(fd, &ch, 1);
        printf("Child Process: %c\n", ch);
    }
    else { // in parent process
        read(fd, &ch, 1);
        printf("Parent Process: %c\n", ch);
    }

    close(fd); // close file descriptor
    exit(0);
}
