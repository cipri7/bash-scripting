#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <limits.h>

void copy_file(const char *src, const char *dest) {
    FILE *source = fopen(src, "rb");
    FILE *destination = fopen(dest, "wb");
    char buffer[512];
    size_t bytes_read;

    while ((bytes_read = fread(buffer, 1, sizeof(buffer), source)) > 0) {
        fwrite(buffer, 1, bytes_read, destination);
    }

    fclose(source);
    fclose(destination);
}

void process_entry(const char *src_path, const char *dest_path) {
    struct stat st;

    if (lstat(src_path, &st) == -1) {
        perror("lstat");
        exit(EXIT_FAILURE);
    }

    if (S_ISDIR(st.st_mode)) {
        // Director
        mkdir(dest_path, st.st_mode);
        printf("Director creat: %s\n", dest_path);

        DIR *dir = opendir(src_path);
        if (dir == NULL) {
            perror("opendir");
            exit(EXIT_FAILURE);
        }

        struct dirent *entry;
        while ((entry = readdir(dir))) {
            if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                continue;
            }

            char src_entry[PATH_MAX];
            char dest_entry[PATH_MAX];

            snprintf(src_entry, PATH_MAX, "%s/%s", src_path, entry->d_name);
            snprintf(dest_entry, PATH_MAX, "%s/%s", dest_path, entry->d_name);

            process_entry(src_entry, dest_entry);
        }

        closedir(dir);
    } else if (S_ISREG(st.st_mode)) {
        // Fișier obișnuit
        if (st.st_size < 500) {
            copy_file(src_path, dest_path);
            /*
            Operatorul & (și) este folosit pentru a aplica o operație de "și logic" între valorile drepturilor din st.st_mode
            și o combinație de drepturi specificate în expresie.
            (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH) 
            este o combinație de drepturi specificate care reprezintă drepturile de citire și scriere pentru proprietarul fișierului,
            grupul fișierului și alți utilizatori (toți ceilalți).
            */
            chmod(dest_path, st.st_mode & (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH));
            printf("Copie creată: %s\n", dest_path);
        } else {
            link(src_path, dest_path);
            chmod(dest_path, st.st_mode);
            printf("Legătură simbolică creată: %s\n", dest_path);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <src_dir> <dest_dir>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char *src_dir = argv[1];
    const char *dest_dir = argv[2];

    process_entry(src_dir, dest_dir);

    return 0;
}
