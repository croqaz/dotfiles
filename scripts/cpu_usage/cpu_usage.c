// Licensed under the terms of the GNU GPL v3, or any later version.
//
// Copyright 2021 Cristi Constantin <cristi.constantin@sent.com>
//
// Initially based on i3blocks-contrib/cpu_usage2, but completely re-written
// Also inspired by procps/proc/sysinfo.c, busybox/procps/top.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>

#define MAX_CPUS 10
#define MAX_VALU 9.0

typedef unsigned long long int ulli;

char* label = "C=";
char* delim = " ";

// Todo: maybe allow user to change them
const char* warn_c = "#FE8019";
const char* crit_c = "#CC241D";

uint warning = (int)(0.75 * MAX_VALU);
uint critical = (int)(0.9 * MAX_VALU);

struct ProcStat {
    ulli old_used;
    ulli old_total;
    ulli new_used;
    ulli new_total;
};

struct ProcStat proc_stats[MAX_CPUS];

const char fmt[] = "cpu%[^ ] %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu";

void help(char* argv[]) {
    printf("Usage: %s "
        "[-t seconds] [-w int] [-c int] [-l label] [-s delim] [-h]\n",
        argv[0]);
    printf("\n");
    printf("-t seconds\tSet refresh time (default is 1.0)\n");
    printf("-l label\tLabel to print before the CPU usage (default: '')\n");
    printf("-s delim\tSeparator to print between CPU numbers (default: ' ')\n");
    printf("-w \t\tSet warning limit for CPU usage. (default: %u)\n", warning);
    printf("-c \t\tSet critical limit for CPU usage. (default: %u)\n", critical);
    printf("-h \t\tThis help\n");
    printf("\n");
}

void display() {
    static uint usage;
    printf("%s<span>", label);

    for (ushort i = 0; i < MAX_CPUS; i++) {
        if (proc_stats[i].old_total < 1) {
            break;
        }
        usage = (uint)(
            MAX_VALU *
            (proc_stats[i].new_used - proc_stats[i].old_used) /
            (proc_stats[i].new_total - proc_stats[i].old_total)
            );

        if (i > 0) {
            printf(delim);
        }

        if (critical > 0 && usage >= critical) {
            //printf("<span color='%s'>%i=%d</span>", crit_c, i, usage);
            printf("<span color='%s'>%d</span>", crit_c, usage);
        }
        else if (warning > 0 && usage >= warning) {
            //printf("<span color='%s'>%i=%d</span>", warn_c, i, usage);
            printf("<span color='%s'>%d</span>", warn_c, usage);
        }
        else {
            //printf("%i=%d", i, usage);
            printf("%d", usage);
        }
    }

    printf("</span>\n");
}

void update_cpu_line(FILE* fp) {
    static char scpu;
    static uint icpu;
    static ulli used, user, nic, sys, idle, iowait, irq, sirq, steal, guest, nguest;
    // longest CPU line I have seen is 63
    char line_buf[64];
    if (!fgets(line_buf, sizeof(line_buf), fp) || line_buf[0] != 'c' /* not "cpu" */) {
        return;
    }
    int ret = sscanf(line_buf, fmt,
        &scpu, &user, &nic, &sys, &idle, &iowait, &irq, &sirq, &steal,
        &guest, &nguest);
    if (ret > 10) {
        icpu = atoi(&scpu);
        used = user + nic + sys + irq + sirq + steal + guest + nguest;
        proc_stats[icpu].new_used = used;
        proc_stats[icpu].new_total = used + idle + iowait;
    }
    return;
}

void read_proc_stat() {
    FILE* fp = fopen("/proc/stat", "r");
    if (fp == NULL) {
        perror("Couldn't open /proc/stat\n");
        exit(EXIT_FAILURE);
    }
    for (ushort i = 0; i < MAX_CPUS + 2; i++) {
        // the function will only update matching lines
        update_cpu_line(fp);
    }
    fclose(fp);
    return;
}

void sync_new_old_stat() {
    for (ushort i = 0; i < MAX_CPUS; i++) {
        proc_stats[i].old_used = proc_stats[i].new_used;
        proc_stats[i].old_total = proc_stats[i].new_total;
    }
}

int main(int argc, char* argv[]) {
    const uint m = 1000.0 * 1000.0;
    float t = 1.0;
    int c;

    while (c = getopt(argc, argv, "ht:w:c:l:s:"), c != -1) {
        switch (c) {
        case 'h':
            help(argv);
            return EXIT_SUCCESS;
        case 't':
            t = atof(optarg);
            break;
        case 'w':
            warning = atoi(optarg);
            break;
        case 'c':
            critical = atoi(optarg);
            break;
        case 'l':
            label = optarg;
            break;
        case 's':
            delim = optarg;
            break;
        }
    }

    // printf("Label=%s, Delim=%s, T=%f, W=%d, C=%d\n", label, delim, t, warning, critical);

    read_proc_stat();
    sync_new_old_stat();

    while (1) {
        usleep(t * m);
        read_proc_stat();
        display();
        sync_new_old_stat();
        fflush(stdout);
    }

    return EXIT_SUCCESS;
}
